#!/bin/bash

# get options
while getopts ":f" opt; do
    case $opt in
        # force
        f)
            echo "Force install..."
            force=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# get dirname
DIR="$(cd "$(dirname "$0")" && pwd)"

# install all files
for file in "${DIR}"/*
do
    if [[ "$(basename $file)" != "install.sh" ]]; then
        filename="$(basename "$file")"
        target_filename="${HOME}/.${filename}"

        if [[ -f "$target_filename" ]]; then
            if [[ -n "$force" ]]; then
                echo "rm -f \"$target_filename\""
                rm -f "$target_filename"
                echo "ln -s \"$file\" \"$target_filename\""
                ln -s "$file" "$target_filename"
            else
                echo "${target_filename} already exist."
            fi
        else
            echo "ln -s \"$file\" \"$target_filename\""
            ln -s "$file" "$target_filename"
        fi
    fi
done
