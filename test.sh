
#! /bin/sh
cat $1.csv | awk -F, '{ print $1; }' > test_in.txt
cat $1.csv | awk -F, '{ print $2; }' > test_out.txt


    if [  -f "test_result.txt" ];
    then
        rm test_result.txt
    fi
##生成对应的测试文件输入和输出
#i=0;
cat test_in.txt | while read str_in #逐行获取输入
do
    #echo "$str_in"
    output=`./test.out $str_in`
done






