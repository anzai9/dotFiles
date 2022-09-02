#!/usr/bin/env bash

debug () {
  echo $@
}

selected=`cat ~/.tmux-cheat-languages ~/.tmux-cheat-commands | fzf --height=100%  --info=inline --layout=reverse`

if [[ -z selected ]]; then
  exit 0
fi

read -p "Enter query you want to search:" query

if rg -qs "${selected}" ~/.tmux-cheat-languages; then
  query=`echo $query | tr ' ' '+'`
  tmux neww bash -c "curl -s cht.sh/${selected}/${query} | less & while :; do sleep 1; done"
  tmux display-message "curl -s cht.sh/${selected}/${query}"
else
  tmux neww bash -c "curl -s cht.sh/${seletced}+${query} | less"
fi
