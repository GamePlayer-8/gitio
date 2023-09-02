<p align="center" style="white-space: pre-line;">
  <a href="https://gameplayer-8.codeberg.page/gitio" class="no-highlight">
    <img src="docs/gitio.png" width="200" alt=":gitio-splash:">
  </a>
</p>

<p align="center">
  <b>Codeberg</b>
</p>

<p align="center">
  <a href="https://ci.codeberg.org/repos/12564"><img alt=":woodpecker-ci:" src="https://ci.codeberg.org/api/badges/12564/status.svg" height="20" /></a>
  <a href="https://codeberg.org/GamePlayer-8/gitio"><img alt=":codeberg:" src="https://codeberg.org/Codeberg/GetItOnCodeberg/media/branch/main/get-it-on-neon-blue.png" height="20" /></a>
</p>
<p align="center">
  <b>GitHub</b>
</p>

<p align="center">
  <a href="issues"><img alt=":github_issues:" src="https://img.shields.io/github/issues/GamePlayer-8/gitio" height="20" /></a>
  <a href="discussions"><img alt=":code_size:" src="https://img.shields.io/github/languages/code-size/GamePlayer-8/gitio" height="20" /></a>
  <a href="https://github.com/GamePlayer-8/gitio"><img alt=":give_a_star:" src="https://img.shields.io/badge/Give_a-Star_⭐-green" height="20" /></a>
  <a href="https://github.com/GamePlayer-8/gitio"><img alt=":forks:" src="https://img.shields.io/github/forks/GamePlayer-8/gitio" height="20" /></a>
  <a href="https://github.com/GamePlayer-8/gitio"><img alt=":stars:" src="https://img.shields.io/github/stars/GamePlayer-8/gitio" height="20" /></a>
  <a href="pulls"><img alt=":pulls:" src="https://img.shields.io/github/issues-pr/GamePlayer-8/gitio" height="20" /></a>
  <a href="discussions"><img alt=":discussions:" src="https://img.shields.io/github/discussions/GamePlayer-8/gitio" height="20" /></a>
</p>

A GitIO is an action for interacting with the git repository hosting & adds additional features.

# Usage

GitIO supports both Woodpecker CI (Drone CI) & GitHub Actions.

## GitHub
<details>
<summary>View usage for GitHub</summary>
The usage is as follows:

```yaml
name: Your great workflow

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: gameplayer-8/gitio@v1
```

### Advanced options

Checkout with `git clone` advanced functionality:

```yaml
- name: Checkout
  uses: gameplayer-8/gitio@v1
  with:
    type: 'checkout'
    cmd: '--recursive -b gh-pages'
    wizard: 'true'
```

Full functionality of `git clone` is available under command `git clone --help` on your computer.
<br/>
Environment variables:

 - `GITHUB_NAME`
 - `GITHUB_TOKEN`
 - `GITHUB_OWNER`
 - `GITHUB_REPO`

Implement those variables by diabling Setup Wizard & setting them up manually in the environment.

<hr/>

Branch upload:

```yaml
- name: Upload branch to gh-pages
  uses: gameplayer-8/gitio@v1
  with:
    type: 'branch'
    cmd: 'GIT_WORKDIR:/home/github/pages GIT_EMAIL:user@gmail.com'
```

Full list of environment variables for `cmd`:

 - `GIT_BRANCH`
 - `GIT_USERNAME`
 - `GIT_TOKEN`
 - `GIT_EMAIL`
 - `GIT_HOST`
 - `GIT_WORKDIR`
 - `GIT_PROJECT_NAME`
 - `GIT_REPO`

<hr/>

Container publishment:

```yaml
- name: Upload branch to gh-pages
  uses: gameplayer-8/gitio@v1
  with:
    type: 'container'
    cmd: 'OUTPUT_IMAGE_NAME:alpine:latest GIT_WORKDIR:.'
```

Full list of environment variables for `cmd`:

 - `OUTPUT_IMAGE_NAME`
 - `GIT_WORKDIR`
 - `GIT_HOST`
 - `GIT_USERNAME`
 - `GIT_TOKEN`

<hr/>
</details>

## Codeberg

<details>
<summary>View usage for Codeberg</summary>

Since Woodpecker CI lacks in action functionality,
you would need to execute `curl https://gameplayer-8.codeberg.page/gitio/get.sh | sh`.
<br/>

Usage in the workflow:

```yaml
# .woodpecker.yml
when:
  branch: [main]

steps:
  main:
    image: codeberg.org/gameplayer-8/gitio
    commands:
      - curl https://gameplayer-8.codeberg.page/gitio/get.sh | sh
      - gitio branch GIT_BRANCH:pages
      - gitio container OUTPUT_IMAGE_NAME:$CI_REPO_NAME:$(basename "$CI_COMMIT_REF")
    secrets:
      - SYSTEM_TOKEN
      - SYSTEM_TOKEN_PASSWD
      - OCI_TOKEN
```

 - `SYSTEM_TOKEN` is an SSH private key for accessing I/O of the Codeberg repo.
 - `SYSTEM_TOKEN_PASSWD` is a standard token for git I/O (recommended).
 - `OCI_TOKEN` is for container publishment.

<br/>

Usage is pretty similar to the GitHub version (environment variable stays the same).

<br/>

Woodpecker has a lot of `CI_*` variables, what you can override more easily than on GitHub.

</details>

# Download for distro

Currently Arch based & Debian based distros are supported.

## Debian

`curl -LO "https://gameplayer-8.codeberg.page/gitio/packages/gitio.deb && dpkg -i gitio.deb`

## Arch

`curl -LO "https://gameplayer-8.codeberg.page/gitio/packages/PKGBUILD && makepkg -si`

### AUR

`yay -S gitio-chimmie`

# Contributing

All contributions are welcome! Expect a bit of mess tho.

# License

[Akini License 3.1](LICENSE.txt)
