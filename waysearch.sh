#!/usr/bin/env bash

set -uo pipefail

check_tool() {
  for i in "$@"; do
    if ! command -v "$i" > /dev/null; then
      echo "command '$i' not found" >&2
      exit 1
    fi
  done
}

help() {
    echo "usage: $0 [-j] <url>"
    echo "dump all urls matching <url> on web.archive.org"
    echo "options:"
    echo "  -j output in json"
    echo "  -u uniq urls"
}

check_tool curl sort

OUTPUT=txt
UNIQUE=

while getopts ":j:u" opt; do
  case "$opt" in
    j)
      OUTPUT=json
      ;;
    u)
      UNIQUE=y
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      help
      exit 1
      ;;
  esac
  shift
done

if [[ $# == 0 ]]; then
    help
    exit 1
fi

if [[ "$UNIQUE" = y ]]; then
    curl --silent "https://web.archive.org/cdx/search/cdx?url=${1}*&output=${OUTPUT}&fl=original" | sort -u
else
    curl --silent "https://web.archive.org/cdx/search/cdx?url=${1}*&output=${OUTPUT}&fl=original"
fi

# for target in "$@"; do
#   for domain in $(curl --silent "https://crt.sh?output=json&q=$target" | jq -r '.[].name_value' | sort | uniq); do
#     if [[ $RESOLVE == 1 ]]; then
#       dnsdata=$(dig +short "$domain")
#       dnsdata="${dnsdata//$'\n'/ }"
#       echo "$domain $dnsdata"
#     else
#       echo "$domain"
#     fi
#   done
# done