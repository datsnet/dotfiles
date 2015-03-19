## users generic .zshrc file for zsh(1)
 
## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac
 
## rbenv
eval "$(rbenv init -)"

 
## Default shell configuration
#
# set prompt
#
#
# 色
#
autoload colors
colors

# プロンプト
PROMPT="%{${fg[green]}%}%n@%m %{${fg[yellow]}%}%~ %{${fg[red]}%}%# %{${reset_color}%}"
PROMPT2="%{${fg[yellow]}%} %_ > %{${reset_color}%}"
SPROMPT="%{${fg[red]}%}correct: %R -> %r ? [n,y,a,e] %{${reset_color}%}"

# ls
export LSCOLORS=gxfxcxdxbxegedabagacag
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'

# 補完候補もLS_COLORSに合わせて色が付くようにする
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# lsがカラー表示になるようエイリアスを設定
case "${OSTYPE}" in
darwin*)
  # Mac
  alias ls="ls -GF"
  ;;
linux*)
  # Linux
  alias ls='ls -F --color'
  ;;
esac
 
# auto change directory
#
setopt auto_cd
 
# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd
 
# command correct edition before each completion attempt
#
setopt correct
setopt correct_all
 
# compacked complete list display
#
setopt list_packed
 
# no remove postfix slash of command line
#
setopt noautoremoveslash
 
# no beep sound when complete list displayed
#
setopt nolistbeep
 
# TABで順に保管候補を切り替える
#
setopt auto_menu
 
# 保管候補一覧でファイルの種別をマーク
#
setopt list_types
 
# = 以降でも補完できるようにする
#
setopt magic_equal_subst
 
# 補完時の日本語を正しく表示する
#
setopt print_eight_bit
 
# 重複するコマンド行は古い方を削除する
#
setopt hist_ignore_all_dups
 
# 履歴を追加
#
setopt append_history
 
# 履歴をインクリメンタルに追加
#
setopt inc_append_history
 
# 補完時に文字列末尾へカーソル移動
#
setopt always_to_end
 
# あいまい補完時に候補表示
#
setopt auto_list
 
# historyコマンドをヒストリリストから取り除く
#
setopt hist_no_store
 
# コマンドの空白を削る
#
setopt hist_reduce_blanks
 
# 先頭が空白だった場合はログに記述しない
#
setopt hist_ignore_space
 
# ビープ音を出さない
#
setopt no_beep
 
# ヒストリを呼び出してから編集可能な状態にする
#
setopt hist_verify
 
# 保管候補のカーソル選択を有効にする
#
zstyle ':completion:*:default' menu select=1
 
# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
#
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
 
## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -v
bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del
 
# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end
 
# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete
 
 
## Command history configuration

HISTFILE=${HOME}/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
 

#for zsh-completions
if [[ -f /usr/local/share/zsh-completions ]];
then
fpath=(/usr/local/share/zsh-completions $fpath)
fi
 
## Completion configuration
#
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -Uz compinit
compinit -u
compinit
 
 
## zsh editor
#
autoload zed
 
 
## Prediction configuration
#
#autoload predict-on
#predict-on
 
  
# aliasの設定は~/.zsh_aliasesに書けば反映されることになる
if [ -f ~/.zsh_aliases ]; then 
. .zsh_aliases
fi
 
## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine
# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"


#ANDROID_HOME=/Users/datsumi1013/AndroidSDK
ANDROID_HOME=/Users/atsumidaisuke/Library/Android/sdk
PATH=$PATH:$ANDROID_HOME/platform-tools
PATH=$PATH:$ANDROID_HOME/tools

export EDITOR=vim
export VISUAL=vim

# added by travis gem
[ -f /Users/uu054593/.travis/travis.sh ] && source /Users/uu054593/.travis/travis.sh

# cdしなくてもディレクトリ移動
setopt AUTO_CD

# cdコマンドで移動してきた履歴を保存する
setopt AUTO_PUSHD

## コマンド履歴から実行する
function peco-execute-history() {
  local item
  item=$(builtin history -n -r 1 | peco --query="$LBUFFER")

  if [[ -z "$item" ]]; then
    return 1
  fi
  BUFFER="$item"
  CURSOR=$#BUFFER
  zle accept-line
}
zle -N peco-execute-history
bindkey '^Xr' peco-execute-history

## プラグインをまとめて管理する
## Antigen
if [[ -f $HOME/.zsh/antigen/antigen.zsh ]]; 
then 
source $HOME/.zsh/antigen/antigen.zsh
antigen bundle mollifier/anyframe
antigen bundle m4i/cdd.git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply
fi

## anyframe設定
# bindkey '^Xb' anyframe-widget-cdr
bindkey '^Xc' anyframe-widget-checkout-git-branch
bindkey '^Xb' anyframe-widget-insert-git-branch


## vcs_info
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs-info:*' formats '(%s)-[%b]'
zstyle ':vcs-info:*' actionformats '(%s)-[%b|%a]'

function _update_vcs_info_msg() {
  psvar=()
  LNAG=en_US.UTF-8 vcs_info
  psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%v"
