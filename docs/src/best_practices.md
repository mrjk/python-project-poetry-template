# Developpement Best Practices

## Software design

### Conventions

Standard:

- 12 factors
- Keep a Changelog
- [OpenContainer Image Spec](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)

Implementations:

- [Angular Commit Guideline](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)
- Script to [rule them all](https://github.com/github/scripts-to-rule-them-all/tree/master/script)

### Workflow

Common:

- Generate a changelog
- Make a new release
- Build the documentation
- Run the unit tests

## Developement: Using complimentary tools

### Use direnv

```
Tips: Will help to set project environment variables for development purpose
Lang: Go
Sources: https://github.com/direnv/direnv
Documentation: https://direnv.net/
Config: `.envrc`
```

You will need to accept a first time to execute project environment:

```
direnv allow
```

If you want to see what it does:

```
$ cat .envrc
layout python3
export XDG_CACHE_HOME=.venv/
```

Once enabled, you can run most of the project command. To disable it, just leave the directory. It will
auto reenable next time you come back.

### Use commitizen

```
Tips: Will help to ensure commit messages respect some sort of logic, used for realease logs
Lang: Python
Sources: https://github.com/commitizen-tools/commitizen
Doc: https://commitizen-tools.github.io/commitizen/
Alternatives: [cz-vli](https://github.com/commitizen/cz-cli) (in JS)
Config: `pyproject.toml`, `[.]cz.{toml,json,yaml}`
```

When you finished your modifications, add your files:

```
git add file1 file2
```

Instead of using `git commit`, just use `cz`:

```
$ cz c
? Select the type of change you are committing docs: Documentation only changes
? What is the scope of this change? (class or file name): (press [enter] to skip)
 user_doc
? Write a short and imperative summary of the code changes: (lower case and no period)
 add support for html documentation
? Provide additional contextual information about the code changes: (press [enter] to skip)
 We uses here mkdocs to provide this service
? Is this a BREAKING CHANGE? Correlates with MAJOR in SemVer No
? Footer. Information about Breaking Changes and reference issues that this commit closes: (press [enter] to skip)
```

If you have issue with commit message, either use `cz c` or test your message before:

```
$ cz check -m "docs: hellow world"
Commit validation: successful!
```

Tips about common errors:

- A commit must return with a new line !
- `cz info |& grep 'allowed\|chore'`

Commitizen can either use `pyproject.toml` or `.cz.toml` as a configuration source, but the latter is recommanded.

### Enable pre-commit hooks

```
Tips: Ensure commit respect quality standard, and eventually fix things
Sources: https://github.com/pre-commit/pre-commit
Doc: https://pre-commit.com/
Alternatives: [husky](https://github.com/typicode/husky)
```

Pre-commit needs to hook to your LOCAL git config, it will configure the `Core.HookPath` variable to
use it's own hooks. To enable git to git `pre-commit` hooks, you need to manually run:

```
pre-commit install --install-hooks -t pre-commit -t pre-merge-commit -t pre-push -t prepare-commit-msg -t commit-msg -t post-commit -t post-checkout -t post-merge -t post-rewrite
```

Pre-commit is configured via the `.pre-commit-config.yaml` file. You can tweak what you want to enable.

```
$ head  .pre-commit-config.yaml
default_install_hook_types:
  - commit-msg
  - pre-commit
  - pre-push

repos:
- hooks:
  - id: check-added-large-files
  - id: trailing-whitespace
  - id: check-ast

```

Then you can test your changes:

```
pre-commit run  --hook-stage commit
```

When you want to update your repos, simply run:

```
pre-commit autoupdate
```

### Use TaskDev (Go)

```
Tips: Advantageous alternative to Makefiles configured with yaml. Useful for complex project commands.
Lang: Go
Sources: https://github.com/go-task/task
Docs: https://taskfile.dev/
Alternatives: Makefile
```

To see the list of available commands:

```
$ task -l
task: Available tasks for this project:
* bump: 		Bump code version
* bump_patch_V1: 	Bump minor version
* default: 		Show all commands
* init: 		init environment
```

Taskfile has it's own configuration:

```
vim Taskfile.yaml
```

To run a command:

```
task bump -- 1.5.1
```

To test dry-mode:

```
task --dry-mode init
```

To debug:

```
task -v init
```
