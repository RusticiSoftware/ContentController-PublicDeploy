To install Hugo, run `./install.sh`.

To run the Hugo docs locally, run `hugo server -D`.

To generate the static files, just run `hugo` from this directory. Then all of the static files will be generated into 
the `public` directory.

To change the theme or add a new submodule run 
```bash 
cd themes
git submodule add https://github.com/RusticiSoftware/rustici-docs-hugo-theme.git
```