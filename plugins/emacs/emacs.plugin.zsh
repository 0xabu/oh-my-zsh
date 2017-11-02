# Emacs 23 daemon capability is a killing feature.
# One emacs process handles all your frames whether
# you use a frame opened in a terminal via a ssh connection or X frames
# opened on the same host.

# Benefits are multiple
# - You don't have the cost of starting Emacs all the time anymore
# - Opening a file is as fast as Emacs does not have anything else to do.
# - You can share opened buffered across opened frames.
# - Configuration changes made at runtime are applied to all frames.

_emacsclient()
{
    # adopted from https://github.com/davidshepherd7/emacs-read-stdin/blob/master/emacs-read-stdin.sh
    # If the last argument is - then write stdin to a tempfile and open the
    # tempfile. (first argument might be `--no-wait` passed in by the aliases)
    if [[ $# -ge 1 && "$argv[$#]" = "-" ]]; then
        local tempfile="$(mktemp emacs-stdin-$USER.XXXXXXX --tmpdir)"
        cat - > "$tempfile"
        argv[$#]="$tempfile"
    fi

    # this elisp returns the number of visible frames, not including
    # any automatically-created frames on the dummy "initial terminal"
    local query='(length (remove-if (lambda (f) (not (equal (terminal-name (frame-terminal f)) "initial_terminal"))) (visible-frame-list)))'
    if [[ -z ${argv[(r)--create-frame]} && $(emacsclient --alternate-editor "" --eval "$query") == 0 ]]; then
        # Create a new frame if we're not already doing so and there is no X window yet
        argv=(--create-frame $argv)
    fi

    emacsclient --alternate-editor "" "$@"
}

if "$ZSH/tools/require_tool.sh" emacs 25 2>/dev/null ; then
    # set EDITOR if not already defined.
    export EDITOR="${EDITOR:-emacsclient --alternate-editor \"\"}"

    alias emacs="_emacsclient --no-wait"
    alias e=emacs
    # open terminal emacsclient
    alias te="_emacsclient -nw"

    # same than M-x eval but from outside Emacs.
    alias eeval="_emacsclient --eval"
    # create a new X frame
    alias eframe="_emacsclient --create-frame"

    # Write to standard output the path to the file
    # opened in the current buffer.
    function efile {
        local cmd="(buffer-file-name (window-buffer))"
        local out="$(_emacsclient --eval $cmd)"
        echo "${(Q)out/%$'\r'}" # remove quotes, and a trailing CR if present
    }

    # Write to standard output the directory of the file
    # opened in the the current buffer
    function ecd {
        local cmd="(let ((buf-name (buffer-file-name (window-buffer))))
                     (if buf-name (file-name-directory buf-name)))"

        local out="$(_emacsclient --eval $cmd)"
        local dir=${(Q)out/%$'\r'} # remove quotes, and a trailing CR if present
        if [ -n "$dir" ] ;then
            echo "$dir"
        else
            echo "can not deduce current buffer filename." >/dev/stderr
            return 1
        fi
    }
fi

## Local Variables:
## mode: sh
## End:
