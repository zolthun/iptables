#!/bin/bash

#### Default system log folder
log_dir="/var/log/"
#### Usually the ssh attemps are stored in the files auth.log, auth.1.log and so on
pattern="auth*.*"
tmp_log_files=`ls $log_dir | grep -i $pattern`
my_ip=`w | grep -i "root" | awk -F " " '{ print $3 }' | sort -u`
for i in $tmp_log_files
do
        log_files=$log_dir$i
        for j in $log_files
        do
                aux_auth=`cat $j | grep -i "closed by" | grep -v "exceeded" | grep -v $my_ip | awk -F " " '{ print $9 }'`
                aux_tmp=`iptables -L INPUT -v -n | grep -i DROP | awk -F " " '{ print $8 }'`
        done
                aux=`diff -ia --suppress-common-lines <( echo "$aux_tmp" |  tr ' ' '\n' | sort -u ) <( echo "$aux_auth" |  tr ' ' '\n' | sort -u ) | grep -E "<|>" | awk -F" " '{ print $2 }'`

done

if [ -z "$aux" ]
then
        echo "There are no lines to be added to the drop rules."
else
        for k in $aux
        do
                let ban_count=`iptables -L INPUT -v -n | grep -i DROP | grep -i "$k" | wc -l`
                if [ "$ban_count" -gt "0" ]
                then
                        echo "The ip address $k has been already banned,nothing done"
                else
                        echo "Ban to ip address $k"
                        iptables -A INPUT -s $k -j DROP
                fi
        done
fi


#       Zolthun 2019
#       zavalsa@gmail.com
