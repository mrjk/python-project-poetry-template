# Project conventions

## General

- We prefer `*.yml` instead of `*.yaml`

## TaskDev

Configuration:

```
Taskfile.yml
```

Should respect this principles: https://github.com/dxw/scripts-to-rule-them-all

Except that each task:

- Must use `serve` instead of `server`
- You can group tasks with a topic prefix, like `doc_setup`, `doc_setup`, `tests_setup` ...

Main entry points scripts

- bootstrap
  - Doc: Resolve all dependencies that the application requires to run.
  - Usage: pip/yarn/npm/gem install
- setup
  - Doc: Set up the application for the first time after cloning, or set it back to the initial unused state.
  - Usage: remove `dist/*` and rerun bootstrap
- update
  - Doc: Update the application to run for its current checkout.
  - Usage: git pull/rebase main/develop, refresh project deps
- test
  - Doc: Run the test suite for the application. Optionally pass in a path to an individual test file to run a single test.
  - Usage: pytest, pylint, black, flake
- serve (server)
  - Doc: Launch the application and any extra required processes locally
  - Usage: mkdocs serve, jupyter-notebook
- serve_stop (new)
  - Doc: Stop a backgrounded started service
  - Usage: kill mkdocs serve, kill jupyter-notebook
- build
  - Doc: Should create a production build of the application
  - Usage:
- console
  - Doc: script/console should open a console for the application
  - Usage: docker-compose logs, cmd -vvv --debug

Other words:

- debug
  - Doc:
  - Usage:
- debug
  - Doc:
  - Usage:
- clean
  - Doc: Remove or delete artifacts
  - Usage: `rm dists/*.whl`
- bump
  - Doc: Change application version
  - Usage: poetry version major
  - depends: tests, lint
- lint
  - Doc: Lint the code
  - Usage: black, pylint
  - depends:
- release
  - Doc: Release a new version
  - Usage: poetry version
  - depends: tests, lint
- report
  - Doc: Show corevarge report, performance output, benchmarks
  - Usage: pytest --cov=...
  - depends: tests, lint
- publish (gh_publish, git_publish, gl_publish)
  - Doc: Publish on repository
  - Usage: semantic-release publish, publish build & publish
  - depends: buid
- changelog
  - Doc: Generate the current changelod
  - Usage: semantic-release changelog

Developement shortcuts:

- dev
  - Doc: Put the developer on a correct branch to start to develop
  - Usage: git checkout develop; git pull
- dev_bootstrap:
  - Doc: Flush the current environment and start a fresh development
  - Usage: pip install poetry, poetry install --no-root
- dev_setup:
  - Doc: Install the software and its dev dependencies
  - Usage: poetry install
- dev_release:
  - Doc: Release a develop version
  - Usage:
- dev_update:
  - Doc:
  - Usage:
- dev_update:
  - Doc:
  - Usage:

## Commit messages

See Angular
