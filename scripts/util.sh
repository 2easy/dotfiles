#!/usr/bin/env bash

# shellcheck disable=2034
XDG_CONFIG_HOME="${HOME}/.config"

info() {
	printf "\033[36m%s\033[0m\n" "$*" >&2
}

warn() {
	printf "\033[33mWarning: %s\033[0m\n" "$*" >&2
}

error() {
	printf "\033[31mError: %s\033[0m\n" "$*" >&2
	exit 1
}

is_installed() {
	type -P "$1" >/dev/null 2>&1
}

download_to() {
	local path=$1
	local url=$2
	local opts=(--silent --fail --retry-connrefused --retry 5 --location -H "Accept: application/octet-stream")
	if [ -n "${path}" ]; then
		opts+=(--create-dirs --output "${path}")
	fi
	curl "${opts[@]}" "${url}"
}
