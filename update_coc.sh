#!/usr/bin/env bash
# Copyright (c) 2021 Alexander Upton <alex.upton@gmail.com>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# You can download the latest version of this script from:
# https://github.com/alexanderupton/MiSTer-Scripts

# v0.01 : Alexander Upton : 06/2026 : Initial Release


# ========= IMMUTABLE ================
#set -euo pipefail
set -eo pipefail
IFS=$'\n'
OIFS="$IFS"
OWNER="Coin-OpCollection"
REPO="Distribution-MiSTerFPGA"
REF="main"
REPO_PATH="_Arcade"
DEST="/media/fat/_Arcade/_Coin-Op Collection"
TOKEN="${GITHUB_TOKEN:-}" # optional for public repos, needed for private/rate limits
COC_UPDATED="default"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

auth_args=()
if [[ -n "$TOKEN" ]]; then
  auth_args=(-H "Authorization: Bearer $TOKEN")
fi

mkdir -p "$TMP/extract" "$DEST"

echo;echo "Launching Update Coin-Op Collection"

COC_STATUS(){
  local msg="${1:-Working}"
  local spin='|/-\\'
  local i=0

  while :; do
    printf '\r%s %s' "$msg" "${spin:i++%${#spin}:1}" >&2
    sleep 0.2
  done
}

COC_STATUS_STOP(){
  local status_pid="$1"
  local msg="${2:-Done}"

  kill "$status_pid" 2>/dev/null || true
  wait "$status_pid" 2>/dev/null || true
  printf '\r%s\n' "$msg" >&2
}

COC_PULL(){
  local status_pid
  local rc
  COC_STATUS "Downloading Coin-Op Collection" &
  status_pid=$!

  set +e
  curl -k \
    -fsSL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    "${auth_args[@]}" \
    "https://api.github.com/repos/${OWNER}/${REPO}/tarball/${REF}" |
  tar -xzf - \
    -C "$TMP/extract" \
    --strip-components=1 \
    --wildcards "*/${REPO_PATH}/*"
  rc=$?
  set -e

  if [[ "$rc" -eq 0 ]]; then
    COC_STATUS_STOP "$status_pid" "Downloading Coin-Op Collection... done"
  else
    COC_STATUS_STOP "$status_pid" "Downloading Coin-Op Collection... failed"
    return "$rc"
  fi
}

COC_ZIP(){
  if [ -f "${COC_ZIP_PATH}" ]; then
    BASE_FILE=$(basename ${COC_ZIP_PATH})
    REPO_PATH="${BASE_FILE%.*}"
    export TARGET_DIR="${TMP}/extract/${REPO_PATH}"
    [[ ! -d ${TARGET_DIR} ]] && mkdir ${TARGET_DIR}
    unzip -qq -o "${COC_ZIP_PATH}" -d ${TARGET_DIR}
  fi
}

COC_SYNC(){
  for COC_FILE in $(find $TMP/extract/${REPO_PATH} -type f \( -name '*.mra' -o -name '*.rbf' \)); do
    BASE_FILE=$(basename ${COC_FILE})
    if [[ "$COC_FILE" == */_alternatives/* ]]; then
      ALT_PARENT_DIR=$(basename "$(dirname "$COC_FILE")")
      TARGET_DIR="${DEST}/_alternatives/${ALT_PARENT_DIR}"
    elif [[ "$COC_FILE" == *.rbf ]]; then
      TARGET_DIR="${DEST}/cores"
    else
      TARGET_DIR="${DEST}"
    fi

    [[ ! -d "${TARGET_DIR}" ]] && mkdir -p "${TARGET_DIR}"

    if [ ! -f "${TARGET_DIR}/${BASE_FILE}" ]; then
      rsync -a --delete "${COC_FILE}" "${TARGET_DIR}"
      if [ "$?" == "0" ]; then
        [[ -f "${TARGET_DIR}/${BASE_FILE}" ]] && echo "Installed: ${BASE_FILE}" || echo "Error Updating: ${BASE_FILE}"
        export COC_UPDATED="TRUE"
      fi
    elif ! cmp -s "${COC_FILE}" "${TARGET_DIR}/${BASE_FILE}"; then
      rsync -a --delete "${COC_FILE}" "${TARGET_DIR}"
      if [ "$?" == "0" ]; then
        [[ -f "${TARGET_DIR}/${BASE_FILE}" ]] && echo "Updated: ${BASE_FILE}" || echo "Error Updating: ${BASE_FILE}"
        export COC_UPDATED="TRUE"
      fi
    fi
  done
  [[ "${COC_UPDATED}" != "TRUE" ]] && echo "Complete... No changes";echo
}

#[[ "${1}" == "-f" ]] && COC_ZIP || COC_PULL

if [ "${1}" == "-f" ]; then
  SWITCH="$1"
  [[ -n $2 ]] && export COC_ZIP_PATH=$2
  COC_ZIP
else
  COC_PULL
fi

[[ "$?" == "0" ]] && COC_SYNC
