#!/bin/bash
DB=$1
USER=root
PW=z10mz10m
HOST=localhost

if [ -z "$1" ]; then
	echo "Please specify database name."
	exit
fi

if [ -f db_changes.wc ];then
	#make sure the file db_changes.wc contain a number
	read -r start<db_changes.wc
	re='^[0-9]+([.][0-9]+)?$'
	if ! [[ $start =~ $re ]]; then
   		echo "error: value in file db_changes.wc is not a number"
 		exit
	fi			
	if [ $start -eq 0 ]; then
		#The file contained the number 0. Overwrite the exiting DB with a dump
		echo -n "Are you sure you would like to override your existing database? [Y/n] "
     		read confirm
     		if [ $confirm == "Y" ] || [ $confirm == "y" ]; then
          		echo -n "Overriding database"
	  		echo 
          		mysql -h$HOST -u$USER -p$PW $DB < $DB.dump.sql
			echo 1 > db_changes.wc
     		else
          		echo Ok..so chao!
          		exit
     		fi	
	else 
		echo -n "Run latest changes to the DB? [Y/n] "
     		read confirm
     		if [ $confirm != "Y" ] && [ $confirm != "y" ]; then
          		echo Ok..so chao!
          		exit
     		fi
	fi	
	#In any case, need run the latest changes file 
	echo "run $DB.changes.sql starting from the row $start"
	SQL=$(tail -n +$start $DB.changes.sql)	
	mysql -h$HOST -u$USER -p$PW $DB -e "$SQL"	
	
	sed '/^ *$/d' $DB.changes.sql > /tmp/$DB.changes.sql.new
	mv /tmp/$DB.changes.sql.new $DB.changes.sql

	num_lines=$(wc -l < $DB.changes.sql)
	new_start=$((num_lines+1))
	echo $new_start> db_changes.wc
	echo "next start will be from row $new_start"
else
     	echo "No such file db_changes.wc"
	exit
fi     

echo "Done"
