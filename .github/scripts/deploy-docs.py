#!/usr/bin/env python3
"""Resolve docs refs, then the workflow deploys them."""
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request

VERSION_RE = re.compile(r"^[Vv]?(\d+\.\d+\.\d+)$")
CC_SLUG = "RusticiSoftware/ContentController"


def die(msg):
    sys.stderr.write(msg + "\n")
    sys.exit(1)


def sh(*args, cwd=None):
    return subprocess.check_output(args, cwd=cwd, text=True).strip()


def emit(**kwargs):
    path = os.environ.get("GITHUB_OUTPUT")
    if not path:
        return
    with open(path, "a", encoding="utf-8") as fh:
        for key, value in kwargs.items():
            fh.write(f"{key}={value}\n")


def log_targets(tag, api_short, api_url, docs_short, docs_url):
    print(f"Tag: {tag}")
    print(f"API commit: {api_short} {api_url}")
    print(f"Docs commit: {docs_short} {docs_url}")
    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary:
        with open(summary, "a", encoding="utf-8") as fh:
            fh.write(
                f"Tag: `{tag}`\n\n"
                f"API commit: [`{api_short}`]({api_url})\n\n"
                f"Docs commit: [`{docs_short}`]({docs_url})\n"
            )


def latest_release_tag():
    # Newest published Content Controller release. GitHub skips drafts and prereleases.
    try:
        release = gh("GET", "releases/latest")
    except urllib.error.HTTPError as err:
        die(f"GitHub API {err.code} GET releases/latest: {getattr(err, 'details', '')}")
    tag = (release.get("tag_name") or "").strip()
    if not tag:
        die("Latest Content Controller release has no tag")
    return tag


def hugo_branch(version):
    major_minor = version.rsplit(".", 1)[0]
    parts = tuple(int(p) for p in major_minor.split("."))
    return major_minor if parts >= (4, 2) else "main"


def as_tag(value):
    match = VERSION_RE.match(value.strip())
    return f"v{match.group(1)}" if match else None


def require_tag(cc, raw):
    tag = as_tag(raw or "")
    if not tag:
        die(f"Invalid tag '{raw}'. Use X.Y.Z or vX.Y.Z.")
    if subprocess.call(
        ["git", "rev-parse", "--verify", f"refs/tags/{tag}"],
        cwd=cc,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ) != 0:
        die(f"ContentController tag {tag} not found")
    return tag


def require_commit(repo, raw, label):
    if as_tag(raw):
        die(f"{label} must be a commit SHA, not a tag. Use the tag input instead.")
    try:
        return sh("git", "rev-parse", "--verify", f"{raw}^{{commit}}", cwd=repo)
    except subprocess.CalledProcessError:
        sh("git", "fetch", "origin", raw, "--no-tags", cwd=repo)
        return sh("git", "rev-parse", "--verify", f"{raw}^{{commit}}", cwd=repo)


def tag_date(cc, tag, fallback_sha):
    date = sh("git", "for-each-ref", "--format=%(creatordate:iso-strict)", f"refs/tags/{tag}", cwd=cc)
    return date or sh("git", "log", "-1", "--format=%cI", fallback_sha, cwd=cc)


def cmd_resolve():
    cc = os.environ["CC_REPO"]
    public = os.environ["PUBLIC_REPO"]
    public_slug = os.environ.get("PUBLIC_REPO_SLUG") or os.environ.get("GITHUB_REPOSITORY")
    tag_input = os.environ.get("TAG_INPUT", "").strip()
    api_input = os.environ.get("API_REF_INPUT", "").strip()
    hugo_input = os.environ.get("HUGO_REF_INPUT", "").strip()

    sh("git", "fetch", "--tags", "--force", "--prune", cwd=cc)
    sh("git", "fetch", "origin", "--prune", "+refs/heads/*:refs/remotes/origin/*", cwd=public)

    if api_input:
        api_sha = require_commit(cc, api_input, "api_ref")
        nearest = as_tag(sh("git", "describe", "--tags", "--abbrev=0", api_sha, cwd=cc))
        if not nearest:
            die(f"Could not infer X.Y.Z version from commit {api_input}")
        tag = nearest
    elif tag_input:
        tag = require_tag(cc, tag_input)
        api_sha = sh("git", "rev-parse", "--verify", f"{tag}^{{commit}}", cwd=cc)
    else:
        tag = require_tag(cc, latest_release_tag())
        api_sha = sh("git", "rev-parse", "--verify", f"{tag}^{{commit}}", cwd=cc)

    version = tag[1:]
    if hugo_input:
        hugo_sha = require_commit(public, hugo_input, "hugo_ref")
    else:
        branch = hugo_branch(version)
        when = tag_date(cc, tag, api_sha)
        hugo_sha = sh("git", "rev-list", "-n", "1", f"--before={when}", f"origin/{branch}", cwd=public)
        if not hugo_sha:
            die(f"No cc-deployment-public commit on {branch} at or before {when}")

    api_short = sh("git", "rev-parse", "--short", api_sha, cwd=cc)
    hugo_short = sh("git", "rev-parse", "--short", hugo_sha, cwd=public)
    api_url = f"https://github.com/{CC_SLUG}/commit/{api_sha}"
    hugo_url = f"https://github.com/{public_slug}/commit/{hugo_sha}"
    log_targets(tag, api_short, api_url, hugo_short, hugo_url)
    emit(
        api_ref=api_sha,
        api_sha_short=api_short,
        api_url=api_url,
        hugo_sha=hugo_sha,
        hugo_sha_short=hugo_short,
        hugo_url=hugo_url,
        tag=tag,
    )


def gh(method, path, body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(
        f"https://api.github.com/repos/{os.environ.get('REPO') or CC_SLUG}/{path}",
        data=data,
        method=method,
        headers={
            "Authorization": f"Bearer {os.environ.get('GH_TOKEN') or os.environ['GITHUB_TOKEN']}",
            "Accept": "application/vnd.github+json",
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            raw = resp.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as err:
        err.details = err.read().decode()
        raise


def main():
    if len(sys.argv) != 2 or sys.argv[1] != "resolve":
        die("Usage: deploy-docs.py resolve")
    cmd_resolve()


if __name__ == "__main__":
    main()
