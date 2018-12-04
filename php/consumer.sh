#!/usr/bin/env sh

no_sleep_on_success=0
exponential_backoff_opt=0
sleep_success=0
interval_opt=0
while getopts ":s:e:q" opt; do
  case ${opt} in
    s )
      interval_opt=$OPTARG
      ;;
    q )
      no_sleep_on_success=1
      ;;
    e )
      exponential_backoff_opt=1
      exponential_backoff_sleep_additional_max=${OPTARG:-30}
      ;;
  esac
done
shift $((OPTIND -1))
if [ $no_sleep_on_success -eq 0 ] ; then
    sleep_success=$interval_opt
fi


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


pow() {
    number=$1
    exponant=$2
    counter=1
    result=1

    if [ $exponant -eq 0 ] ; then
        result=1 
    fi

    if [ $exponant -gt 10 ] ; then
        exponant=10
    fi

    if [ $number -eq 0 ] ; then
        result=0 
    fi

    if { [ $number -ge 1 ] && [ $exponant -ge 1 ] ;} ; then
        while [ $counter -le $exponant ]
        do
            result=$(($result * $number))
            counter=$(($counter + 1))
        done
    fi

    echo $result;
}


echo "Running subprocess loop"
failed_attempt=0
while [ $LOOP -eq 1 ] ; do
    "$@" &
    SUBPROCESS_ID=$!
    wait $SUBPROCESS_ID
    exitCode=$?

    noise=$(printf "0.%03d\n" $(( RANDOM % 1000 )))
    sleep=$sleep_success;

    # EB is ON and subprocess failed
    if { [ $exponential_backoff_opt -eq 1 ] && [ $exitCode -ne 0 ] ;} ; then
        sleep=$(pow 2 $failed_attempt);
        if [ $sleep -gt $exponential_backoff_sleep_additional_max ] ; then 
            echo "Subprocess failure, max exponential back off retries reached, exiting"
            exit 2
        fi
        sleep=$((sleep + interval_opt))
        echo "Subprocess failure with exit code: $exitCode, attempt: $failed_attempt retrying in ${sleep}s + ${interval_opt}s (sleep interval) + ${noise}s (random noise)"
        failed_attempt=$(( failed_attempt + 1 ))
    fi

    # Subprocess succeeded
    if [ $exitCode -eq 0 ] ; then
        failed_attempt=0
    fi

    # EB is OFF and subprocess failed
    if { [ $exponential_backoff_opt -eq 0 ] && [ $exitCode -ne 0 ] ;} ; then
        sleep=$interval_opt;
        echo "Subprocess failure, sleeping ${sleep}s + ${noise}s (random noise)"
    fi


    sleep $sleep
    sleep $noise
done
