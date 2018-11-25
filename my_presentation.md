% 软件测试与分析-黑盒测试
% 2018.11.24
% 张丽玮 2016K8009929029


## 测试要求

1. 输入"D M Y"返回当天是星期几（范围从1900年到2500年）
2. 对于输入的形式要有明确的提示
3. 当输入不合法的时候需要提醒用户
4. 程序不应该停止运行（卡住、关闭等）当输入不合法的时候
5. 黑盒方法设计测试用例


## 测试方法分析

1. 由于输入不合法时没有特定输出要求，因此暂时认为可以手动测试不合法输入，之后再用脚本进行压力测试。
2. 由于1900-2500年总体数据量过于庞大，因此不选择全部天数测试的全部遍历测试方法，但是可以考虑以下方法
* 回溯算法
* 随机测试方法
* 组合测试方法

----

3. 数据量较大，考虑用脚本实现。而关于如何生成测试数据，我应用了现成的excel软件功能，只需要更改单元格格式，就可以输出对应日期是星期几，并且这样生成csv文件对于之后脚本处理较为方便。

----

### 测试算法分析

1. 全部遍历算法：数据量过大，不进行选择
2. 回溯算法：

    实际上考虑回溯算法，是因为日期和星期之间是有规律存在的，或者说是可以构成循环的。
    一周七天，一年365或者366天，由于4年一个闰年，因此以年来计算，28年将会产生一个“星期-日期”的循环。也就是说，我的"D M Y"和“D M Y+28”对应星期几应该是相同的。既然如此，我们就可以采用回溯算法，给定一个日期，然后在年份上加减28的倍数，从而计算是否相等。

----

3. 随机测试方法：

    非常显然，由于我之前分析过28年一个周期，所以这里可以只随机选择前28年中的任意一天，然后年份全部一直+28直到2500年。同样，这个也可以在excel中用随机生成日期的公式完成。
4. 组合测试方法：

    我认为这个针对这个黑盒测试，组合测试没有必要，因为其实它本身就是一个组合测试——日、月、年的三元素组合。因此我觉得这样的输入数据难以分组，分组形式只可能是无效输入和有效输入组合，这个手动测试就能发现问题。

---

## 具体实现

----

### 无效输入测试

----

* 整型无效

![1]

可以报错从年月日依次报错，并且会提示某月最多只有多少天，月份是1-12，不会出现卡死、关闭等现象。

----

![2]

但是如果年份月份符合要求时，判断日期会出错。当日期<=0时并不会报错，反而会输出结果。大体可以推断这是由于日期只进行了上界判断而没有判断下界。【bug1】

----

* 无输入

无输入，一直空格回车时不会有任何输出（windows、linux都是）

----

* 输入类型无效
![3]

----

当输入非整型时，会进入死循环，只能强制退出。

无论是字母还是符号。【bug2】

----

* 压力测试

只考虑整型无效的压力测试，测试结果并无异常。

---

### 有效输入测试

* 1900-1927范围内28年的所有日期情况

![4]

----

10231个测试用例全部pass，没有生成diffline.txt文件

----

* 随机测试

随机测试是在excel里面随机生成1000个1900-2500范围内的有效日期，然后用脚本进行测试。

----

· 第一组1000个测试数据：

![5]

----

查看diffline.txt的错误输出文本，共有273个错误，即这次的错误率是273/1000

接下来开始分析错误日期：

----

![6]

----

运用查询发现，所有错误日期都在2000年之后，不存在19xx的日期错误。那么初步猜测，1900-2000并没有错误。因此接下来进行分类测试：1900-2000年间和2000-2500年间

----

· 第二组1900-2000年间1000个测试数据：

![7]

----

1000个测试数据全部pass，也就是100%的通过率。再结合前28年全部pass的情况，现在有充足理由认为1900-2000年间全部正确没有bug。

----

· 第三组2000-2500年间1000个测试数据：

![8]

----

可以发现这一次有相当多的错误情况。而查看diffline.txt的错误报告，共有378个错误，错误率是378/1000

继续分析错误日期：

----

![9]

发现并没有2000-2100年间的错误日期。按照同样的方法再次缩小范围。

----

· 第四组2000-2100年间1000个测试数据:

全部pass，认为这之间没有bug。

----

· 第五组2100-2500年间1000个测试数据：

![10]

----

明显错误更多了，这时候再查看diffline.txt，共有468个错误，错误率468/1000

继续分析错误日期：

----

![11]

----

然而目前肉眼已经难以判断出其中的规律。为了判断主要错误从哪里开始发生，查看samelin.txt，这时发现有这样的情况：

----

![12]

那么此时猜测一下，现在的bug和年份无关，而是和月、日有关，因此接下来选择一年的366天进行遍历，各选择两年。

----

· 第六组2325年的全部365个测试数据

![13]

----

一眼就能看出报错非常有规律，然后去查看diffline.txt，

----

![14]

非常明显，它所有的周二周三周四都判断错误，都错判成了周五周六周日。那么其他年份呢？

----

· 第七组2202年的全部365个测试数据

![15]

同样非常有规律，甚至比2325年还多了一个周六的错误。去查看diffline.txt也发现这一年所有的周二周三周四和周六都是错的。

----

【bug】

现在初步得到猜测：1900-2100年间的日期对应星期都是正确的，但是2100-2500年间有错误，并且错误有规律。是每一周的固定几天出错，后来猜测每一百年改变一次规律，又进行了几个单独年份的测试，最后得到的结果如下：

----

从2100年3月3日开始出错

2100-2199年——所有周三周四周日都为周四周五周一

2200-2299年——所有周二周三周四周六都为周四周五周六周一

2300-2499年——所有周二周三周四都为周五周六周日

2500年从3月1日开始所有周一周二周三周四都为周五周六周日周一

---

### 测试脚本

实验过程中均采用我自己用shell编写的简易脚本，在linux上运行
· 一键完成脚本test0
```shell

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

```

----

使用方法是输入 ./test0.sh 测试数据csv表名

注：不要写csv后缀

生成的diffline.txt会标注所有错误的行数、日期、以及正确输出和错误输出

生成的sameline.txt则是所有正确的行数、日期、正确输出


---

· 分步式防卡死脚本test+test2

```shell

#! /bin/sh
cat $1.csv | awk -F, '{ print $1; }' > test_in.txt
cat $1.csv | awk -F, '{ print $2; }' > test_out.txt
##生成对应的测试文件输入和输出
#i=0;
cat test_in.txt | while read str_in #逐行获取输入
do
    #echo "$str_in"
    output=`./test.out $str_in`
done

```

---

```shell

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

```

----

使用方法：

script terminal.txt先打开终端日志记录

./test.sh 测试数据表名

exet退出终端日志

然后执行./test2.sh

最后生成的文件结果和test0一样。

这两个脚本只是防止一键完成时中途卡死，通过终端日志中转完成测试。

---

## 结果总结

### 发现的bug

1. 非整型类型的无效输入会导致死循环
2. 日期<=0 但是月年正确时不会报错

----

3. 从2100-2500年间规律性出错
从2100年3月3日开始出错
2100-2199年——所有周三周四周日都为周四周五周一
2200-2299年——所有周二周三周四周六都为周四周五周六周一
2300-2499年——所有周二周三周四都为周五周六周日
2500年从3月1日开始所有周一周二周三周四都为周五周六周日周一

----

### 猜测bug原因

1. 没有进行类型判断，并没有处理整型以外的类型，导致读入错误进入死循环
2. 没有进行日期的下界判断，导致没有报错正常输出 
3. 这个我觉得不是代码功能性错误或者逻辑错误导致的，应该属于人为控制，故意更改了一些年份的输出（比如每隔100年换一下错误输出），而且这个太具有规律性，是按周出错，猜测是直接写了if判断条件强行改变了输出。

----

### 不足之处

1. 初始的28年计算显得多此一举。实际上这个实验，回溯算法并没有很好的效果
2. 随机算法随机性比较大，还是不能完全排除遗漏的错误可能（比如再1900-2100年间）
3. 最后单独分析年份的时候是取的每一百年的头尾，因为猜测是百年计更改的输出，但是不排除可能这中间的年份并不是这个规律。

----

4. 测试工程量还是比较大，实际上我是在手动进行数据的筛选工作，而更理想的情况是我们把这个也编入脚本，由脚本来进行筛选，这样效率更高，准确率也更高。
5. 实际上查资料发现一般万年历是从1900年1月1日为周一开始计算的，但是excel实际上是周日，而且1900年被认为是闰年，巧合的是这个软件也这么认为了。所以说我这一段是全pass的，但如果是从按照一般万年历，应该从1900年1月1日到1900年2月28日的结果都是有误的，直到3月1日恢复正常。

---

## 补充说明

除了文档外所有的包括脚本、数据、错误输出等文件全部打包
文件架构如下：
```
SoftwareTest_findday
├─reveal.js
├─test_data
│  ├─test_2100
│  ├─test_2199
│  ├─test_2202
│  ├─test_2299
│  ├─test_2300
│  ├─test_2325
│  ├─test_2400
│  ├─test_2499
│  ├─test_2500
│  ├─test_all
│  ├─test_random1
│  ├─test_random2
│  ├─test_random3
│  ├─test_random4
│  └─test_random5
├─test_result
│  ├─diffline_2100
│  ├─diffline_2199
│  ├─diffline_2202
│  ├─diffline_2299
│  ├─diffline_2300
│  ├─diffline_2325
│  ├─diffline_2400
│  ├─diffline_2499
│  ├─diffline_2500
│  ├─diffline_random1
│  ├─diffline_random3
│  └─diffline_random5
├─test.exe
├─test.out
├─test0.sh
├─test.sh
├─test2.sh
├─test_in.txt
├─test_out.txt
├─test_result.txt
├─my_presentation.md
├─my_presentation.html
├─软件测试分析-黑盒测试.pdf
└─README.md

```

----

使用说明：由于测试的时候并没有分文件夹全都在一个目录下，因此如果要测试数据需要在写表名时加上path。

my_presentation和reveal.js必须在同一目录下才能正常播放

----

  [1]: http://static.zybuluo.com/Z769018860/cfbbbmtfoei9qj1rs7m5bsvi/image.png
  [2]: http://static.zybuluo.com/Z769018860/h1nvd7vefl4yi5gtb1tanvne/image.png
  [3]: http://static.zybuluo.com/Z769018860/5gphjt1ttphbyy7dnmyt3lxz/image.png
  [4]: http://static.zybuluo.com/Z769018860/jda2hj2l6rch7gzpowabpk65/image.png
  [5]: http://static.zybuluo.com/Z769018860/lac8t7i6ezfq8gef8lgdj041/image.png
  [6]: http://static.zybuluo.com/Z769018860/ajf1szjhi5yktl6ogq51a0vk/image.png
  [7]: http://static.zybuluo.com/Z769018860/4m0mw0xafubhtotxoeugg52x/image.png
  [8]: http://static.zybuluo.com/Z769018860/7uwwn92z4pyrntjqxk8ktget/image.png
  [9]: http://static.zybuluo.com/Z769018860/zayh8m6u973bdp85vz1zkpd8/image.png
  [10]: http://static.zybuluo.com/Z769018860/a7c1na4b02sk5yc6hzmbwtlt/image.png
  [11]: http://static.zybuluo.com/Z769018860/wssd20jxc9owq5721mbajei0/image.png
  [12]: http://static.zybuluo.com/Z769018860/x7axkpn0k5wno58l33n615ar/image.png
  [13]: http://static.zybuluo.com/Z769018860/n6p61bxxfg0pr9mhrv4j3bgk/image.png
  [14]: http://static.zybuluo.com/Z769018860/pvhmio5ewdfofwffz4czhog2/image.png
  [15]: http://static.zybuluo.com/Z769018860/n18cwrdecoaodjgsw9itjrab/image.png