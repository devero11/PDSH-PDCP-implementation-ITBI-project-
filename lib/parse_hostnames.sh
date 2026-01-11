#!/bin/bash


##############################################
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



##############################################
parse_hostname_args() {
    LIST_INCLUDE=""
    LIST_EXCLUDE=""
    COMMAND=""

    local opt

    while getopts ":w:x:" opt; do
        case "$opt" in
            w)
                NODES=$(expand_nodes "$OPTARG")
                LIST_INCLUDE="$LIST_INCLUDE $NODES"
                ;;
            x)
                NODES=$(expand_nodes "$OPTARG")
                LIST_EXCLUDE="$LIST_EXCLUDE $NODES"
                ;;
            :)
                echo "Error: option -$OPTARG requires an argument" >&2
                return 1
                ;;
            \?)
                echo "Error: invalid option -$OPTARG" >&2
                return 1
                ;;
        esac
    done

    
    if [[ -z "$LIST_INCLUDE" ]]; then
        echo "Error: -w <nodes> is required" >&2
        return 1
    fi
}

##############################################


exclude_hostnames(){

for node in $LIST_INCLUDE; do
    if ! echo "$LIST_EXCLUDE" | grep -q -w "$node"; then
        FINAL_NODES="$FINAL_NODES $node"

    fi
done
}




