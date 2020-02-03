#!/bin/bash
DB=$1
USER=root
PW=z10mz10m
HOST=localhost

if [ -z "$1" ]; then
	echo "Please specify database name."
	exit
fi

mysqldump -h$HOST $1 -u$USER -p$PW --databases --no-data | sed 's/ AUTO_INCREMENT=[0-9]*//g'> $1.structure.dump.sql

echo "Prepared a dump of the table structure of $1"


