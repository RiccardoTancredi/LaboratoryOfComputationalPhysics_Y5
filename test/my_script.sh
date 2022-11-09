#!/bin/bash

# checking if the user provided an input
if [ -z $1 ]
then
    echo "this script requires as input the name of the file to be created"
    exit
fi

# check if the file is there
if [ ! -f "./$1" ]
then
    echo "the file ./$1 does not exist! Setting a default value"
    file="newfile.txt"
else
    file=./$1
fi

touch $file

for (( i=1; i<=5; i++ ))
do
    echo "add line $i" >> $file
done
