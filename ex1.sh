#!/bin/bash

# 1.a
# check if the directory exists, otherwise creates it
DIR="students"
if [ -d "$DIR" ]; then
  echo "There is a folder called $DIR"
else
    mkdir students
fi

# check if the file exists, otherwise creates it
Path="students/LCP_22-23_students.csv"
name="LCP_22-23_students.csv"
if [ -f "$Path" ]; then
  echo "There is already the file $Path"
else
    wget https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv
    mv $name $Path
    echo "I have downloaded and copied the file into $DIR"
fi

# 1.b
# creating 2 files for PoD and Physics students
file_1=$DIR"/PoD_students.txt"
file_2=$DIR"/Physics_students.txt"

if [ ! -f "$file_1" ]; then
    grep "PoD" $Path > $file_1
    grep "Physics" $Path > $file_2
else
    echo "These files already exist"
fi

# 1.c

output_file=$DIR"/list_letters.txt" 
letters=$(cut -d"," -f1 $Path)
tmp=0
max_letter=0
var=0
if [ ! -f "$output_file" ]; then
    
    # create the file
    touch $output_file
    
    for i in {A..Z}; do
        counts=$(cut -d"," -f1 $Path| sort | grep "^$i" -c)
        echo "$i -> $counts" >> $output_file
        if [ $tmp -lt $counts ]; then
            tmp=$counts # this for exercise 1.d
            max_letter=$i # this for exercise 1.d
        fi
    done
else
    echo "Computation already made!"
    var=1
fi

# 1.d
if [ $var -gt 0 ]; then 
    tail -1 $output_file # display the result if the computation has already been done
    echo " "
else
    echo "The letter with most counts is letter $max_letter: it appears $tmp times" >> $output_file
    echo "The letter with most counts is letter $max_letter: it appears $tmp times" # display on the terminal
fi

# 1.e

sub_fold=$DIR/"1.e_exercise"
if [ ! -d "$sub_fold" ]; then
    mkdir $sub_fold
fi

# grouping the students
base_output=$sub_fold"/mod_" 

number_of_rows=$(grep "@" -c $Path)
echo "The number of rows of the file is $number_of_rows"
for (( j=1; j<=18; j++ )); do # from 2 because we skip the definition column
    for (( i=1; i<=$number_of_rows; i++ )); do
        val=$(expr $i % 18)
        if [ $val -eq $j ]; then
            new_out=$base_output$j.txt
            if [ ! -f "$new_out" ]; then
                touch $new_out # create the file
            fi
            sed "${i}q;d" $Path >> $new_out
        fi
    done
    echo "$(( $j * 100 / 18  ))%"
done