DIR="$(cd "$(dirname "$0")" && pwd)"

for file in "${DIR}"/*
do
    if [[ "$(basename $file)" != "install.sh" ]]
    then
        filename="$(basename "$file")"
        target_filename="${HOME}/.${filename}"

        if [[ -f "$target_filename" ]]
        then
            echo "${target_filename} already exist."
        else
            echo "ln -s \"$file\" \"$target_filename\""
            ln -s "$file" "$target_filename"
        fi
    fi
done
