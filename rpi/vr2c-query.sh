#!/bin/bash
# USEAGE:
#   alert/vr2c-query.sh /dev/ttyUSB0 INFO
#   alert/vr2c-query.sh /dev/ttyUSB0 status


# set tty device variable
vr2c=$1
cmd=$2
reply=''
iteration=0

# set baud rate to 9600, 8 bits, 1 stop bit, no parity, no flow control
stty -F $vr2c sane

# open serial output (<) and serial input (>) processes
exec 4<$vr2c 5>$vr2c

# while [ "$reply" == "" ]
# do
    # if [ $iteration == 5 ]
    #     then
    #         break
    # fi

    # exec 4<$vr2c 5>$vr2c
    # stty -F $vr2c 9600 cs8 -cstopb -parenb

    # wake
    echo -ne "*450281.0#20,W\r" >&5
    sleep 0.5

    # Query
    echo -ne "*450281.0#20,$cmd\r" >&5

    

    # stty -F $vr2c

    # Read reply
    read -d $'\04' -t2 reply <&4
    
    echo -ne "*450281.0#20,QUIT\r" >&5

    # iteration=$(( $iteration+1 ))
# done

# close conn
exec 4>&- 5>&-

echo $reply >> detection.log

# Log system temperature
/usr/bin/vcgencmd measure_temp | \
    awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; fflush();}' \
    >> sys_temp.log


# Grab last lines
export_log=$(tail -n 1 sys_temp.log)
export_log+=";"
export_log+=$(tail -n 1 detection.log)

echo $export_log >> export.log





# https://unix.stackexchange.com/questions/117037/how-to-send-data-to-a-serial-port-and-see-any-answer