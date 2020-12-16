coveragepy to Github Checks API reporter [![Unlicensed work](https://raw.githubusercontent.com/unlicense/unlicense.org/master/static/favicon.png)](https://unlicense.org/)
========================================

This action is needed to report coverage of python packages collected by [coveragepy](https://github.com/nedbat/coveragepy).

There are some services for reporting coverage. Such as [coveralls](https://coveralls.io/) and [codecov](https://codecov.io/). They have drawbacks:

* they require you to have an account;
* they require you to provide them with your a email (through a permission on GH, without granting it nothing works);
* [some of them require you to provide them with tokens](https://web.archive.org/web/20200916125824/https://docs.codecov.io/docs/quick-start). Tokens have to be kept secretly, so setting up a token for each repo is too much burden.
* [another one uses your GitHub tokens for that and sends it onto an own server](https://github.com/coverallsapp/github-action/blob/198c7931d32bc4bfa3768f698af3332214dae75f/src/run.ts#L52L58). I don't trust them with that.

So we have a different approach. GitHub has a feature allowing custom apps to annotate source code with warnings. So we just create annotations for uncovered lines.

All this is implemented in [`coverage2GHChecksAnnotations.py` python package](https://github.com/KOLANICH/coverage2GHChecksAnnotations.py), if you don't want to use this action, you can use it in your workflows as you like.

This Action assummes python packaging system being already bootstrapped.

It is **strongly recommended** not to use the snippet below, but to fork this repo (and all the libs used) and audit it and use your fork in your projects.

```yaml
on:
  push:
    branches: [ "master" ]
  pull_request:
    branches: [ "master" ]

jobs:
  build:
    runs-on: ubuntu-20.04
    steps:
      - name: annotate the stuff with coverage info
        uses: KOLANICH-GHActions/coveragepyReport@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```
