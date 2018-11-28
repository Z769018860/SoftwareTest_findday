
#! /bin/sh
cat terminal.txt | grep "The Day" | while read str
do
    echo ${str%%.} >> test_result.txt
done
    if [  -f "test_temp.txt" ];
    then
        rm test_temp.txt
    fi
    if [  -f "diffline.txt" ];
    then
        rm diffline.txt
    fi
    if [  -f "sameline.txt" ];
    then
        rm sameline.txt
    fi
    

    i=0
    cat test_result.txt | while read result
    do
    ((i=i+1))
      sed -n ${i}p test_out.txt | while read str_out
    do
    reference="The Day is $str_out" 
    sed -n ${i}p test_in.txt | while read str_in
    do
    #echo $output
    if [ "$reference" \= "$result" ]
        then
        echo "[$i]PASS!!!!!!"
        else
        echo "[$i]$str_in reference:$reference result:$result" >> diffline.txt
        echo "[$i]$str_in reference:$reference result:$result"
      fi
    done
    done
done
