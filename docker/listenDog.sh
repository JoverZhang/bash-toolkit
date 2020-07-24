#!/bin/bash

# Fixme: Just for java now.

# $1: file name to be detected.
function has_file_exists() {
  if [ -f "$1" ]; then
    echo true
  else
    echo false
  fi
}

# $1: file name to be detected.
function get_update_time_by_file() {
  time="$(stat "$1" | grep Modify | awk '{print $3}')"
  echo "$time"
}

# $1: pid to be killed.
function kill_process() {
  if [[ $1 ]]; then
    kill -9 "$1"
  fi
}

# $1: file name to be detected.
# $2: check interval. default 0.1s
process_pid='' # Need to be `Ctrl+C` capture.
function listen_dog() {
  file_update_time=''

  while :; do
    sleep "$sleep_time"
    if [[ $(has_file_exists "$1") == true ]]; then

      now_file_update_time=$(get_update_time_by_file "$1")
      if [[ "$file_update_time" != "$now_file_update_time" ]]; then
        echo "updated"
        sleep 1 # Waiting for the completion of writing into file.

        kill_process "$process_pid"
        java -jar "$1"
        process_pid=$!

        file_update_time="$now_file_update_time"
      fi

    fi
  done
}

# Prevent sub-process not to be killed
trap 'onCtrlC' INT
function onCtrlC() {
  kill_process "$process_pid"
  echo 'The main thread has exited.'
  exit
}

# $1: file name to be detected.
# $2: check interval. default 0.1s
function _main() {
  sleep_time=$(if [[ "$3" ]]; then echo "$3"; else echo 0.1s; fi)

  listen_dog "$1" "$sleep_time"
}

_main "$@"
