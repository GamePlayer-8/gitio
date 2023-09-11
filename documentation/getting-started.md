# GitHub

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
        uses: gameplayer-8/gitio@v4
```

</details>

# Codeberg

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

</details>
