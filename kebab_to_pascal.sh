#!/bin/bash

# Iterate over all files and directories in the given directory and rename kebab case files to Pascal case.
# Only rename files with the given extension.
rename_files() {
  local dir=$1
  local ext=$2

  for file in "$dir"/*; do
    if [[ -d $file ]]; then
      # If the current item is a directory, recursively call the function.
      rename_files "$file" "$ext"
    elif [[ -f $file ]]; then
      local basename
      basename=$(basename "$file")
      local extension
      extension="${basename##*.}"

      if [[ "$extension" != "$ext" ]]; then
        continue
      fi

      local dirname
      dirname=$(dirname "$file")
      local kebab_case
      kebab_case=$(basename "$file" ".$extension")
      local pascal_case=""

      IFS='-' read -ra words <<< "$kebab_case"

      for word in "${words[@]}"; do
        pascal_case+=$(tr '[:lower:]' '[:upper:]' <<<"${word:0:1}")${word:1}
      done

      local new_name="$dirname/$pascal_case.$extension"

      if [[ $file != "$new_name" ]]; then
        mv "$file" "$new_name"
      fi
    fi
  done
}

# Entry point. The first argument is the directory to search. The second argument is the extension to search for.
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <directory> <extension>"
  exit 1
fi

if [[ ! -d $1 ]]; then
  echo "Error: Directory not found."
  exit 1
fi

rename_files "$1" "$2"
