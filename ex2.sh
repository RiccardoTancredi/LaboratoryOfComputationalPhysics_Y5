#!/bin/bash

# 2.a
DIR="students"
old_file=data.csv
new_file=$DIR/data.txt

if [ ! -f "$new_file" ]; then
    touch $new_file
    grep -v "^#" $old_file > $new_file
    num_col=$(awk '{print NF}' $new_file | sort -nu | tail -n 1) # to get the number of columns (6 here)
    for (( i=0; i<=$num_col; i++ )); do
        sed -i -e "s/,//" $new_file
    done
else
    echo "$new_file already present in the directory $DIR"
fi

# 2.b
# count the even numbers

num_rows=$( grep -c " " $new_file )
num_col=$(awk '{print NF}' $new_file | sort -nu | tail -n 1) # to get the number of columns (6 here)
counter=0
zero=0
for (( i=1; i<=$num_rows; i++ )); do
    for (( j=1; j<=$num_col; j++ )); do
        var=$( sed "${i}q;d" $new_file | cut -f$j -d " " )
        val=$(( $var % 2 ))
        if [ $val -eq $zero ]; then
            counter=$(( $counter + 1 ))
        fi
    done
done

echo "There are $counter even numbers"

# 2.c

cols_here=$(( $num_col / 2 )) # 3
greater=0
smaller=0
# Here scale is set to 0 because bash does not allow us to compute easily
# float divisions.
# Moreover, we can't compare floats in an if statement!
sqr_3=$( echo 'scale=6;sqrt(3)' |bc)
check_res=$(bc -l <<< "scale=6; (100*$sqr_3)/2")    # This expression actually compute the right operation
check_res=${check_res%.*}
for (( i=1; i<=$num_rows; i++ )); do
    power=0
    for (( j=1; j<=$cols_here; j++ )); do
        tmp=$( sed "${i}q;d" $new_file | cut -f$j -d " " )
        power=$(( $tmp * $tmp + $power ))
        done
        res=$( echo "scale=6;sqrt($power)" | bc)    # note here the double "", instead of '':
                                                    # if we want the square root of a variable 
                                                    # we have to do like this
        # We can create an if only with integers:
        res=${res%.*}
        if [ $res -gt $check_res ]; then
            greater=$(( $greater + 1 ))
        else
            smaller=$(( $smaller + 1 ))
        fi
done

echo "There are $greater entries are greater then $check_res"
echo "There are $smaller entries are smaller than $check_res"

# 2.d

sub_fold=$DIR/"2.d_exercise"
if [ ! -d "$sub_fold" ]; then
    echo "Folder $sub_fold created!"
    mkdir $sub_fold
else
    echo "The sub folder already exists"
fi

read -p 'Insert a number n (integer): ' n # take as input the number of files to create

new_output=$sub_fold"/number_"
for (( k=1; k<=n; k++ )); do
    new_out=$new_output$k.txt
    if [ ! -f "$new_out" ]; then
        touch $new_out # create the file
        for (( i=1; i<=$num_rows; i++ )); do
            for (( j=1; j<=$cols_here; j++ )); do
                tmp_2=$( sed "${i}q;d" $new_file | cut -f$j -d " " ) # take each element
                process=$( echo "scale=6; $tmp_2 / $k" | bc) # divide each element by k
                echo $process >> $new_out # copy the result in a new file
            done
        done
    else
        echo "The file $new_out already exists"
    fi
done

echo "Done :)"