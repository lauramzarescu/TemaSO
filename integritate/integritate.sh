#!/bin/bash

path='test'
flag=0

truncate -s 0 check.sha


if [ -z "$(ls -A $path)" ]; then
   echo "Empty"
else
	for file in $path/*; do
		sum=`sha256sum $file`
		echo $sum >> check.sha
	done
fi

inotifywait -m $path -e create -e close_write -e delete -e moved_from -e moved_to|
    while read path action file; do
        if [ $action == "CREATE" ]; then
        	clear
        	echo "-> Creare fisier - $path$file"
        	flag=1
        elif [ $action == "CLOSE_WRITE,CLOSE" ]; then
        	if [ $flag == 0 ]; then
        		clear
        	fi
        	flag=0
        	echo "-> Salvare fisier si inchidere - $path$file"
        	new_sum=`sha256sum $path$file`
        	echo $new_sum
        	if grep -Fq "$path$file" check.sha
			then
			    :
			else
			    echo $new_sum >> check.sha
			fi
			sha256sum -c check.sha
        elif [ $action == "DELETE" ] || [ $action == "MOVED_FROM" ]; then
        	if [ $flag == 0 ]; then
        		clear
        	fi
        	flag=0
        	echo "-> Stergere - $path$file"
        	sed -i "\|$path$file|d" check.sha
        	sha256sum -c check.sha
        fi	
    done




        	

