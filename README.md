# Python Project Poetry Template

This is a template of a python project with all CI/CD tools implemented.

## Features

* `direnv` support
* `commitizen` support
* `pre-commit` support
* Github Actions support
* Version bumping support

External requirements:

* direnv
* task
* git-flow

## Understand how it works

Making new releases with git is not that simple. Actually, this mechanism with the current tools we have does not
really support well nomenclature change in the git history. If you want to experiment, you may want to sometime
reset your git history to start from a fresh clean.

## Howto

### Completely reset the project

Locally:

* # git clone REPO -b <BRANCH_YOU_WANT_TO_KEEP> RESET
* git clone git@github.com:mrjk/python-project-poetry-template.git -b main RESET
* cd RESET
* rm -rf .git
* git init .
* git add .
* git commit -m "Initial commit"

On github (if you want to clean actions and releases as well):

* Delete your repository
* Recreate your repo with the same name
* Ensure in the settings:
  * Settings/Actions/General
    * Check: Allow all actions
  * Settings/Pages
    * Check: Deploy from branch
    * Branch: gh_page
    * Dir: / (root)

Finally, locally:

* git remote add origin git@github.com:<YOUR ACCOUNT>/<YOUR REPOS>.git
* git push -u --force origin master
