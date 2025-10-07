#!/usr/bin/env bash
set -euo pipefail

# retry <cmd> [args…]
retry() {
  local attempt=1
  local delay=${INPUT_RETRY_BASE_DELAY}

  if [[ "${GITHUB_API_URL}" == "https://api.github.com" ]]; then
    export GH_TOKEN=${INPUT_TOKEN}
  else
    export GH_ENTERPRISE_TOKEN=${INPUT_TOKEN}
  fi

  local cmd=("$@")

  until "${cmd[@]}"; do
    if ((attempt >= ${INPUT_RETRY_MAX_ATTEMPTS} || delay >= ${INPUT_RETRY_MAX_DELAY})); then
      echo "::error::[${cmd[*]}] failed after $attempt attempts or reached a delay of ${delay}s. No more retries."

      return 1
    fi

    echo "::warning::[${cmd[*]}] attempt $attempt failed. Retrying in ${delay}s…"
    sleep "$delay"

    delay=$((delay * 2))
    ((delay > ${INPUT_RETRY_MAX_DELAY})) && delay=$${INPUT_RETRY_MAX_DELAY}

    ((attempt++))
  done

  echo "✅ [${cmd[*]}] succeeded."
}

retry gh pr review --approve "$PR_URL"

DELETE_BRANCH_FLAG=""
if [[ "${INPUT_DELETE_BRANCH}" == "true" ]]; then
  DELETE_BRANCH_FLAG="--delete-branch"
fi

retry gh pr merge $DELETE_BRANCH_FLAG --auto --merge "$PR_URL"
