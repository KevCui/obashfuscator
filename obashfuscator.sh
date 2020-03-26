#!/usr/bin/env bash
#
# Obfuscate bash script
#
#/ Usage:
#/   ./obashfuscator.sh -f <bash_script> [-n <num>] [-e]
#/
#/ Options:
#/   -f <bash_script>   Input script to obfuscate
#/   -n <num>           Optional, num of times for base64 encoding
#/                      If not set, 1 by default
#/   -e                 Optional, extended mode
#/                      Use bash-obfuscate on top, by default not
#/   -h | --help        Display this help message

set -e
set -u

usage() {
    printf "%b\n" "$(grep '^#/' "$0" | cut -c4-)" && exit 1
}

set_var() {
    _SCRIPT_PATH=$(dirname "$0")
    _POSTFIX="_obfuscated"
}

set_args() {
    expr "$*" : ".*--help" > /dev/null && usage
    _EXTENDED_MODE=false
    while getopts ":hf:n:e" opt; do
        case $opt in
            f)
                _BASH_SCRIPT_FILE="$OPTARG"
                _BASH_SCRIPT_FILE_NAME="$(basename -- "$_BASH_SCRIPT_FILE")"
                ;;
            n)
                _ENCODING_TIME="$OPTARG"
                ;;
            e)
                _EXTENDED_MODE=true
                _OBFUSCATE_CMD="$(command -v bash-obfuscate)" || (echo "[ERROR] bash-obfuscate command not found!" >&2; exit 1)
                ;;
            h)
                usage
                ;;
            \?)
                echo "[ERROR] Invalid option: -$OPTARG" >&2
                usage
                ;;
        esac
    done
}

check_args() {
    if [[ -z "${_BASH_SCRIPT_FILE:-}" ]]; then
        echo "[ERROR] Input bash script is not defined: -f <bash_script>" && usage
    fi
}

encode_base64() {
    # $1: bash script
    # $2: num of times for encoding
    local t n
    [[ ! -f "$1" ]] && echo "[ERROR] $1 doesn't exist!" >&2 && exit 1
    [[ -z "${2:-}" ]] && n=1 || n="$2"

    t=$(sed -E '/^$/d' "$1")

    for (( i = 0; i < n; i++ )); do
        echo "[INFO] base64 encoding $((i+1))..." >&2
        t=$(base64 <<< "$t")
        t="bash -c \"\$(base64 -d <<< \"\\
"$t"\")\" bash \"\$@\""
    done

    echo "$t"
}

obfuscate_script() {
    # $1: bash script
    echo "[INFO] Running bash-obfuscate..." >&2
    $_OBFUSCATE_CMD -o "$1" "$1"
}

main() {
    set_args "$@"
    check_args
    set_var

    local f
    f="${_SCRIPT_PATH}/${_BASH_SCRIPT_FILE_NAME%.*}${_POSTFIX}.sh"
    encode_base64 "$_BASH_SCRIPT_FILE" "${_ENCODING_TIME:-}" > "$f"
    "$_EXTENDED_MODE" && obfuscate_script "$f"
    chmod +x "$f"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
