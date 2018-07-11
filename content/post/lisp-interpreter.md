---
title: "Lisp解释器的代码分析过程记录"
date: 2016-05-29T23:08:52Z
draft: false
---

### 说明

由于文章不是同一时间写的，而是不断的往上加内容，而且我觉得这样完整的记录我的整个分析记录是非常不错的方式，对于我的混乱写作感到抱歉请见谅，我只是遵循着心中的言语而作的记录

五一期间，打算给自己整天的时间好好看看《实用Common Lisp编程》，却是意外的发现了篇非常棒的lisp入门文章-过河卒的（记得以前我是看过了，但是当时不知道是觉得难还是其他什么原因，没继续看），里面从基础直到讲解编写一个lisp解释器的实现（文章是这么说的），已经忘了怎么能找到的了，回想起来，将其称之为缘分吧，我无法解释这些我喜欢的东西能这么有幸与我相遇(不仅仅是编程)，也是我为什么需要写文的原因，因为我会忘了一切，几乎就没记住过很多东西，我讨厌让我的脑子很累(我非常刻意的逃避一些东西,请原谅我的记性，因为我不会记得我不感兴趣的东西，因为那太累了[借口？我想是的])


回到这篇文章，看它来入门真的非常不错，我看到讲到Lisp世界七个公理的部分，我搜索了下"Lisp七个公理", 有幸找到了维基教科书里面的Lisp入门，这网站非常好，能够生成电子书以下载，

网站地址在此: [Lisp 入門](http://zh.wikibooks.org/wiki/Lisp_%E5%85%A5%E9%96%80)
将其10章看完，感觉我之前看到《实用Common Lisp编程》实在不该（这个入门比较简单，能比较好的理解lisp一些基本知识），对比这3篇我看过的入门文章，我不想去说哪个好，我本身没什么本事，没那个资格评判它们(当然，我是认为该尊重自己内心的想法就好[它既不正确也不错误]，它是怎么就怎么),它们给了我不同的视角去了解lisp,让我发现，哦，原来入门文章可以这么写(今天刚看了个视频，讲的是有名的IT词汇的解释，里面讲课的方式就非常棒，事先弄出一个画面，然后拿着各种接下来的操作的纸条，场景来继续下面的讲课，非常生动)
下面是过河卒的lisp入门文章链接
[http://www.cnblogs.com/suiqirui19872005/archive/2007/12/05/984517.html](http://www.cnblogs.com/suiqirui19872005/archive/2007/12/05/984517.html)
当然这个解释器可能是出自这里的
[http://daiyuwen.freeshell.org/gb/rol/roots_of_lisp.html](http://daiyuwen.freeshell.org/gb/rol/roots_of_lisp.html)

文章基本看完了，剩下下面的lisp解释器实现实在是看不懂，于是将我的下班空闲时间都用来研究它了，以下是笔记

2014-05-06 00:52:12



需要注意的是，文章后面2章顺序颠倒了，而且函数pair实现最后一行`(pair (cdr) (cdr y))))))`应改为`(pair (cdr x) (cdr y))))))`,具体的`eval`，`assoc`函数应该改个名字，我不知道common lisp标准里面有没有它们(应该是有吧,没去研究),反正我是提示了已存在函数声明，所以我改成了加个2的名字


-————完整程序 迷糊的摘录了(拷贝的)，学习中修正错误-----------------

```lisp
(defun assoc2 (x y)
  (cond ((eq (caar y) x) (cadar y))
        (t (assoc x (cdr y)))))

> (assoc2 'a '((a 1) (b 2)))
1

(defun pair (x y)
  (cond ((and (null x) (null y)) '())
        ((and (not (atom x)) (not (atom y)))
         (cons (list (car x) (car y))
               (pair (cdr x) (cdr y))))))
> (pair '(1 2) '(A B))
((1 A) (2 B))


(defun eval2 (e a)
  (cond
    ((atom e) (assoc2 e a))    ;第一段
    ((atom (car e))        ;第二段
     (cond
       ((eq (car e) 'quote) (cadr e))
       ((eq (car e) 'atom)  (atom   (eval2 (cadr e) a)))
       ((eq (car e) 'eq)    (eq     (eval2 (cadr e) a)
                                    (eval2 (caddr e) a)))
       ((eq (car e) 'car)   (car    (eval2 (cadr e) a)))
       ((eq (car e) 'cdr)   (cdr    (eval2 (cadr e) a)))
       ((eq (car e) 'cons)  (cons   (eval2 (cadr e) a)
                                    (eval2 (caddr e) a)))
       ((eq (car e) 'cond)  (evcon (cdr e) a))
       ('t (eval (cons (assoc2 (car e) a)
                        (cdr e))
                  a))))     ;第二段结束
    ((eq (caar e) 'label)
     (eval (cons (caddar e) (cdr e))
            (cons (list (cadar e) (car e)) a)))
    ((eq (caar e) 'lambda)
     (eval (caddar e)
            (append (pair (cadar e) (evlis (cdr  e) a))
                     a)))))

(defun evcon (c a)
  (cond ((eval2 (caar c) a)
         (eval2 (cadar c) a))
        ('t (evcon (cdr c) a))))

(defun evlis (m a)
  (cond ((null m) '())
        ('t (cons (eval2  (car m) a)
                  (evlis (cdr m) a)))))

```

```lisp
; 基本知识
; 1，lisp七个基本操作符，caar，cadr等函数的理解，
-------------------我写的程序----------------
; 依赖函数
(defun assoc2 (x y)
  (cond ((eq (caar y) x) (cadar y))
        (t (assoc2 x (cdr y)))))
>(assoc2 'a '((a x) (b y)))
x 
```

------



第一段

刚看时就感觉在看天书啊，根本看不懂每一句为什么要这么写，有什么意义，所以刚开始看的时候是一句句分析，代入分析一句句代码到底要干什么，为什么要这么写先没考虑，后面不知道怎么想到的方法，将代码从大块划分成小块，然后在小块里面找最内层的表达式，然后编写函数模拟里面的代码，一点一点的扩大范围，简单的说就是看着代码，然后编写一个和原代码很像的一段代码，理解后再替换成源代码，这么就理解了该段代码到底要做什么

```
(defun f1 (e a)

(cond ((atom e) (assoc2 e a))))

>(f1 'a '((a 1) (b 2)))

1

>(f1 'a '((a (q 1) (b 2))))

(Q 1)

```



当参数e为原子的时候，返回a列表中a元素后面的元素,读懂这句其实还是不大清楚要做什么，先接着看下去



第二段

第二段程序比较长，刚开始我先试着读它的结构，发现，它是读取 参数e中第一个元素，判断其值是否是七个基本操作符`(quote,atom,eq,car,cdr,cons,cond)`,执行不同操的操作

因为我实在难以看懂整个程序，我希望我将它们分解，然后一步一步的实现它们，以此来弄懂程序在做些什么，所以会写很多个看似无关的函数，但它们是我了解整个程序的很重要一步

判断e的第一个参数是否是原子，是就输出yes

```lisp
(defun f2(e)
  (cond
    ((atom (car e)) (format t "yes"))))

>(f2 '(a))
yes
nil

; 实现判断quote段

(defun f2 (e)
  (cond
    ((atom (car e)) (eq 'quote (car e)))))

>(f2 '(quote))
T
>(f2 '(eq))
nil
```


接下来，按照代码上，如果等于参数e第一个元素等于`quote`，应该是返回e的第二个元素，参见代码`((eq (car e) 'quote) (cadr e))`

```lisp
(defun f2 (e)
  (cond
    ((atom (car e))
     (cond ((eq (car e) 'quote) (cadr e))))))
```

这里我们可以看到，当e的第一个元素是quote的时候，会返回其后面的元素<即e的第二个元素>，但是第三个元素好像没有处理，先不管，接下来我们试试将第一段和本段合并，然后测试看看,我们合并的方法就不用f了，统一叫eval2,因为系统存在了eval函数所以我们重命名为eval2

```lisp
(defun eval2 (e a)
  (cond
    ((atom e) (assoc2 e a))
    ((atom (car e))
     (cond ((eq (car e) 'quote) (cadr e))))))

>(eval2 'b '((a 111) (b 222)))
222
>(eval2 '(quote qq) ())
qq
```

完成，除了第二段判断quote能看得出有些意义，看不懂第一个有什么意义，应该和后面递归有关系的
2014-05-04 03:16:24

------



先简单的分析下至此的代码，eval2接受2个参数，暂时我还不能准确的定义它们到底有什么用，可能看完了这个代码也不能确定吧
但是至此的代码我们可以看得出，e传入的值应该是原子的话，就将a中值等于e的元素的后一位元素返回，如 (eval2 'a '((a 1) (b 2))) => 1,在此其实是规定了当e为原子的时候我们该做什么，同时也规定了当参数e为原子的时候，a就必须是((x 返回值1) (y 返回值2)…)的格式，否则会出错
接着，如果e不是原子，那么就是列表啦，接下来的代码是进行一堆判断，分别将列表e中第一个元素即(car e)和七个基本操作符进行eq判断，执行相应的操作，那么到此我们只实现了判断(car e)是否等于quote，是的话就返回e的第二个元素，如(eval2 '(quote qq) ()) => qq,这就根据quote的特性，返回qq
2014-05-06 01:26:13

------

((eq (car e) 'eq) (eq (eval2 (cadr e) a) (eval2 (caddr e) a)))
看了前面那么多，现在可以一眼看出，当e的第一个元素为eq的时候，将第二第三个元素进行eq比较，并返回

((eq (car e) 'car) (car (eval2 (cadr e) a)))
当e的第一个元素为car的时候，对e的第二个元素进行car操作,即(car (cadr e))

((eq (car e) 'cdr) (cdr (eval2 (cadr e) a)))
当e的第一个元素为cdr的时候，对e的第二个元素进行cdr操作,即(cdr (cadr e))

((eq (car e) 'cons) (cons (eval2 (cadr e) a) (eval2 (caddr e) a)))
当e的第一个元素为cons的时候，对e的第二,第三个元素进行cons操作,即(cons (cadr e) (caddr e))

至此，第二段代码就只剩下最后一个比较复杂的小节啦，在第二段这里，我们需要清楚的明白这七个操作符的作用，而且这里的具体实现都用到的是它们本身，我们需要做的只是取出其后面的元素而已(使用eval2),总结起来整段代码都不算很复杂，可以这么理解
如果e元素1等于xxx,返回(xxx e元素2 [e元素3])

2014-05-09 02:22:27

------



接下来的是cond,第一个元素是`cond`,执行`(evcon (cdr e) a)`，那么就是将去掉e中的第一个元素，传入`evcon`，我们看一下`evcon`函数的实现

```lisp
(defun evcon (c a)
  (cond ((eval2 (caar c) a)
         (eval2 (cadar c) a))
    ('t (evcon (cdr c) a))))
```

可以看出`evcon`的作用是，调用`eval2`得到第一个的第一个元素`(eval2 (caar c) a)`是否是`T`,是则执行其后面的值`(eval2 (cadar c) a)`
否则就将去掉`c`的第一个元素然后传入`(evcon (cdr c) a)`, `evcon`可以这么理解，它实现对参数以`cond`语法规定的方式进行处理，其中使用`eval2`函数来求值
用几个例子来了解`evcon`函数的处理
首先我们写一句`cond`语句
`(cond ((< 1 2) (quote a)))` => A
上面第一个元素是`cond`，那么首先会对`(< 1 2)`求值，如果是`T`，执行`(quote a)`，很明显1是小于2的，那么执行`(quote a)`，返回A
接下来复杂一点

```lisp
(cond ((< 1 0) (quote a))
  ((< 1 2) (quote b)))
```


在这里，首先取得`(< 1 0)`的值为`nil`(假)，那么不会执行后面的`(quote a)`，然后取得`(< 1 2)`的值为`T`,执行`b`

那么我们现在写的是一个lisp解释器，那么我们的eval2函数能够解释并执行上面的两个`cond`语句的(==这里存在错误的地方,当时阻碍了我对代码的理解,后面会提到==)
我们将语句代入`eval2`函数是

```lisp
(eval2 '(cond ((< 1 2) (quote a))) nil)

=> (evcon (cdr '(cond ((< 1 2) (quote a)))) nil) ;根据((eq (car e) 'cond)  (evcon (cdr e) a))的定义

=> (evcon (((< 1 2) (quote a))) nil) ;这里要理解(cdr '(cond ((< 1 2) (quote a)))) => (((< 1 2) (quote a)))

=> (cond ((eval2 (caar (((< 1 2) (quote a)))) nil) ;这里到了evcon函数内部，我将代表的列表传了进来
          (eval2 (cadar (((< 1 2) (quote a)))) nil))
     ('t (evcon (cdr (((< 1 2) (quote a)))) nil))))

=> (cond ((eval2 (< 1 2) nil) ;由此我们看到了当evcon是将参数里面的判断真假值的部分求值然后，T的部分求值返回
          (eval2 (quote a) nil)) ;而求值我们是使用eval2函数求值
     ('t (evcon nil nil)))

=> (eval2 (quote a) nil) ;按照我们推测，结果是执行(eval2 (quote a))那么得出的结果自然是A
=> A
```



现在试着将更复杂的`cond`语句放入我们的eval2函数

```lisp
(eval2 '(cond ((< 1 0) (quote a)) ((< 1 2) (quote b))) nil)
=> (evcon (cdr '(cond ((< 1 0) (quote a)) ((< 1 2) (quote b))) nil)
=> (evcon (((< 1 0) (quote a)) ((< 1 2) (quote b))) nil)
=> (cond ((eval2 (caar (((< 1 0) (quote a)) ((< 1 2) (quote b)))) nil)
          (eval2 (cadar (((< 1 0) (quote a)) ((< 1 2) (quote b)))) nil))
         ('t (evcon (cdr (((< 1 0) (quote a)) ((< 1 2) (quote b)))) nil)))
=> (cond ((eval2 (< 1 0) nil)                ;在这里我们可以看出当第一个元素的条件不成立，它会使用evcon去计算剩余的参数
          (eval2 (quote a) nil))            ;这样也就达到了cond根据条件是否执行接下来代码的部分
         ('t (evcon (((< 1 2) (quote b))) nil)))
=> (evcon (((< 1 2) (quote b))) nil)
```


…以下是什么的重复了，把参数代入计算即可

当你执行上面写的代码的时候会发现出现问题，其原因是里面存在了`(eval2 (< 1 2))`这样的代码，我们的lisp解释器到底实现了什么，它到目前为止，只是能解析
`quote,atom,eq,car,cdr,cons,cond`
当`eval2`遇到<的时候，`(< 1 2)`并不能得到一个真或假，我们可以使用非空列表或t表示真，那么就把其中求真求真假部分简单的用nil或t代替吧

```lisp
(eval2 '(cond ('t (quote a))) nil)
A

(eval2 '(cond ('nil (quote a)) ('t (quote b))) nil)
B
```

好的，这一部分将近看完了，还剩下最后一小段代码了，这里需要注意的是，这里的`evcon`函数并没有对`nil`进行处理，当所有的条件都不为`T`的时候，将会陷入死循环，无限的调用`(evcon nil nil)`

2014-05-11 19:05:10



------

第一段的最后一句，当`e`的第一个元素不为上述基本操作符的时候，那么会以`e`的第一个元素为条件，从`a`中获取对应的值，此时我们应该清楚了`a`的作用了，我们称它为上下文吧，我们需要`a`以`((属性1 值1) (属性2 值2) (属性3 值3)….)`的方式保存值，使用`assoc2`函数根据属性获取值
在最后这段代码，因为到这步，就表示e的第一个元素不是上面的操作符，所以以`e`的第一个元素为属性，从`a`里面获取值，然后再加上`(cdr e)`构成新列表，新列表同样使用`eval2`解析
如下例子

```lisp
(eval2 '(qq a b c) '((qq quote)))
=> (eval2 (cons (assoc2 (car (qq a b c)) ((qq quote)))
                        (cdr (qq a b c)))
            ((qq quote)))
=> (eval2 (cons (assoc2 qq ((qq quote)))
                     (a b c))
           ((qq quote)))
=> (eval2 (cons quote  (a b c)) ((qq quote)))
=> (eval2 (quote a b c) ((qq quote)))
=> (eval2 (quote a b c))            ;因为qq不属于上面定义的任何一个基本操作符，所以
=> (quote a)
=> A
```



第一段解释完毕

由于后面的代码是解析`label`和`lambda`，对此不熟悉，暂时不看代码了，转而继续学习Lisp，哪天再回头看看
2014-5-22 0:03:16



```lisp
;;; 完整源代码
(defun assoc2 (x y)
  (cond ((eq (caar y) x) (cadar y))
        (t (assoc x (cdr y)))))

(defun eval2 (e a)
  (cond
    ((atom e) (assoc2 e a))
    ((atom (car e))
     (cond
       ((eq (car e) 'quote) (cadr e))
       ((eq (car e) 'atom)  (atom   (eval2 (cadr e) a)))
       ((eq (car e) 'eq)    (eq     (eval2 (cadr e) a)
                                    (eval2 (caddr e) a)))
       ((eq (car e) 'car)   (car    (eval2 (cadr e) a)))
       ((eq (car e) 'cdr)   (cdr    (eval2 (cadr e) a)))
       ((eq (car e) 'cons)  (cons   (eval2 (cadr e) a)
                                    (eval2 (caddr e) a)))
       ((eq (car e) 'cond)  (evcon (cdr e) a))))))
       

(defun evcon (c a)
  (cond ((eval2 (caar c) a)
         (eval2 (cadar c) a))
        ('t (evcon (cdr c) a))))
```





### 参考

[过河卒的Lisp入门](http://www.cnblogs.com/suiqirui19872005/archive/2007/12/05/984517.html) 
[维基教科书Lisp入门](http://zh.wikibooks.org/wiki/Lisp_%E5%85%A5%E9%96%80) 