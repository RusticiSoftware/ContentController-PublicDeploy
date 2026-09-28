#!/usr/bin/env python3
"""Resolve docs refs and manage the approval issue."""
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request

ZENDESK_URL = (
    "https://support.scorm.com/api/v2/help_center/en-us/sections/"
    "115000419513/articles.json?per_page=100"
)
TITLE_RE = re.compile(r"^Content Controller [Vv](\d+\.\d+\.\d+)$")
VERSION_RE = re.compile(r"^[Vv]?(\d+\.\d+\.\d+)$")
APPROVE_RE = re.compile(r"^\s*/?approve\s*$", re.I)
DENY_RE = re.compile(r"^\s*/?deny\s*$", re.I)
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


def highest_public_version():
    url, versions = ZENDESK_URL, []
    headers = {"User-Agent": "cc-deploy-docs", "Accept": "application/json"}
    while url:
        with urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=60) as resp:
            data = json.load(resp)
        for article in data.get("articles") or []:
            match = TITLE_RE.match(article.get("title") or "")
            if match:
                versions.append(match.group(1))
        url = data.get("next_page")
    if not versions:
        die("No versioned release-note articles found")
    return sorted(versions, key=lambda v: tuple(int(p) for p in v.split(".")))[-1]


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
    if api_input or hugo_input:
        tag_input = ""
    needs_confirm = str(not api_input or not hugo_input).lower()

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
        tag = require_tag(cc, highest_public_version())
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
        needs_confirm=needs_confirm,
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


def cmd_create_issue():
    actor = os.environ["ACTOR"]
    tag = os.environ["TAG"]
    body = (
        f"@{actor}: confirm docs deploy.\n\n"
        f"- Tag: `{tag}`\n"
        f"- API commit: [`{os.environ['API_SHA_SHORT']}`]({os.environ['API_URL']})\n"
        f"- Docs commit: [`{os.environ['HUGO_SHA_SHORT']}`]({os.environ['HUGO_URL']})\n\n"
        "Reply `approve` or `deny`, or thumbs-up to approve.\n"
    )
    try:
        issue = gh("POST", "issues", {"title": f"Confirm docs deploy {tag}", "body": body})
    except urllib.error.HTTPError as err:
        if err.code == 410:
            die("Issues are disabled on this repo. Enable Settings → General → Features → Issues.")
        die(f"GitHub API {err.code} POST issues: {getattr(err, 'details', '')}")
    try:
        gh("PATCH", f"issues/{issue['number']}", {"assignees": [actor]})
    except urllib.error.HTTPError:
        print(f"::warning::Could not assign @{actor}. They can still approve on the issue.")
    number, url = issue["number"], issue["html_url"]
    emit(issue_number=number, issue_url=url)
    print(f"Opened approval issue {url}")


def issue_decision(number):
    if gh("GET", f"issues/{number}").get("state") == "closed":
        return "denied", None
    denied_by = approved_by = None
    for comment in gh("GET", f"issues/{number}/comments"):
        login = (comment.get("user") or {}).get("login") or ""
        text = comment.get("body") or ""
        if DENY_RE.match(text):
            denied_by = login
        elif APPROVE_RE.match(text):
            approved_by = login
    for reaction in gh("GET", f"issues/{number}/reactions"):
        login = (reaction.get("user") or {}).get("login") or ""
        if reaction.get("content") == "-1":
            denied_by = login
        elif reaction.get("content") == "+1":
            approved_by = login
    if denied_by:
        return "denied", denied_by
    if approved_by:
        return "approved", approved_by
    return "pending", None


def cmd_wait():
    number = os.environ["ISSUE_NUMBER"]
    deadline = time.time() + int(os.environ.get("TIMEOUT_SECONDS", "300"))
    poll = int(os.environ.get("POLL_SECONDS", "20"))
    print(f"Waiting for approval on issue #{number}")
    while time.time() < deadline:
        decision, login = issue_decision(number)
        if decision == "approved":
            emit(decision="approved")
            print(f"Approved by @{login}")
            return
        if decision == "denied":
            emit(decision="denied")
            die(f"Denied by @{login or 'unknown'} (or issue was closed)")
        time.sleep(poll)
    emit(decision="timeout")
    die(f"Timed out waiting for approval on issue #{number}")


def cmd_close():
    number = os.environ["ISSUE_NUMBER"]
    actor = os.environ["ACTOR"]
    decision = os.environ.get("DECISION") or (
        "cancelled" if os.environ.get("WAIT_OUTCOME") == "cancelled" else "failed"
    )
    notes = {
        "approved": f"Approved by @{actor}. Deploying docs.",
        "denied": f"Denied by @{actor}. Deploy cancelled.",
        "timeout": f"Timed out waiting for @{actor}. Closed by workflow.",
        "cancelled": "Workflow was cancelled. Closed by workflow.",
    }
    note = notes.get(decision, "Workflow failed. Closed by workflow.")
    try:
        gh("POST", f"issues/{number}/comments", {"body": note})
        gh("PATCH", f"issues/{number}", {"state": "closed"})
    except urllib.error.HTTPError:
        pass
    print(f"Closed issue #{number}: {note}")


def main():
    commands = {
        "resolve": cmd_resolve,
        "create-issue": cmd_create_issue,
        "wait": cmd_wait,
        "close": cmd_close,
    }
    if len(sys.argv) != 2 or sys.argv[1] not in commands:
        die("Usage: deploy-docs.py resolve|create-issue|wait|close")
    commands[sys.argv[1]]()


if __name__ == "__main__":
    main()
