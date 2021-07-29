#!/usr/bin/env bash

validate_json() {
    
    # Git diffs
    HEAD_COMMIT=$(git rev-parse origin/$GITHUB_HEAD_REF)
    BASE_COMMIT=$(git rev-parse origin/$GITHUB_BASE_REF)
    jsonArray=()
    mapfile jsonArray < <(git diff --name-only $BASE_COMMIT..$HEAD_COMMIT)

    ## Validate JSON structure for all changed JSON files
    for elem in "${jsonArray[@]}"; do

        filename=${elem//$'\n'/}
        if [ "${filename: -5}" == ".json" ]; then 

            echo "LOG: $filename identified as a json"
            linted=$(./node_modules/.bin/jsonlint "$filename")

            if [ ! -f $filename ]; then
                echo "$filename is deleted, skipping..."
            elif [[ -z $linted ]]; then
                echo "ERROR: $filename is Invalid"
                exit 1
            else
                echo "LOG: $filename is Valid"
            fi
        else
            echo "LOG: $filename does not have a .json extension"

        fi

    done

}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    validate_json "$@"
fi
