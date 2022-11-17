# Tooling

This project uses various tools to make it live.

System dependencies:

* [git](https://git-scm.com/)
* [taskdev](https://taskfile.dev/)

Project dependencies:

* poetry:
    * Is is used as main tool to develop the projec.
    * Its role consists in installing, building and releasing python packages
* python-semantic-release:
    * It is used as version bumper
    * Can also be used to upload
    * Alternatives:
        * poetry-bumpversion
        * commitizen
* mkdocs:
    * It is used to generate project documentation via markdown files


Optional developper deps:

* pre-commit:
    * Used to validate commits respect some standards
* commitizen (optional)
    * Used to create compliant git messages


## Documentation

Interesting plugins:

* mkdocs-version-annotations
* mkdocs-latest-release-plugin
*
