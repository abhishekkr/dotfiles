## depends on a package 'fzf'

f.ex() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

f.exl() {
  local file
  local line

  read -r file line <<<"$( grep -rn "$@" . | fzf -0 -1 | awk -F':' '{print $1, $2}' )"

  if [[ -f "$file" ]]
  then
    if [[ -n "$line" ]]; then
      echo vim $file +$line
    else
      echo "[error] found ${file}, but no line number noted"
    fi
  elif [[ -z "${file}" ]]; then
    echo "no file found matching: "$@
  else
    echo "no file found matching, results ${file}"
  fi
}
