
#! /bin/sh
    cat terminal.txt | grep "The" >test_result.txt
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
    if [ "$reference" \< "$result" ]
        then
        echo "[$i]PASS!!!!!!"
        else
        echo "[$i]$str_in reference:$reference result:$result" >> diffline.txt
        echo "[$i]$str_in reference:$reference result:$result"
      fi
    done
    done
done
