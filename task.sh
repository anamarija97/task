#!/bin/bash

dir=$1
dir2=$2


#Checking if there are two arguments
if [ $# -ne 2 ]; then
	echo "usage: $0 directory1 directory2" 
	exit 1
fi
	
#Checking if arguments are directories
if [ ! -d $dir ]; then
	echo $dir is not directory
	echo "usage: $0 directory1 directory2" 
	exit 1
fi

if [ ! -d $dir2 ]; then
	echo $dir2 is not a directory
	echo "usage: $0 directory1 directory2" 
	exit 1
fi

#Listing versions
ls -R1 $dir $dir2   

echo

#Checking changes in versions
tput setaf 4; diff -qs $dir $dir2 | cat --number; tput setaf 7;     

echo


tput setaf 2; echo "Changes in files:"; tput setaf 7;

#Checking changes inside changed files
for i in $(diff -rqsy $dir $dir2 | sort -k  2 | grep differ | awk '{print $2","$4}');do
	FIRST=$(echo $i | cut -d , -f1)
	SECOND=$(echo $i | cut -d , -f2)

	echo -e "$FIRST\t\t\t\t\t$SECOND"
	diff -y $FIRST $SECOND
	echo
done	

echo
echo
tput setaf 2; echo "New files and their contents:"; tput setaf 7;

#Checking content of newly added files
for i in $(diff -rqsy $dir $dir2 | sort -k  2 | grep Only | awk '{print $3$4}' | tr ":" "/");do
	echo $i
	cat $i
	echo
done
