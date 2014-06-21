DIR="$(cd "$(dirname "$0")" && pwd)"

for file in "${DIR}"/*
do
    if [[ "$(basename $file)" != "install.sh" ]]
    then
        echo "ln -s \"$file\" \"${HOME}/.$(basename $file)\""
        ln -s "$file" "${HOME}/.$(basename $file)"
    fi
done
