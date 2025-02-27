function fish_right_prompt 
  set -l exit_code $status
  set -l cmd_duration $CMD_DURATION
  __tmux_prompt
  if test $exit_code -ne 0
    set_color red
  else
    set_color green
  end
  printf '%d' $exit_code
  if test $cmd_duration -ge 5000
    set_color brcyan
  else
    set_color blue
  end
#  printf ' < %s' (_convertsecs (math $cmd_duration / 1000))
  set_color 666666
  printf ' | %s' (date +%H:%M:%S)
  set_color normal
end

function __tmux_prompt
  set multiplexer (_is_multiplexed)

  switch $multiplexer
    case screen
      set pane (_get_screen_window)
    case tmux
      set pane (_get_tmux_window)
   end

  set_color 666666
  if test -z $pane
    echo -n ""
  else
    echo -n $pane' | '
  end
end

function _get_tmux_window
  tmux lsw | grep active | sed 's/\*.*$//g;s/: / /1' | awk '{ print $2 "-" $1 }' -
end

function _get_screen_window
  set initial (screen -Q windows; screen -Q echo "")
  set middle (echo $initial | sed 's/  /\n/g' | grep '\*' | sed 's/\*\$ / /g')
  echo $middle | awk '{ print $2 "-" $1 }' -
end

function _is_multiplexed
  set multiplexer ""
  if test -z $TMUX
  else
    set multiplexer "tmux"
  end
  if test -z $WINDOW
  else
    set multiplexer "screen"
  end
  echo $multiplexer
end

function _convertsecs
 printf "%02d:%02d:%02d\n" (math $argv[1] / 3600) (math (math $argv[1] \% 3600) / 60) (math $argv[1] \% 60)
end
