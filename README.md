# Automerge action

This action automatically approves and merges PRs. The use case for this is to automerge pull requests opened by Dependabot if tests pass. It has an exponential backoff retry in case there are hiccups with Github.

## Prerequisites

You need to allow actions to create and approve pull requests for your repository or organization. `Settings -> Actions -> General -> Allow GitHub Actions to create and approve pull requests`

## Usage

    jobs:
        automerge:
            runs-on: ubuntu-latest
            permissions:
                pull-requests: write
                contents: write
            if: |
                github.event.pull_request.user.login == 'dependabot[bot]' ||
                github.event.pull_request.user.login == 'dops-sre'
            steps:
                - name: Automerge dependabot and repo-updater PRs
                  uses: elisa-actions/automerge@v1

## Inputs


- `retry-max-attempts`: (Optional) Maximum attempts to retry in case PR approve or merge fails. Default 5.
- `retry-base-delay`: (Optional) Base for delay between retries. Default 3.
- `retry-max-delay`: (Optional) Maximum delay for a retry. Default 60.