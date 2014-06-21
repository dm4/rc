DIR="$(cd "$(dirname "$0")" && pwd)"

for file in "${DIR}"/*
do
    echo "ln -s \"$file\" \"${HOME}/.$(basename $file)\""
    ln -s "$file" "${HOME}/.$(basename $file)"
done
