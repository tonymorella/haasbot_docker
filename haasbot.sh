DIR=$(cd "$(dirname "$0")"; pwd)
EXE_PATH="$DIR/bin/HTS.exe"
PROCESS_NAME=appname
APPNAME="HaasBot"
MONO_OPTIONS="--debug"

MONO_FRAMEWORK_PATH=/usr/lib/mono/
export DYLD_FALLBACK_LIBRARY_PATH="$DIR:$MONO_FRAMEWORK_PATH/lib:/lib:/usr/lib"
export PATH="$MONO_FRAMEWORK_PATH/bin:$PATH"

if test "x${TMPDIR}" = "x"; then
        TMPDIR=/tmp
fi

PROGRAM_NAME="HaasBot"
LOCK_FILE="/tmp/"${PROGRAM_NAME}".lock"

usage()
{
    echo "$0 (start|stop|restart|debug)"
}

stop()
{
    if [ -e ${LOCK_FILE} ]
    then
        _pid=$(cat ${LOCK_FILE})
        kill $_pid
	rm ${LOCK_FILE}
        rt=$?

        if [ "$rt" == "0" ]
            then
                    echo "Demon stop"
            else
                    echo "Error stop demon"
        fi
    else
        echo "Demon is not running"
    fi
}

start()
{
    mono-service -l:${LOCK_FILE} $EXE_PATH 
}

debug()
{
    mono-service $MONO_OPTIONS -l:${LOCK_FILE} $EXE_PATH $MONO_OPTIONS
}


case $1 in
    "start")
            start
            ;;
    "stop")
            stop
            ;;
    "debug")
            debug
           ;;
    "restart")
	    stop
            start
            ;;
    *)
            usage
            ;;
esac
exit
