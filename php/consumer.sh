#!/usr/bin/env sh

while getopts ":s:" opt; do
  case ${opt} in
    s )
      sleep=$OPTARG
      ;;
  esac
done
sleep="${sleep:-2}"
shift $((OPTIND -1))

LOOP=1
exit_script() {
    trap - INT TERM # clear the trap
    LOOP=0
    echo "Stopping the subprocess loop"
    SUBPROCESS_ID=$!
    if [ -z "$SUBPROCESS_ID" ] ; then
            echo "No child process to kill, it's time to leave, bye bye"
            exit 0;
    fi

    echo "Transmiting kill signal to subprocess $SUBPROCESS_ID"
    kill -- -$$
    echo "No more subprocess loop, letting time to child process to gracefully shutdown"
    while kill -0 "$SUBPROCESS_ID" 2> /dev/null ; do
            sleep 1;
    done
    echo "subprocess has ended, bye bye"
    exit 0
}
trap exit_script INT TERM

echo "Running subprocess loop"
while [ $LOOP -eq 1 ] ; do
    "$@" & wait
    sleep $sleep
done
