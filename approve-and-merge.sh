#!/usr/bin/env bash
set -euo pipefail

# retry <cmd> [args…]
retry() {
  local attempt=1
  local delay=${INPUT_RETRY_BASE_DELAY}

  local cmd=("$@")

  until "${cmd[@]}"; do
    if (( attempt >= ${INPUT_RETRY_MAX_ATTEMPTS} || delay >= ${INPUT_RETRY_MAX_DELAY} )); then
      echo "❌ [${cmd[*]}] failed after $attempt attempts or reached a delay of ${delay}s. No more retries."

      return 1
    fi

    echo "⚠️  [${cmd[*]}] attempt $attempt failed. Retrying in ${delay}s…"
    sleep "$delay"

    delay=$(( delay * 2 ))
    (( delay > ${INPUT_RETRY_MAX_DELAY} )) && delay=$${INPUT_RETRY_MAX_DELAY}

    (( attempt++ ))
  done

  echo "✅ [${cmd[*]}] succeeded."
}

retry gh pr review --approve "$PR_URL"
retry gh pr merge --auto --merge "$PR_URL"
