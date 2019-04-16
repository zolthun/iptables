#/bin/bash

lines=`iptables -L INPUT -vn --line-numbers | grep -i DROP | awk -F " " '{ print $1 }' | sort -nr`

for i in $lines
do
        iptables -D INPUT $i
        echo "Rule $i deleted."
done


# Zolthun 2019
# zavalsa@gmail.com
