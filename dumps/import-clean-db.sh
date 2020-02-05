#!/bin/bash
DB=$1
USER=root
PW=z10mz10m
HOST=localhost


if [ -z "$1" ]; then
	echo "Please specify database name to import."
	exit
fi
 

if [ -f $DB.structure.dump.sql ];then
	if [ -f $DB.metadata.dump.sql ];then
		echo -n "Are you sure you would like to override your existing database? [Y/n] "
     		read confirm
     		if [ $confirm == "Y" ] || [ $confirm == "y" ]; then
          		echo -n "Overriding database"
	  		echo 
          		mysql -h$HOST -u$USER -p$PW $DB < $DB.structure.dump.sql 
			mysql -h$HOST -u$USER -p$PW $DB < $DB.metadata.dump.sql
     		else
          		echo Ok..so chao!
          		echo
     		fi
	else
     		echo "No such file $DB.metadata.dump.sql .. Copy the file to the current directory and try again.."
	fi   
else
     echo "No such file $DB.structure.dump.sql .. Copy the file to the current directory and try again.."
fi     

