#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]:-$0}")

. "${SCRIPT_DIR}/helpers.sh"

function get_default_repo_branch() {
  # Check if main exists and use instead of master
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify "$ref"; then
      echo "${ref##*/}"
      return
    fi
  done
  echo master
}

([ "$0" = "${BASH_SOURCE[0]}" ] && display_version 0.14.0) || true
