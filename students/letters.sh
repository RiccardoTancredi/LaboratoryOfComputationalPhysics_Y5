#!/bin/bash

# decleariing a dictionary == hash table

file="PoD_students.txt"
output_file="list_letters.txt" 

letters=$(cut -d"," -f1 $file)

touch $output_file

tmp=0

for i in {A..Z}; do
	counts=$(cut -d"," -f1 $file| sort| grep "^$i" -c)
	tmp=$counts
	echo "$i -> $tmp" >> $output_file
done

