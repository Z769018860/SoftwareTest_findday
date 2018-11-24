
#! /bin/sh
cat $1.csv | awk -F, '{ print $1; }' > test_in.txt
cat $1.csv | awk -F, '{ print $2; }' > test_out.txt
##生成对应的测试文件输入和输出
#i=0;
cat test_in.txt | while read str_in #逐行获取输入
do
    output=`./test.out $str_in >> test_temp.txt 2>&1`
done
cat test_temp.txt | grep "The" >test_result.txt

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
    if [ "$reference" \< "$result" ]
        then
        echo "[$i]PASS!!!!!!"
        echo "[$i]$str_in reference:$reference" >> sameline.txt
        else
        echo "[$i]$str_in reference:$reference result:$result" >> diffline.txt
        echo "[$i]$str_in reference:$reference result:$result"
      fi
    done
    done
done






