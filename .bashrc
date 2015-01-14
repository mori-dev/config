

if [ `uname` = "Darwin" ]; then
    #mac用のコード
    :
elif [ `uname` = "Linux" ]; then
    #Linux用のコード
    # キーリピート
    if [ $DISPLAY ]; then
      xset r rate 230 60
    fi
fi


# 以下のエラー対策
# error: server certificate verification failed.
# CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none while accessing https:...
# fatal: HTTP request failed
export GIT_SSL_NO_VERIFY=1

alias capture_anime_gif='byzanz-record-region'
alias rake-db-migrate-db-test-clone="bin/rake db:migrate db:test:clone"


[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator


# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"

if [ -d $HOME/.rbenv/bin ]; then
    export RBENV_ROOT=$HOME/.rbenv
    export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init -)"
fi

feature_branch() {
    if [ "${1}" = "" ]; then
        echo "${0} <new feature branch name>"
        return 1
    fi

#    if [ "${GIT_CURRENT_BRANCH}" = "" ]; then
#        echo "not in git repo"
#        return 2
#    fi

    branch_name="feature/kyanny-${1}"
#    git co -b ${branch_name} ${GIT_CURRENT_BRANCH}
    git co -b ${branch_name}
}

alias deploy_ipms2dev='ssh -p 2828 ipmsman@211.14.31.106 "sh /home/ipmsman/scripts/deploy_dev.sh ipms2-dev dev"'

# screen でも 256 color
if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
  export TERM=xterm-256color
fi

# git merge がエディタをひらかないようにする
export GIT_MERGE_AUTOEDIT=no

# $ docspec spec/authority/abilities_spec.rb
# $ docspec spec
alias docspec='rspec --format doc --order default'

alias og='open-github-from-commit'
alias of='open-github-from-file'
alias hub-brouse-commits='hub browse -- commits'
alias hub-brouse-wiki='hub browse -- wiki'
alias gitk-all='gitk --all&'

# http://www.reddit.com/r/commandline/comments/12g76v/how_to_automatically_source_zshrc_in_all_open/
trap "source ~/.bashrc" USR1
alias source-bashrc-all="pkill -usr1 bash"

# function git-co3 {
#     git checkout "$@"; source-bashrc-all
# }

# test -n "$GOLLUM" && pkill $GOLLUM && $GOLLUM --no-live-preview --gollum-path /home/m/Dropbox/wiki &
function gol {
    GOLLUM=$(which gollum)
    test -n "$GOLLUM" && $GOLLUM --no-live-preview --gollum-path /home/m/Dropbox/wiki &
}

alias b='bundle exec'
alias bs='bundle exec spring'

# cat -t -e
# highlight non-printing characters: tab, newline, BOM, nbsp
hl-nonprinting () {
    local C=$(printf '\033[0;36m')
          B=$(printf '\033[0;46m')
          R=$(printf '\033[0m')
          np=$(env printf "\u00A0\uFEFF");
    sed -e "s/\t/${C}&#9657;&$R/g" -e "s/$/${C}&#8267;$R/" -e "s/[$np]/${B}& $R/g";
}

backup(){ cp -pr $1{,.`date +%Y-%m-%dT%H:%M:%S`}; }

#空ディレクトリを削除
alias rmdir_r='find . -depth -type d | xargs rmdir 2> /dev/null'
# cat /proc/cpuinfo で "cpu cores : 2" といった行がある
alias cpuinfo="awk  -F: ' {if(\$1 ~/^model name/){ model[\$2]=+1}} END{for(k in model) { print model[k], k}}' /proc/cpuinfo"


function scd {
  unset TMP_SCD
  until [ $PWD = "/" ]; do
      test -d $PWD/.svn && TMP_SCD=$PWD
      cd ..
  done
  [ ! "$TMP_SCD" = "/" ] && cd $TMP_SCD && unset TMP_SCD
}

function gcd() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}


export GTAGSLABEL=exuberant-ctags

  alias w3m_h="w3m -T text/html"
  alias w3m-dump="w3m -dump"

  # Gitのリポジトリのトップレベルにcd
  function rlog()
  {
      # less $(git rev-parse --show-cdup)/log/development.log >/dev/null 2>&1 && echo "ok"
      it=$(git rev-parse --show-cdup 2>/dev/null)log/development.log &&
      less $it
      # || {
      #   echo "ctags not found or too old." 1>&2
      #   exit 1
      # }

      # dire=$(git rev-parse --show-cdup >/dev/null 2>&1 )log/development.log&& echo $dire
      # git rev-parse --show-cdup  1>/dev/null && echo "ok"
    # cd ./$(git rev-parse --show-cdup) && echo "ok"
  }

# ctags --version >/dev/null 2>&1 || {
#     echo "ctags not found or too old." 1>&2
#     exit 1
# }


  # bind '"\C-j\C-h": "~"'
  # bind '"\C-j\C-k": "|"'

  # bind '"\C-n\C-n": "&"'
  # bind '"\C-j\C-j": """'

  # bind '"\M-\~"':"\"'\""

  # bind "'\C-n\C-n': '''" # これでなぜか c-n で ' が挿入される

# bind "'\C-n': '''" #


  # bind "'\C-j\C-j': '''"
  # bind "'\C-xq': '''"
# bind "'\C-x\C-9': '''"
  # bind "'\C-jJ': '''"



  # bind "'\C-o': '''"

  # bind '"\C-9": """'

  # bind -x '"\C-o": insert_quote'

  # function insert_quote {
  #   printf "\'"
  #   # printf 9
  # }
# bind '"\C-o": '''

# bind -x '"\C-o": ssh user@gateway.example.com'


#  MY_COMPLETION_SOURCE=$HOME/Dropbox/dot/.bash_completion_source
#  MY_COMPLETION_SOURCE_BK=$HOME/Dropbox/dot/.bash_completion_source.bk

  # 重複の削除
#  sort $MY_COMPLETION_SOURCE | uniq > $MY_COMPLETION_SOURCE_BK
#  cp $MY_COMPLETION_SOURCE_BK $MY_COMPLETION_SOURCE

  # sort $MY_COMPLETION_SOURCE |(rm $MY_COMPLETION_SOURCE && uniq > $MY_COMPLETION_SOURCE)

  # function prompt_cmd {
  #   # [ $? -eq "0" ] && echo "`history 1 |sed -e 's/  */ /g'| cut -d' ' -f4-`" >> $MY_COMPLETION_SOURCE
  # }

  # PROMPT_COMMAND=prompt_cmd

  # bind -x '"\C-r": cr'



  # function p {
  #     blip
  # }

  function cr {
    # history |tac |percol | cut -d' ' -f6-
    # history |tac |percol | cut -d' ' -f6- |blip
    # history |tac |cut -d' ' -f6- |sort |uniq -d |percol |blip
    # cat $HISTFILE |grep -v "^#" |sort |uniq -d |percol |blip
    # cat $HISTFILE |grep -v "^#" |sort |uniq |percol |blip
    # eval cat $HISTFILE |grep -v "^#" |sort |uniq |percol
    # eval `cat $HISTFILE |grep -v "^#" |sort |uniq |percol`
    # a=`cat $HISTFILE |grep -v "^#" |sort |uniq |percol`
    # xte 'key Return'
    # sudo apt-get install xautomation
    # xte "str `cat $HISTFILE |grep -v "^#" |sort |uniq |percol`"
    # sudo apt-get install xdotool
    # xdotool type `cat $HISTFILE |grep -v "^#" |sort |uniq |percol`
    # xdotool key `cat $HISTFILE |grep -v "^#" |sort |uniq |percol`

    # xte "str `cat $MY_COMPLETION_SOURCE |percol`"
    xdotool type `cat $MY_COMPLETION_SOURCE |percol`

    # history |cut -d' *' -f6- |sort |uniq -d |percol |blip
    # history |tac |percol | cut -d' ' -f6-
  }

  # http://d.hatena.ne.jp/takuya_1st/20090828/1251474360
  # http://www.cyberciti.biz/faq/unix-linux-bash-history-display-date-time/

  #----------------------------------------------------------------------
  # history
  #----------------------------------------------------------------------

  if [ -w $HOME/Dropbox/dot/.bash_history ] ; then
      HISTFILE=$HOME/Dropbox/dot/.bash_history
  else
      HISTFILE=$HOME/.bash_history
  fi

  # ex. 2011-03-22 08:38:00
  # HISTTIMEFORMAT=" %F %T "
  HISTTIMEFORMAT="%F_%T "
  HISTSIZE=90000
  HISTFILESIZE=90000
  # 連続したコマンドがある場合にのみ重複を排除
  # HISTCONTROL=ignoredups
  # 全履歴に渡って重複を排除
  # HISTCONTROL=erasedups

  # スペースやタブで始まる行をヒストリに記録しない
  HISTCONTROL=ignorespace

  # 履歴ファイルを上書きではなく追加する。
  # 複数のホストで同時にログインすることがあるので、上書きすると危険だ。
  shopt -s histappend
  # "!"をつかって履歴上のコマンドを実行するとき、
  # 実行するまえに必ず展開結果を確認できるようにする。
  shopt -s histverify
  # 履歴の置換に失敗したときやり直せるようにする。
  shopt -s histreedit
  # 端末の画面サイズを自動認識。
  shopt -s checkwinsize
  # "@" のあとにホスト名を補完させない。
  shopt -u hostcomplete
  # つねにパス名のテーブルをチェックする。
  shopt -s checkhash
  # なにも入力してないときはコマンド名を補完しない。
  shopt -s no_empty_cmd_completion

  # h: 直前の履歴 50件を表示する。引数がある場合は過去 1000件を検索する。
  # (history で履歴全部を表示させると多すぎるので)
  function h {
      if [ "$1" ]; then history 1000 | grep "$@"; else history 50; fi
  }
  # H: 直前の履歴 50件を表示する。引数がある場合は過去のすべてを検索する。
  function H {
      if [ "$1" ]; then history | grep "$@"; else history 50; fi
  }


  function tmux2 {
    tmux -f ~/.tmux.conf2
  }




# 動作確認用
# LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH

# 対話的モードの場合
# 対話的モードならプロンプト文字列が設定されている
if [[ "$PS1" ]]; then

  #----------------------------------------------------------------------
  # basic
  #----------------------------------------------------------------------

  ## 新しく作られたファイルのパーミッションがつねに 644 になるようにする
  umask 022

  ## core ファイルを作らせないようにする
  ulimit -c 0

  #突然キー入力できなくなる問題を回避する(C-s, C-q)
  stty stop undef

  ## LOCALE
  export LC_ALL="ja_JP.utf-8"
  # ロケールに関する環境変数をすばやく切替えるためのエイリアス
  alias ja='export LANG=ja_JP.UTF-8; export LANGUAGE=ja_JP.UTF-8; export LC_ALL=ja_JP.UTF-8'
  alias en='export LANG=en; export LANGUAGE=en; export LC_ALL=en'

  #----------------------------------------------------------------------
  # Env vars
  #----------------------------------------------------------------------

#milkode
mcd() {
    local args="$1 $2 $3 $4 $5 $6 $7 $8 $9"
    local dir=`milk dir --top $args`

    if [ "$dir" = "" ]; then
        echo "fatal: Not found package: $1 $2 $3 $4 $5 $6 $7 $8 $9"
    elif [ "$dir" = "Not registered." ]; then
        echo "fatal: Not a package dir: `pwd`"
    else
        cd $dir
        pwd
    fi
}

  if [ -d "$HOME/Dropbox/src-search" ] ; then MILKODE_DEFAULT_DIR=$HOME/Dropbox/src-search/.milkode ; fi

  PATH=~/Dropbox/bin:$PATH
  PATH=~/bin:$PATH
  PATH=$PATH:~/bin
  PATH=$PATH:~/perl5/bin
  PATH=$PATH:/usr/local/bin
  PATH=$PATH:~/bin/google_appengine
  PATH=$HOME/.nodebrew/current/bin:$PATH

  if [ -d "$HOME/.cabal/bin" ] ; then PATH="$HOME/.cabal/bin:$PATH" ; fi

  INFOPATH=$HOME/.emacs.d/info:$INFOPATH
  INFOPATH=$HOME/.emacs.d/info/python-info:$INFOPATH
  INFOPATH=$HOME/.emacs.d/info/emacs-info:$INFOPATH
  INFOPATH=$HOME/.emacs.d/info/r5rs:$INFOPATH
  INFOPATH=$HOME/.emacs.d/share/info:$INFOPATH
  INFOPATH=$INFOPATH:/usr/share/info
  INFOPATH=$INFOPATH:/usr/local/info

  # export CDPATH=.:/opt:~
  # export TERM="xterm-256color"

  PYTHONPATH=~/.emacs.d/elisp/python/py

  # export JAVA_HOME=/usr/local/jdk1.6.0_12
  # PATH=$JAVA_HOME/bin:$PATH:$HOME/bin

  export SVN_EDITOR=/usr/bin/emacs
  export EDITOR=/usr/bin/emacs
  export VISUAL="emacsclient -a emacs"
  # export VISUAL="emacsclient"


  export PAGER=less

  # export GTAGSLABEL=rtags

  # less のステータス行にファイル名と行数、いま何%かを表示するようにする
  export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'
  # これを設定しないと日本語がでない less もあるので一応入れておく
  export JLESSCHARSET=japanese-ujis

  # ls(FSF coreutils) の色を設定
  # other-writable なものは赤い下線
  LS_COLORS="ow=04;31:tw=04;31"
  export LS_COLORS

  # bashオプション設定
  # EOF (Ctrl-D) 入力は 10回まで許可。
  IGNOREEOF=10

  # rsync では ssh を使う
  export RSYNC_RSH=ssh

  #----------------------------------------------------------------------
  # completion
  #----------------------------------------------------------------------

  # /etc/bash_completion.d/ にある補完を有効にする
  if [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
  fi

  # # bash_completion
  # if [ -e $HOME/Dropbox/bin/bash_completion ] ; then
  #   . $HOME/Dropbox/bin/bash_completion
  # fi


  # git の補完
  if [ -e $HOME/Dropbox/bin/git-completion.bash ] ; then
    . $HOME/Dropbox/bin/git-completion.bash
  fi

  # git の補完
  if [ -e $HOME/bin/clbuild-bash-completion.sh ] ; then
    . $HOME/bin/clbuild-bash-completion.sh
  fi

  # django の補完
  if [ -e $HOME/Dropbox/bin/django_bash_completion ] ; then
    . $HOME/Dropbox/bin/django_bash_completion
  fi

  # nave の設定
  # if [ -e $HOME/bin/nave ]; then
      # nave use 0.5.10 >& /dev/null
      # nave use 0.5.10 > /dev/null 2>&1
      # nave use 0.5.10
  # fi

  #----------------------------------------------------------------------
  # prompt
  #----------------------------------------------------------------------

  function google() {
    firefox "http://www.google.com/search?&num=100&q=${@}" &
  }

  # ターミナルが256色に対応しているか
  function is_256_color() {
    ruby -e '256.times {|i| print "\e[48;5;#{i}m \e[m"}';
  }

  function e() {
    emacsclient "$1" &
  }


  # Gitのリポジトリのトップレベルにcd
  function u()
  {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
      cd $1
    fi
  }

  ## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
  function cde () {
      EMACS_CWD=`emacsclient -e "
       (expand-file-name
        (with-current-buffer
            (nth 1
                 (assoc 'buffer-list
                        (nth 1 (nth 1 (current-frame-configuration)))))
          default-directory))" | sed 's/^"\(.*\)"$/\1/'`

      echo "chdir to $EMACS_CWD"
      cd "$EMACS_CWD"
  }

  ## Invoke the ``dired'' of current working directory in Emacs buffer.
  function dired () {
    emacsclient -e "(dired \"$PWD\")"
  }

  # 短縮URLを展開する
  function expandurl() {
      wget -S $1 2>&1 | grep Location
  }

  function wgetall() {
      wget --random-wait -r -p -e robots=off -U mozilla $1
  }

  function mkdircd () {
      mkdir -p "$@" && cd "$@";
  }

  # commitしていない修正を消す
  function git_forget_working_directory {
      git clean -fdx
      git stash save --keep-index
      git stash drop
  }

  # function my_prompt_command() {
  #     # 複数端末間でhistoryを共有する
  #     history -a
  #     history -c
  #     history -r
  #     # つねに直前のコマンドの終了状態をチェックさせる。
  #     # もし異常終了した場合は、その状態(数値)を表示する。
  #     if [[ $? -eq 0 ]]; then return; fi
  #     echo "exit $s"
  # }

  # PROMPT_COMMAND=my_prompt_command

  shopt -u histappend
  export HISTSIZE=9999

  # "\033k\033\\" は，ステータス行に各ウィンドウで打ったコマンドを表示するための設定
  # 雛形 PS1='[\u@$HOSTNAME$(__git_ps1 " (%s)")\w]\n$ '
  # \e     ASCII のエスケープ文字 (033)
  # \u     ユーザー名
  # \w     ディレクトリ
  # \h     最初の"."までのホスト名
  # \H     ホスト名
  # \t     24時間制の HH:MM:SS のフォーマットによる時間
  # \T     12時間制の HH:MM:SS のフォーマットによる時間

  parse_git_branch() {
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # case "$HOSTNAME" in
  # # 青   開発サーバ用
  # apple*) PS1="\n\[\033[1;36m\u@\h$(__git_ps1 " (%s)"):\w\033[0m\]\n\\$ ";;
  # # 黄色 ステージングサーバ用 イエロー（重要度が中）
  # mango*) PS1="\n\[\033[1;33m\u@\h$(__git_ps1 " (%s)"):\w\033[0m\]\n\\$ ";;
  # # 赤   本番サーバ用 レッド（重要度が高）
  # grape*) PS1="\n\[\033[1;31m\u@\h$(__git_ps1 " (%s)"):\w\033[0m\]\n\\$ ";;
  # # その他
  # *) PS1="\n\[\033[1;36m\u@\h$(__git_ps1 " (%s)"):\w\033[0m\]\n\\$ ";;
  # esac

  # export PS1="\[\033[1;36m\]\u@\h: \w\$(parse_git_branch)$ \[\033[00m\]"

  # GIT_PS1_SHOWUPSTREAM
  # 現在のブランチがupstreamより進んでいるとき">"を、遅れているとき"<"を、遅れてるけど独自の変更もあるとき"<>"を表示する。
  export GIT_PS1_SHOWUPSTREAM=1
  export PS1="\[\033[1;36m\]\u@\h: \w\$(__git_ps1)$ \[\033[00m\]"
  # if [ -f `which lsbytesum` ]; then
  #   export PS1="\[\033[1;36m\]\u@\h: \w\$(__git_ps1) (\$(lsbytesum) Mb)$ \[\033[00m\]"
  # else
  #   export PS1="\[\033[1;36m\]\u@\h: \w\$(__git_ps1)$ \[\033[00m\]"
  # fi


  
  # export PS1="\[\033[037;041m\]\u@\h: \w\$(parse_git_branch)$ \[\033[00m\]"


  function d {
      dropbox stop;
      dropbox start;
  }

  # 名前の一部からコマンドを検索する
  function which2 () {
      [ -z "$1" ] && return
      find ${PATH//:/ } -maxdepth 1 -iwholename "*${1}*" -not -type d
  }

function f5 {
   {$1:-\.}
   find $1 -type f -name $2
}


  #----------------------------------------------------------------------
  # completion
  #----------------------------------------------------------------------

  # 補完の設定。あまり詳しくは設定してない。
  complete -d cd
  complete -c man
  complete -c h
  complete -c wi
  complete -v unset

  # ホストごとに異なる設定は .bashrc_local で管理
  if [ -f ~/.bashrc_local ]; then
      . ~/.bashrc_local
  fi


  #----------------------------------------------------------------------
  # alias, function
  #----------------------------------------------------------------------

  # 履歴つき cd
  if [ -e $HOME/Dropbox/bin/cdhist.sh ] ; then
    . ${HOME}/Dropbox/bin/cdhist.sh

    function f { cdhist_forward "$@"; }
    function b { cdhist_back "$@"; }
    function h { cdhist_history "$@"; }
    function ff { f; f; }
    function bb { b; b; }
  fi

  function u { cd ..; }
  function uu { u; u; }
  function uuu { u; u; u; }
  function uuuu { u; u; u; u;  }

  function execcd  {
      cd `$@`
  }

  # i: 直前の履歴 30件を表示する。引数がある場合は過去 1000件を検索する。
  # (history で履歴全部を表示させると多すぎるので)
  function i {
      if [ "$1" ]; then history 1000 | grep "$@"; else history 30; fi
  }
  # I: 直前の履歴 30件を表示する。引数がある場合は過去のすべてを検索する。
  function I {
      if [ "$1" ]; then history | grep "$@"; else history 30; fi
  }

  # GNU screen 用のコマンド。引数を screen のステータス行に表示。
  function dispstatus {
      if [[ "$STY" ]]; then echo -en "\033k$1\033\134"; fi
  }

  # 指定されたコマンドの実体を表示。
  # $ my_what_is grep
  #  => grep is aliased to `grep --exclude='tags' --exclude='*.svn-*' --exclude='entries' --color=auto'
  function my_what_is {
    case `type -t "$1"` in
     alias|function) type "$1";;
     file) L `command -v "$1"`;;
     function) type "$1";;
    esac
  }

  # CPANモジュールのアンインストール
  alias cpan-uninstall='\perl -MExtUtils::Install -MExtUtils::Installed -e "unshift@ARGV,new ExtUtils::Installed;sub a{\@ARGV};uninstall((eval{a->[0]->packlist(a->[1])}||do{require CPAN;a->[0]->packlist(CPAN::Shell->expandany(a->[1])->distribution->base_id=~m/(.*)-[^-]+$/)})->packlist_file,1,a->[2])"'

  alias sagi="yes | sudo apt-get install"

  alias f="find . -type f -name"
  alias hasktags-r="find . -type f -name \*.\*hs -print0 | xargs -0 hasktags -c"
  # ディスクを占有する上位10人のユーザ名と使用量を表示する
  # cd /var/spool/mail など。
  alias ducks='du -cksh * |sort -rn |head -11'

  # 間違ってcrotab -rをしないために確認する
  alias crontab='crontab -i'

  #alias g='git'
  alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
  
  # Show hidden files only
  alias l.='ls -d .* --color=auto'






  alias ll='ls -al'
  alias rmrf='rm -rf'
  alias git-add-dot-gitignore-to-empty-dir="find . -type d -empty -not -path './.git*' -exec touch {}\/.gitignore \;"

  #alias m="mysql -uroot -p --pager='less -niSFX' --auto-rehash"
  # memo
  # mysql> pager cat | grep searchword
  # mysql> pager cat > ~/dump.txt
  # mysql> nopager 元に戻す

  alias io_machi_no_ps='ps auxwwww|awk "\$8 ~ /(D|STAT)/{print}"'
  alias brake='bundle exec rake'
  alias br='bundle exec rails'
  alias r='rails'

  alias bu='bundle exec spork cuc --port 12345 &'
  alias cu='cucumber --drb --port 12345'

  alias au='aunpack'
  alias wcl='wc -l'

  alias ..='cd ..'
  alias 644='chmod 644'
  alias 755='chmod 755'
  # alias calc='galculator &'
  alias calc='galculator'

  # alias g='git'
  alias kf='pkill -9 firefox'
  alias ke='pkill -9 emacs'

  alias oowriter='libreoffice -writer'
  alias oocalc='libreoffice -calc'

  # GET リクエスト送ってレスポンスヘッダだけ見たい
  alias curlh="curl -s -L -D - -o /dev/null $@"
  alias wgeth="wget -S -q -O /dev/null $@"
  alias lwph="lwp-request -deS $@"

  alias grep="grep --exclude='tags' --exclude='*.svn-*' --exclude='entries' --color=auto"
  alias rmdotsvn="find . -type d -name '.svn' | xargs rm -rvf"

  # lgrep で再帰的に日本語をファイル検索する
  alias lgrep-r="find . -type d -name .svn -prune -o -type f -print | xargs lgrep"

  alias go="gnome-open"
  alias es="emacs --script"
  # alias r="rm -i"
  # alias ls="ls --color=auto"
  # alias sl="ls --color=auto"
  # alias l="ls --color=auto"
  alias sdd="sudo shutdown -h now"
  alias sddr="sudo shutdown -r now"
  alias head30="du -m |sort -rn |head -30"

  alias mozc-config="/usr/lib/mozc/mozc_tool -mode=config_dialog"
  alias mozc-dict="/usr/lib/mozc/mozc_tool --mode=dictionary_tool"

  #----------------------------------------------------------------------
  # gem open
  #----------------------------------------------------------------------

  export GEM_EDITOR="emacsclient"

  _gemopencomplete() {
      local cmd=${COMP_WORDS[0]}
      local subcmd=${COMP_WORDS[1]}
      local cur=${COMP_WORDS[COMP_CWORD]}

      case "$subcmd" in
          open)
              words=`ruby -rubygems -e 'puts Dir["{#{Gem::SourceIndex.installed_spec_directories.join(",")}}/*.gemspec"].collect {|s| File.basename(s).gsub(/\.gemspec$/, "")}'`
              ;;
          *)
              return
              ;;
      esac

      COMPREPLY=($(compgen -W "$words" -- $cur))
      return 0
  }

  complete -o default -F _gemopencomplete gem



  #----------------------------------------------------------------------
  # etc
  #----------------------------------------------------------------------

  # if [ -f /etc/bash_completion ]; then
  #     . /etc/bash_completion
  # fi

  # if [ -s $HOME/.rvm/scripts/rvm ] ; then
  #     . $HOME/.rvm/scripts/rvm
  # fi




fi

## Mac の emacs 用
perl -wle \
    'do { print qq/(setenv "$_" "$ENV{$_}")/ if exists $ENV{$_} } for @ARGV' \
    PATH > ~/.emacs.d/shellenv.el

## xkeyremap
export RUBYLIB=$HOME/git/xkeyremap:$RUBYLIB
export RUBYLIB=$HOME/git/xkeyremap/lib:$RUBYLIB


# [[ -s "/home/m/.rvm/scripts/rvm" ]] && source "/home/m/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*vv



source $HOME/Dropbox/bin/bashmarks.sh
# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="$HOME/d/bin/git-hook/bin:$PATH"


function my-explain {
  # base url with first command already injected
  # $ explain tar
  #   => http://explainshel.com/explain/tar?args=
  url="http://explainshell.com/explain/$1?args="

  # removes $1 (tar) from arguments ($@)
  shift;

  # iterates over remaining args and adds builds the rest of the url
  for i in "$@"; do
    url=$url"$i""+"
  done

  # opens url in browser
  exec `gnome-open $url`
}
