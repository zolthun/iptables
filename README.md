# ssh_to_iptables.sh
This script was created in order to help me to block all the non desired ssh connection attempts by parsing the contents of the log files /var/log/auth.log (one or more).

This script will not add the ip address you are using to connect to the terminal where you are at the moment of running the script, be careful because it could indentify any attemps as malicious attempts all will automatically add them to the iptables DROP section.

Use this script at your own risk because I am still testing it.

Zolthun
