#!/bin/bash
DB=$1
USER=root
PW=z10mz10m
HOST=localhost

echo "usage: export-metadata-by-table.sh <dbname> <table> [where]"
echo "example (dump all CustomUser): export-metadata-by-table my_db CustomUser"
echo "example (dump 2 specific rows from CustomUser): export-metadata-by-table my_db CustomUser \"username IN ('admin','batz')\""

if [ -z "$1" ]; then
	echo "Please specify database name."
	exit
fi

if [ -z "$2" ]; then
	echo "Please specify table name"
	exit
fi

if [ ! -f "$1.metadata.dump.sql" ]; then
	echo "file $1.metadata.dump.sql does not exist"
	exit
fi

if [ -z "$3" ]; then
	mysqldump -h$HOST $1 -u$USER -p$PW -t $2 > $1.metadata.$2.dump.sql
else 
	mysqldump -h$HOST $1 -u$USER -p$PW -t $2 --where="$3" > $1.metadata.$2.dump.sql
fi

cat $1.metadata.$2.dump.sql >> $1.metadata.dump.sql


echo "Added the specified metadata to dump of $1"




