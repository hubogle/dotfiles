#===================histdb==========================
HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
autoload -Uz add-zsh-hook
if [[ -f "$HISTDB_FILE" ]]; then
  _histdb_query () { # https://github.com/larkery/zsh-histdb/issues/27
      sqlite3 "${HISTDB_FILE}" ".timeout 100
  $@"
      [[ "$?" -ne 0 ]] && echo "error in $@"
  }
  _zsh_autosuggest_strategy_histdb_top() {
      local query="
          select commands.argv from history
          left join commands on history.command_id = commands.rowid
          left join places on history.place_id = places.rowid
          where commands.argv LIKE '$(sql_escape $1)%'
          group by commands.argv, places.dir
          order by places.dir != '$(sql_escape $PWD)', count(*) desc
          limit 1
      "
      suggestion=$(_histdb_query "$query")
  } # 查找在当前目录或任何子目录中发出的最常发出的命令
  ZSH_AUTOSUGGEST_STRATEGY=histdb_top
fi
histdb-fzf-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(histdb --host --sep 999 | awk -F'999' '{ if (!seen[$5]++) {print $5} }' |
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind='ctrl-d:execute(source ~/.zi/plugins/larkery---zsh-histdb/sqlite-history.zsh && yes | histdb --forget --exact --yes {} > /dev/null 2>&1)' -n2..,.. --tiebreak=index $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m --tac" fzf) )
  LBUFFER=$selected
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
} # 在 fzf 中选中命令命令 control + d 执行删除
zle     -N   histdb-fzf-widget
bindkey '^R' histdb-fzf-widget
