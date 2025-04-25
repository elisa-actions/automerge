# Automerge action

This action automatically approves and merges PRs. The use case for this is to automerge pull requests opened by Dependabot if tests pass. It has an exponential backoff retry in case there are hiccups with Github.

## Prerequisites

Create a Github App that has permissions for repository contents read/write and pull requests read/write. Save Github app ID to variables and private key to secrets.

## Usage

    jobs:
        automerge:
            runs-on: ubuntu-latest
            if: |
                github.event.pull_request.user.login == 'dependabot[bot]' ||
                github.event.pull_request.user.login == 'dops-sre'
            steps:
                - name: Automerge dependabot and repo-updater PRs
                  uses: elisa-actions/automerge@v1
                  with:
                    github-app-id: ${{ vars.AUTOMERGE_APP_ID }}
                    github-app-private-key: ${{ secrets.AUTOMERGE_APP_PRIVATE_KEY }}

## Inputs

- `github-app-id`: (Required) App ID for the Github app that has permissions to read/write contents and pull requests of repositories.
- `github-app-private-key`: (Required) Private key of the Github app.
- `retry-max-attempts`: (Optional) Maximum attempts to retry in case PR approve or merge fails. Default 5.
- `retry-base-delay`: (Optional) Base for delay between retries. Default 3.
- `retry-max-delay`: (Optional) Maximum delay for a retry. Default 60.
