# Terminal setup
case $TERM in
    xterm*|screen*)
        bindkey '\e[H'  beginning-of-line
        bindkey '\e[F'  end-of-line
        bindkey '\e[3~' delete-char-or-list
        # these only happen in "cygwin" with the conemu connector
        bindkey '\eOA'  up-line-or-history
        bindkey '\eOB'  down-line-or-history
        ;;
    cygwin)
        bindkey '\e[1~' beginning-of-line
        bindkey '\e[4~' end-of-line
        bindkey '\e[3~' delete-char-or-list
        bindkey '\e[7~' beginning-of-line
        bindkey '\e[8~' end-of-line
        ;;
    interix)
        bindkey '\e[H'  beginning-of-line
        bindkey '\e[F'  end-of-line
        bindkey '^?'    delete-char-or-list
        ;;
    *)
        bindkey '\e[1~' beginning-of-line
        bindkey '\e[4~' end-of-line
        ;;
esac

if [[ $TERM == dumb || $TERM == emacs ]]; then
    PROMPT='%m %2~ %# '
fi

if [[ "$TERM_PROGRAM" == Hyper || "$TERM_PROGRAM" == vscode ]]; then
    unsetopt prompt_sp
fi
