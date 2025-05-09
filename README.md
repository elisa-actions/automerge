# Automerge action

This action automatically approves and merges PRs. The use case for this is to automerge pull requests opened by Dependabot if tests pass. It has an exponential backoff retry in case there are hiccups with Github.

## Prerequisites

Create a PAT for a suitable use that can approve and merge pull requests. Save PAT to secrets.

## Usage

    jobs:
        automerge:
            runs-on: ubuntu-latest
            if: |
                github.event.pull_request.user.login == 'dependabot[bot]' ||
                github.event.pull_request.user.login == 'foobar'
            steps:
                - name: Automerge dependabot and repo-updater PRs
                  uses: elisa-actions/automerge@v1
                  with:
                    github-token: ${{ secrets.VERY_SECRET_TOKEN }}

## Inputs

- `github-token`: (Required) Github PAT to use for approving and merging pull requests.
- `retry-max-attempts`: (Optional) Maximum attempts to retry in case PR approve or merge fails. Default 5.
- `retry-base-delay`: (Optional) Base for delay between retries. Default 3.
- `retry-max-delay`: (Optional) Maximum delay for a retry. Default 60.
