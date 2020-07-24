#!/bin/bash
# author: Jover Zhang
# url: https://github.com/JoverZhang/bash-toolkit/blob/master/docker/listenDog.sh
# version: 1.0.0-Alpha

LISTEN_DOG_cmd_name=${0##*/}

LISTENS_NAME=''
CALLBACK_CMD=''
WAIT_INTERVAL=''

function echo_error() {
  echo "$LISTEN_DOG_cmd_name: $* See '$LISTEN_DOG_cmd_name --help'."
}

function echo_info() {
  echo "$LISTEN_DOG_cmd_name: $*"
}

function usage() {
  cat <<USAGE >&1
Usage:
  $LISTEN_DOG_cmd_name [OPTIONS] <LISTENS_NAME> <CALLBACK_CMD>

Listens file(or directory), execute callback command when the file(or directory) updated.

LISTENS_NAME:          file(or directory) to be listens
CALLBACK_CMD:          callback command. When NAME updated to be executed

Options:
  -i, --interval       Set interval of listening (default 0.1s)
USAGE
}

# Handle parameters of command.
function commander() {
  if [[ "$#" == 0 ]]; then
    usage
    exit 1
  fi

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
    -i | --interval)
      WAIT_INTERVAL="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      if [[ $(is_exists_by_name "$1") == false ]]; then
        echo_error 'argument <LISTENS_NAME> is not a file(or directory).'
        exit 2
      fi

      if [[ ! "$2" ]]; then
        echo_error 'argument <CALLBACK_CMD> is not defined.'
        exit 3
      fi
      LISTENS_NAME="$1"
      CALLBACK_CMD=${*:2}
      break
      ;;
    esac
  done

  # Set default
  WAIT_INTERVAL=${WAIT_INTERVAL:-'0.1s'}
}

# Check the name of file or directory is exists.
#
# $1: file name to be checked.
# return: true or false.
function is_exists_by_name() {
  if [ -f "$1" ] || [ -d "$1" ]; then
    echo true
  else
    echo false
  fi
}

# $1: file name to be checked.
function get_update_time_by_file() {
  time="$(stat "$1" | grep Modify | awk '{print $3}')"
  echo "$time"
}

# Find pid by command.
#
# $1: command.
function find_pid_by_command() {
  pid=$(ps ax | grep "$1" | awk '$2=$3=$4=""; {print $0}' | grep "^[0-9]*\s*$1$" | awk '{print $1}')
  echo "$pid"
}

# Proxy kill.
#
# $1: pid to be killed.
function kill_process() {
  if [[ $1 ]]; then
    kill -9 "$1"
  fi
}

# Following function Loop listen name of file(or directory).
# When the file(or directory) is updated, it will kill CALLBACK_CMD.
#
# $1: LISTENS_NAME
# $2: CALLBACK_CMD
# $3: WAIT_INTERVAL
function listenDog() {
  update_time=$(get_update_time_by_file "$1")

  while :; do
    sleep "$3"
    process_pid=$(find_pid_by_command "$2")

    now_update_time=$(get_update_time_by_file "$1")
    if [[ "$now_update_time" != "$update_time" ]]; then
      sleep 1 # Wait for file(or directory) updating.
      echo_info "$1 has been updated."

      kill_process "$process_pid"
      update_time="$now_update_time"
    fi
  done
}

# Force exit process.
# because main process into infinite loop
trap 'onCtrlC' INT
function onCtrlC() {
  echo_info 'The main process has exited.'
  exit
}

function _main() {
  commander "$@"

  # Running a listenDog in sub process.
  listenDog "$LISTENS_NAME" "$CALLBACK_CMD" "$WAIT_INTERVAL" &

  while :; do
    sleep 0.5s # Fixme: when <CALLBACK_CMD> is not block process, it will always execute.
    $CALLBACK_CMD
  done
}

_main "$@"
