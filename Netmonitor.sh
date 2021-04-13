#!/bin/bash
# how to use ? 
# 1st :  You need to make the execute permission file like command "chmod +x filename.sh"
# 2st : ./filename.sh [express] 
#   Ex.) ./netmonitor.sh 443 [port_num] , ./netmonitor.sh .* [ all ] 


COUNT=10
while :
do
        if [ $COUNT = 10 ]
        then
                printf "+--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------: \n"
                printf "|  TIME  | ESTAB | LISTN | T_WAT | CLOSD | S_SEN | S_REC | C_WAT | F_WT1 | F_WT2 | CLOSI | L_ACK | \n"
                printf "+--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+ \n"
                COUNT=0
        fi
        COUNT=`expr $COUNT + 1`
        TIME=`/bin/date +%H:%M:%S`
        printf "|%s" ${TIME}
        netstat -an | grep $1 |\
        awk 'BEGIN {
                CLOSED = 0;
                LISTEN = 0;
                SYN_SENT = 0;
                SYN_RECEIVED = 0;
                ESTABLISHED = 0;
                CLOSE_WAIT = 0;
                FIN_WAIT_1 = 0;
                FIN_WAIT_2 = 0;
                CLOSING = 0;
                LAST_ACK = 0;
                TIME_WAIT = 0;
                OTHER = 0;
                }
                $6 ~ /^CLOSED$/ { CLOSED++; }
                $6 ~ /^CLOSE_WAIT$/ { CLOSE_WAIT++; }
                $6 ~ /^CLOSING$/ { CLOSING++; }
                $6 ~ /^ESTABLISHED$/ { ESTABLISHED++; }
                $6 ~ /^FIN_WAIT_1$/ { FIN_WAIT_1++; }
                $6 ~ /^FIN_WAIT_2$/ { FIN_WAIT_2++; }
                $6 ~ /^LISTEN$/ { LISTEN++; }
                $6 ~ /^LAST_ACK$/ { LAST_ACK++; }
                $6 ~ /^SYN_SENT$/ { SYN_SENT++; }
                $6 ~ /^SYN_RECEIVED$/ { SYN_RECEIVED++; }
                $6 ~ /^TIME_WAIT$/ { TIME_WAIT++; }

                END {
                        printf "| %6d| %6d| %6d| %6d| %6d| %6d| %6d| %6d| %6d| %6d| %6d|\n",ESTABLISHED,LISTEN,TIME_WAIT,CLOSED,SYN_SENT,SYN_RECEIVED,CLOSE_WAIT,FIN_WAIT_1,FIN_WAIT_2,CLOSING,LAST_ACK;
                }'
        sleep 2
done
