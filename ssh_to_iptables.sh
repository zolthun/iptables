#!/bin/bash

log_dir="/var/log/"
pattern="auth*.*"
tmp_log_files=`ls $log_dir | grep -i $pattern`
my_ip=`w | grep -i "root" | awk -F " " '{ print $3 }' | sort -u`
let ban_count=`iptables -L INPUT -v -n | grep -i DROP | grep -i "$k" | wc -l`
for i in $tmp_log_files
do
        log_files=$log_dir$i
        for j in $log_files
        do
                aux_auth=`cat $j | grep -i "closed by" | grep -v "exceeded" | grep -v $my_ip | awk -F " " '{ print $9 }'`
                aux_tmp=`iptables -L INPUT -v -n | grep -i DROP | awk -F " " '{ print $8 }'`
                aux=`diff -ia --suppress-common-lines <( echo "$aux_tmp" |  tr ' ' '\n' | sort -u ) <( echo "$aux_auth" |  tr ' ' '\n' | sort -u ) | grep -E "<|>" | awk -F" " '{ print $2 }'`
        done
done

echo $aux |  tr ' ' '\n' | sort -u

for k in $aux
do
        if [ "$ban_count" -gt "0" ]
        then
                echo "The ip address $k has been already banned,nothing done."
        else
                echo "Ban to ip address $k."
                iptables -A INPUT -s $k -j DROP
                echo $k >> banned
        fi
done


#       Zolthun 2019
#       zavalsa@gmail.com