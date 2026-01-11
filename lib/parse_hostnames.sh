#!/bin/bash

expand_nodes() {
    local input=$1
    if [[ $input =~ (.*)\[(.*)\] ]]; then
        prefix="${BASH_REMATCH[1]}"
        inside_brackets="${BASH_REMATCH[2]}"
        OLD_IFS=$IFS

        IFS=','

        read -ra parts <<< "$inside_brackets"
        IFS=$OLD_IFS

        for part in "${parts[@]}"; do
            if [[ $part =~ ([0-9]+)-([0-9]+) ]]; then
                start="${BASH_REMATCH[1]}"
                end="${BASH_REMATCH[2]}"

                for i in $(seq $start $end); do
                    echo "${prefix}${i}"
                done
            else
                echo "${prefix}${part}"
            fi
        done
    else
        echo "${input}"
    fi
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -w)
            shift
            NODES=$(expand_nodes "$1")

            LIST_INCLUDE="$LIST_INCLUDE $NODES"
            shift
            ;;
        -x)
            shift
            NODES=$(expand_nodes "$1")

            LIST_EXCLUDE="$LIST_EXCLUDE $NODES"
            shift
            ;;
        *)
            COMMAND="$@"
            break
            ;;
    esac
done



FINAL_NODES=""

for node in $LIST_INCLUDE; do
    if ! echo "$LIST_EXCLUDE" | grep -q -w "$node"; then
        FINAL_NODES="$FINAL_NODES $node"

    fi
done

echo "${FINAL_NODES}"