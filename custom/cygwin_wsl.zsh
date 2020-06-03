if [[ $OSTYPE == cygwin || $OSTYPE == linux* && $(</proc/version) =~ Microsoft ]]; then

  # Things common to Cygwin and WSL
  alias sumatrapdf='"/mnt/c/Program Files/SumatraPDF/SumatraPDF.exe"'
  alias windbg='"/mnt/c/Program Files/Debugging Tools for Windows (x64)/windbg.exe"'
  alias windbgx='/mnt/c/Users/baumann/AppData/Local/DBG/UI/WinDbgX.exe'

  alias rr='razzle.sh run'
  alias taskkill=taskkill.exe
  alias tasklist=tasklist.exe

  # hide NT goop (append to ls alias)
  alias ls="${aliases[ls]-ls} -h --hide={ntuser,NTUSER}.{DAT*,dat.*,ini,pol}"

  # directory aliases
  for driveletter in {c..z}; do
      hash -d $driveletter=/mnt/$driveletter
  done

  if [[ $OSTYPE == cygwin ]]; then
      # Cygwin-specific stuff
      alias start=cygstart
      alias mklink='cmd /c mklink'
      #export EDITOR=wemacsclient.sh
      export EDITOR="code -w"
      export ALTERNATE_EDITOR=nano
      export WIN_PATH_UTIL=/bin/cygpath
  else
      # WSL-specific stuff
      export WIN_PATH_UTIL=/bin/wslpath
      alias start='cmd.exe /c start'
  fi

  # this enables (+w) as a suffix on any pathname or glob
  w() {
    reply="$(${WIN_PATH_UTIL} -m ${REPLY})"
  }

  # this adds a zle completion for running cygpath or wslpath on alt-w
  # (overriding the default of "^[w" to copy-region-as-kill)
  autoload cygpath-word-match
  zle -N cygpath-word-match
  bindkey "^[w" cygpath-word-match

  autoload nativepath-word-match
  zle -N nativepath-word-match
  bindkey "^[v" nativepath-word-match
fi
