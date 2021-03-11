字节顺序标记（BOM）详解

白清羽 2019-05-25 23:36:35  3810  收藏 9
分类专栏： unicode
版权
一、

       BOM：即“Byte Order Mark”的缩写，翻译出来就是字节顺序标记（BOM）的意思

二、

       在UCS 编码中有一个叫做"ZERO WIDTH NO-BREAK SPACE"的字符，它的编码是FEFF。而FFFE在UCS中是不存在的字符，所以不应该出现在实际传输中。UCS规范建议我们在传输字节流前，先传输字符"ZERO WIDTH NO-BREAK SPACE"。这样如果接收者收到FEFF，就表明这个字节流是Big-Endian的；如果收到FFFE，就表明这个字节流是Little-Endian的。因此字符"ZERO WIDTH NO-BREAK SPACE"又被称作BOM。


三、

       UTF-8不需要BOM来表明字节顺序，但可以用BOM来表明编码方式。字符"ZERO WIDTH NO-BREAK SPACE"的UTF-8编码是EF BB BF。所以如果接收者收到以EF BB BF开头的字节流，就知道这是UTF-8编码了。
Windows就是使用BOM来标记文本文件的编码方式的。
       UTF-8编码的文件中，BOM占三个字节。如果用记事本把一个文本文件另存为UTF-8编码方式的话，用UE打开这个文件，切换到十六进制编辑状态就可以看到开头的FFFE了。这是个标识UTF-8编码文件的好办法，软件通过BOM来识别这个文件是否是UTF-8编码，很多软件还要求读入的文件必须带BOM。可是，还是有很多软件不能识别BOM。我在研究Firefox的时候就知道，在Firefox早期的版本里，扩展是不能有BOM的，不过Firefox 1.5以后的版本已经开始支持BOM了。现在又发现，PHP也不支持BOM。

       PHP在设计时就没有考虑BOM的问题，也就是说他不会忽略UTF-8编码的文件开头BOM的那三个字符。由于必须在
在Bo-Blog的wiki看到，同样使用PHP的Bo-Blog也一样受到BOM的困扰。其中有提到另一个麻烦：“受COOKIE送出机制的限制，在这些文件开头已经有BOM的文件中，COOKIE无法送出（因为在COOKIE送出前PHP已经送出了文件头），所以登入和登出功能失效。一切依赖COOKIE、SESSION实现的功能全部无效。”这个应该就是Wordpress后台出现空白页面的原因了，因为任何一个被执行的文件包含了BOM，这三个字符都将被送出，导致依赖cookies和session的功能失效。

       解决的办法嘛，如果只包含英文字符(或者说ASCII编码内的字符)，就把文件存成ASCII码方式吧。用UE等编辑器的话，点文件->转换->UTF-8转ASCII，或者在另存为里选择ASCII编码。如果是DOS格式的行尾符，可以用记事本打开，点另存为，选ASCII编码。如果包含中文字符的话，可以用UE的另存为功能，选择“UTF-8 无 BOM”即可。

     根据Bo-Blog的wiki的说明：Editplus需要先另存为gb，再另存为UTF-8。不过这样做要小心，所有GBK编码中不包含的字符就会都丢了。如果有一些非中文的字符在文件里的话还是不要用这种办法了。(从这一个小方面来看，UE——UltraEdite-32确实比Editplus好很多，Editplus太轻量级了)

      另外我发现了一个办法，就是利用Wordpress提供的文件编辑器。这个办法不受限制，不需要去下载专门的编辑器，毕竟大家都在用Wordpress嘛。先在ftp里把要编辑的文件的写入权限打开，然后进入Wordpress后台->管理->文件编辑器，输入要编辑文件的路径，点编辑文件。在显示出来的编辑界面中，你是看不到开头的那三个字符的，不过没关系，把光标定位在整个文件的第一个字符前，按一下Backspace键。OK了，点更新文件吧，在ftp里刷新一下，可以看到文件小了3字节，大功告成。

      最后说一下，这是个大问题，所有要自己写插件的，编辑别人的插件自己用的，需要修改模版的(这条估计每个人都需要吧)，最好了解一下上面的知识，免得出现问题时不知所措。
 

以下内容来源与unicode 官网：
问：什么是BOM？

答：字节顺序标记（BOM）由数据流开头的字符代码U + FEFF组成，它可以用作定义字节顺序和编码形式的签名，主要是未标记的明文文件。在某些更高级别的协议下，在该协议中定义的Unicode数据流中可能必须（或禁止）使用BOM。 [AF]

问：BOM在哪里有用？

答：BOM在输入为文本的文件的开头很有用，但是不知道它们是大端还是小端格式 - 它也可以作为提示指示文件是Unicode，如与遗留编码相反，此外，它充当所使用的特定编码形式的签名。[AF]

问：'endian'是什么意思？

答：长于一个字节的数据类型可以存储在具有最高有效字节（MSB）的第一个或最后一个的计算机存储器中。前者称为big-endian，后者是little-endian。交换数据时，在发送系统上以“正确”顺序出现的字节在接收系统上可能看起来是乱序的。在这种情况下，BOM看起来像0xFFFE，这是一个非特性，允许接收系统在处理数据之前应用字节反转。UTF-8是面向字节的，因此没有这个问题。然而，初始BOM可能有助于将数据流标识为UTF-8。[AF]

问：使用BOM时，是否仅使用16位Unicode文本？

答：不可以，无论Unicode文本如何转换，BOM都可以用作签名：UTF-16，UTF-8或UTF-32。包含BOM的确切字节将是由该转换格式转换为Unicode字符U + FEFF的任何字节。在该表单中，BOM用于指示它是Unicode文件以及它所处的格式。示例：

字节	编码表格
00 00 FE FF	UTF-32，big-endian
FF FE 00 00	UTF-32，小端
FE FF	UTF-16，big-endian
FF FE	UTF-16，小端
EF BB BF	UTF-8
问：UTF-8数据流是否包含BOM字符（UTF-8格式）？如果是，那么我仍然可以假设剩余的UTF-8字节是大端序吗？

答：是的，UTF-8可以包含BOM。但是，它对 字节流的字节顺序没有影响。UTF-8始终具有相同的字节顺序。初始BOM 仅用作签名 - 表示未标记的文本文件为UTF-8。请注意，某些UTF-8编码数据的收件人不希望使用BOM。在8位环境中透明地使用UTF-8的地方，使用BOM会干扰任何在开头需要特定ASCII字符的协议或文件格式，例如使用“＃！” 在Unix shell脚本的开头。 [AF]

问：在文件中间我应该怎么处理U + FEFF？

答：如果没有支持将其用作BOM的协议，并且不在文本流的开头，则通常不应出现U + FEFF。为了向后兼容，应将其视为零宽度非破坏空间（ZWNBSP），然后将其作为文件或字符串内容的一部分。使用U + 2060 WORD JOINER比ZWNBSP更强烈地表达单词连接语义，因为它不能与BOM混淆。在设计标记语言或数据协议时，U + FEFF的使用可以限制为字节顺序标记的使用。在这种情况下，发生在文件中间的任何U + FEFF都可以视为 不受支持的字符。 [AF]

问：我正在使用在文本开头有BOM的协议。我如何代表最初的ZWNBSP？

答：请使用U + 2060 WORD JOINER。 

问：如何标记不将U + FEFF解释为BOM的数据？

答：使用标签UTF-16BE表示big-endian UTF-16文本，使用UTF-16LE表示little-endian UTF-16文本。如果您使用BOM，请将文本标记为UTF-16。 [MD]

问：为什么我不总是使用需要BOM的协议？

答：如果数据具有关联类型，例如数据库中的字段，则不需要BOM。特别是，如果文本数据流标记为UTF-16BE，UTF-16LE，UTF-32BE或UTF-32LE，则既不需要也不允许 BOM 。任何U + FEFF都将被解释为ZWNBSP。

不要使用BOM标记数据库或字段集中的每个字符串，因为它会浪费空间并使字符串连接变得复杂。此外，它还意味着两个数据字段可能具有完全相同的内容，但不是二进制相等的（其中一个数据字段以BOM开头）。

问：我应该如何处理物料清单？

答：以下是一些指导原则：

特定协议（例如，.txt文件的Microsoft约定）可能需要在某些Unicode数据流（例如文件）上使用BOM。如果需要符合此类协议，请使用BOM。

某些协议允许在未标记文本的情况下使用可选BOM。在那些情况下，

如果已知文本数据流是纯文本，但编码未知，则可以将BOM用作签名。如果没有BOM，则编码可以是任何内容。

如果已知文本数据流是纯Unicode文本（但不是哪个字节序），那么BOM可以用作签名。如果没有BOM，则应将文本解释为big-endian。

一些面向字节的协议期望文件开头的ASCII字符。如果UTF-8与这些协议一起使用，则应避免使用BOM作为编码形式签名。

如果已知数据流的精确类型（例如Unicode big-endian或Unicode little-endian），则不应使用BOM。特别地，每当一个数据流被声明为UTF-16BE，UTF-16LE，UTF-32BE或UTF-32LE一个BOM 必须不能使用。（另请参阅问：UCS-2和UTF-16有什么区别？） [AF]

 

以下内容来源与网络搜索：
 

在编程中，我们有时候会使用codecs.iterencode对文件对象进行包装，也即是使用utf8进行编码，接着又使用codecs.iterdecode对编码的包装器进行解码。最后对文件进行遍历并输出。写入文件头里标记不同编码的常量byte order marks (BOMs)：
 

codecs.BOM 

默认的BOM。

codecs.BOM_BE 

大端格式的BOM。

codecs.BOM_LE 

小端格式的BOM。

codecs.BOM_UTF8 

UTF8的BOM。

codecs.BOM_UTF16 

UTF16的BOM。

codecs.BOM_UTF16_BE 

UTF16的大端的BOM。

codecs.BOM_UTF16_LE 

UTF16的小端的BOM。

codecs.BOM_UTF32 

UTF32默认的BOM。

codecs.BOM_UTF32_BE 

UTF32的大端的BOM。

codecs.BOM_UTF32_LE 

UTF32的小端的BOM。

 

例子：
#python 3.4.3

import codecs

 

print(codecs.BOM)

print(codecs.BOM_BE)

print(codecs.BOM_LE)

print(codecs.BOM_UTF8)

 

print(codecs.BOM_UTF16)

print(codecs.BOM_UTF16_BE)

print(codecs.BOM_UTF16_LE)

print(codecs.BOM_UTF32)

print(codecs.BOM_UTF32_BE) 

print(codecs.BOM_UTF32_LE)

结果输出如下：
b'\xff\xfe'

b'\xfe\xff'

b'\xff\xfe'

b'\xef\xbb\xbf'

b'\xff\xfe'

b'\xfe\xff'

b'\xff\xfe'

b'\xff\xfe\x00\x00'

b'\x00\x00\xfe\xff'

b'\xff\xfe\x00\x00'

 

练习：　
代码如下:
　　import os

　　import codecs

　　filenames=os.listdir(os.getcwd())

　　out=file("name.txt","w")

　　for filename in filenames:

　　out.write(filename.decode("gb2312").encode("utf-8"))

　　out.close()

　　将执行文件的当前目录及文件名写入到name.txt文件中，以utf-8格式保存

　　如果采用ANSI编码保存，用如下代码写入即可：

　　 代码如下:

　　out.write(filename)

　　打开文件并写入

　　引用codecs模块，对该模块目前不了解。在此记录下方法，有空掌握该模块功能及用法。

　　代码如下:

　　import codecs

　　file=codecs.open("lol.txt","w","utf-8")

　　file.write(u"我")

　　file.close()

　　读取ANSI编码的文本文件和utf-8编码的文件

　　读取ANSI编码文件

　　建立一个文件test.txt，文件格式用ANSI，内容为:

　　代码如下:

　　abc中文

　　用python来读取

　　代码如下:

　　# coding=gbk

　　print open("Test.txt").read()

　　结果：abc中文

　　读取utf-8编码文件(无BOM)

　　把文件格式改成UTF-8：

　　代码如下:

　　结果：abc涓 枃

　　显然，这里需要解码：

　　代码如下:

　　# -*- coding: utf-8 -*-

　　import codecs

　　print open("Test.txt").read().decode("utf-8")

　　结果：abc中文

　　读取utf-8编码文件(有BOM)

　　某些软件在保存一个以UTF-8编码的文件时，默认会在文件开始的地方插入三个不可见的字符(0xEF 0xBB 0xBF，即BOM)。在有些软件可以控制是否插入BOM。如果在有BOM的情况下，在读取时需要自己去掉这些字符，python中的codecs module定义了这个常量：

　　代码如下:

　　# -*- coding: utf-8 -*-

　　import codecs

　　data = open("Test.txt").read()

　　if data[:3] == codecs.BOM_UTF8:

　　data = data[3:]

　　print data.decode("utf-8")

　　结果：abc中文

　　在看下面的例子：

　　代码如下:

　　# -*- coding: utf-8 -*-

　　data = open("name_utf8.txt").read()

　　u=data.decode("utf-8")

　　print u[1:]

　　打开utf-8格式的文件并读取utf-8字符串后，解码变成unicode对象。但是会把附加的三个字符同样进行转换，变成一个unicode字符。该字符不能被打印。所以为了正常显示，采用u[1:]的方式，过滤到第一个字符。

　　注意：在处理unicode中文字符串的时候，必须首先对它调用encode函数，转换成其它编码输出。

　　设置python默认编码

　　代码如下:

　　import sys

　　reload(sys)

　　sys.setdefaultencoding("utf-8")

　　print sys.getdefaultencoding()

　　今天碰到了 python 编码问题, 报错信息如下

　　代码如下:

　　Traceback (most recent call last):

　　File "ntpath.pyc", line 108, in join

　　UnicodeDecodeError: 'ascii' codec can't decode byte 0xa1 in position 36: ordinal not in range(128)

　　显然是当前的编码为ascii, 无法解析0xa1(十进制为161, 超过上限128). 进入python console后, 发现默认编码确实是 ascii, 验证过程为:

　　在python2.6中无法调用sys.setdefaultencoding()函数来修改默认编码，因为python在启动的时候会调用site.py文件，在这个文件中设置完默认编码后会删除sys的setdefaultencoding方法。不能再被调用了. 在确定sys已经导入的情况下, 可以reload sys这个模块之后, 再 sys.setdefaultencoding('utf8')

　　代码如下:

　　import sys

　　reload(sys)

　　sys.setdefaultencoding("utf-8")

　　print sys.getdefaultencoding()

　　确实有效, 根据 limodou 讲解, site.py 是 python 解释器启动后, 默认加载的一个脚本. 如果使用 python -S 启动的话, 将不会自动加载 site.py.

　　上面写的挺啰嗦的.

　　==================================

　　如何永久地将默认编码设置为utf-8呢? 有2种方法:

　　==================================

　　第一个方法<不推荐>: 编辑site.py, 修改setencoding()函数, 强制设置为 utf-8

　　第二个方法<推荐>: 增加一个名为 sitecustomize.py, 推荐存放的路径为 site-packages 目录下

　　sitecustomize.py 是在 site.py 被import 执行的, 因为 sys.setdefaultencoding() 是在 site.py 的最后删除的, 所以, 可以在 sitecustomize.py 使用 sys.setdefaultencoding().

　    代码如下:

　　import sys

　　sys.setdefaultencoding('utf-8')

　　既然 sitecustomize.py 能被自动加载, 所以除了设置编码外, 也可以设置一些其他的东西

　　字符串的编码

　　代码如下:

　　s1='中文'

　　像上面那样直接输入的字符串是按照代码文件的编码来处理的，如果是unicode编码，有以下三种方式：

　　代码如下:

　　1 s1 = u'中文'

　　2 s2 = unicode('中文','gbk')

　　3 s3 = s1.decode('gbk')

　　unicode是一个内置函数，第二个参数指示源字符串的编码格式。

　　decode是任何字符串具有的方法，将字符串转换成unicode格式，参数指示源字符串的编码格式。

　　encode也是任何字符串具有的方法，将字符串转换成参数指定的格式。

unicode官网:https://www.unicode.org

unicode之BOM：http://unicode.org/faq/utf_bom.html
————————————————
版权声明：本文为CSDN博主「白清羽」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/gufenchen/article/details/90552774





谈谈Unicode编码，简要解释UCS、UTF、BMP、BOM等名词
这是一篇程序员写给程序员的趣味读物。所谓趣味是指可以比较轻松地了解一些原来不清楚的概念，增进知识，类似于打RPG游戏的升级。整理这篇文章的动机是两个问题：

问题一：
使用Windows记事本的“另存为”，可以在GBK、Unicode、Unicode big endian和UTF-8这几种编码方式间相互转换。同样是txt文件，Windows是怎样识别编码方式的呢？

我很早前就发现Unicode、Unicode big endian和UTF-8编码的txt文件的开头会多出几个字节，分别是FF、FE（Unicode）,FE、FF（Unicode big endian）,EF、BB、BF（UTF-8）。但这些标记是基于什么标准呢？

问题二：
最近在网上看到一个ConvertUTF.c，实现了UTF-32、UTF-16和UTF-8这三种编码方式的相互转换。对于Unicode(UCS2)、GBK、UTF-8这些编码方式，我原来就了解。但这个程序让我有些糊涂，想不起来UTF-16和UCS2有什么关系。
查了查相关资料，总算将这些问题弄清楚了，顺带也了解了一些Unicode的细节。写成一篇文章，送给有过类似疑问的朋友。本文在写作时尽量做到通俗易懂，但要求读者知道什么是字节，什么是十六进制。

0、big endian和little endian
big endian和little endian是CPU处理多字节数的不同方式。例如“汉”字的Unicode编码是6C49。那么写到文件里时，究竟是将6C写在前面，还是将49写在前面？如果将6C写在前面，就是big endian。如果将49写在前面，就是little endian。

“endian”这个词出自《格列佛游记》。小人国的内战就源于吃鸡蛋时是究竟从大头(Big-Endian)敲开还是从小头(Little-Endian)敲开，由此曾发生过六次叛乱，一个皇帝送了命，另一个丢了王位。

我们一般将endian翻译成“字节序”，将big endian和little endian称作“大尾”和“小尾”。

1、字符编码、内码，顺带介绍汉字编码
字符必须编码后才能被计算机处理。计算机使用的缺省编码方式就是计算机的内码。早期的计算机使用7位的ASCII编码，为了处理汉字，程序员设计了用于简体中文的GB2312和用于繁体中文的big5。

GB2312(1980年)一共收录了7445个字符，包括6763个汉字和682个其它符号。汉字区的内码范围高字节从B0-F7，低字节从A1-FE，占用的码位是72*94=6768。其中有5个空位是D7FA-D7FE。

GB2312支持的汉字太少。1995年的汉字扩展规范GBK1.0收录了21886个符号，它分为汉字区和图形符号区。汉字区包括21003个字符。

从ASCII、GB2312到GBK，这些编码方法是向下兼容的，即同一个字符在这些方案中总是有相同的编码，后面的标准支持更多的字符。在这些编码中，英文和中文可以统一地处理。区分中文编码的方法是高字节的最高位不为0。按照程序员的称呼，GB2312、GBK都属于双字节字符集 (DBCS)。

2000年的GB18030是取代GBK1.0的正式国家标准。该标准收录了27484个汉字，同时还收录了藏文、蒙文、维吾尔文等主要的少数民族文字。从汉字字汇上说，GB18030在GB13000.1的20902个汉字的基础上增加了CJK扩展A的6582个汉字（Unicode码0x3400-0x4db5），一共收录了27484个汉字。

CJK就是中日韩的意思。Unicode为了节省码位，将中日韩三国语言中的文字统一编码。GB13000.1就是ISO/IEC 10646-1的中文版，相当于Unicode 1.1。

GB18030的编码采用单字节、双字节和4字节方案。其中单字节、双字节和GBK是完全兼容的。4字节编码的码位就是收录了CJK扩展A的6582个汉字。 例如：UCS的0x3400在GB18030中的编码应该是8139EF30，UCS的0x3401在GB18030中的编码应该是8139EF31。

微软提供了GB18030的升级包，但这个升级包只是提供了一套支持CJK扩展A的6582个汉字的新字体：新宋体-18030，并不改变内码。Windows 的内码仍然是GBK。

这里还有一些细节：

GB2312的原文还是区位码，从区位码到内码，需要在高字节和低字节上分别加上A0。

对于任何字符编码，编码单元的顺序是由编码方案指定的，与endian无关。例如GBK的编码单元是字节，用两个字节表示一个汉字。 这两个字节的顺序是固定的，不受CPU字节序的影响。UTF-16的编码单元是word（双字节），word之间的顺序是编码方案指定的，word内部的字节排列才会受到endian的影响。后面还会介绍UTF-16。

GB2312的两个字节的最高位都是1。但符合这个条件的码位只有128*128=16384个。所以GBK和GB18030的低字节最高位都可能不是1。不过这不影响DBCS字符流的解析：在读取DBCS字符流时，只要遇到高位为1的字节，就可以将下两个字节作为一个双字节编码，而不用管低字节的高位是什么。

2、Unicode、UCS和UTF
前面提到从ASCII、GB2312、GBK到GB18030的编码方法是向下兼容的。而Unicode只与ASCII兼容（更准确地说，是与ISO-8859-1兼容），与GB码不兼容。例如“汉”字的Unicode编码是6C49，而GB码是BABA。

Unicode也是一种字符编码方法，不过它是由国际组织设计，可以容纳全世界所有语言文字的编码方案。Unicode的学名是"Universal Multiple-Octet Coded Character Set"，简称为UCS。UCS可以看作是"Unicode Character Set"的缩写。

根据维基百科全书(http://zh.wikipedia.org/wiki/)的记载：历史上存在两个试图独立设计Unicode的组织，即国际标准化组织（ISO）和一个软件制造商的协会（unicode.org）。ISO开发了ISO 10646项目，Unicode协会开发了Unicode项目。

在1991年前后，双方都认识到世界不需要两个不兼容的字符集。于是它们开始合并双方的工作成果，并为创立一个单一编码表而协同工作。从Unicode2.0开始，Unicode项目采用了与ISO 10646-1相同的字库和字码。

目前两个项目仍都存在，并独立地公布各自的标准。Unicode协会现在的最新版本是2005年的Unicode 4.1.0。ISO的最新标准是ISO 10646-3:2003。

UCS只是规定如何编码，并没有规定如何传输、保存这个编码。例如“汉”字的UCS编码是6C49，我可以用4个ascii数字来传输、保存这个编码；也可以用utf-8编码:3个连续的字节E6 B1 89来表示它。关键在于通信双方都要认可。UTF-8、UTF-7、UTF-16都是被广泛接受的方案。UTF-8的一个特别的好处是它与ISO-8859-1完全兼容。UTF是“UCS Transformation Format”的缩写。

IETF的RFC2781和RFC3629以RFC的一贯风格，清晰、明快又不失严谨地描述了UTF-16和UTF-8的编码方法。我总是记不得IETF是Internet Engineering Task Force的缩写。但IETF负责维护的RFC是Internet上一切规范的基础。

2.1、内码和code page
目前Windows的内核已经支持Unicode字符集，这样在内核上可以支持全世界所有的语言文字。但是由于现有的大量程序和文档都采用了某种特定语言的编码，例如GBK，Windows不可能不支持现有的编码，而全部改用Unicode。

Windows使用代码页(code page)来适应各个国家和地区。code page可以被理解为前面提到的内码。GBK对应的code page是CP936。微软也为GB18030定义了code page：CP54936。

3、UCS-2、UCS-4、BMP
UCS有两种格式：UCS-2和UCS-4。顾名思义，UCS-2就是用两个字节编码，UCS-4就是用4个字节（实际上只用了31位，最高位必须为0）编码。下面让我们做一些简单的数学游戏：

UCS-2有2^16=65536个码位，UCS-4有2^31=2147483648个码位。

UCS-4根据最高位为0的最高字节分成2^7=128个group。每个group再根据次高字节分为256个plane。每个plane根据第3个字节分为256行 (rows)，每行包含256个cells。当然同一行的cells只是最后一个字节不同，其余都相同。

group 0的plane 0被称作Basic Multilingual Plane, 即BMP。或者说UCS-4中，高两个字节为0的码位被称作BMP。

将UCS-4的BMP去掉前面的两个零字节就得到了UCS-2。在UCS-2的两个字节前加上两个零字节，就得到了UCS-4的BMP。而目前的UCS-4规范中还没有任何字符被分配在BMP之外。

4、UTF编码
UTF-8就是以8位为单元对UCS进行编码。从UCS-2到UTF-8的编码方式如下：

UCS-2编码(16进制)	UTF-8 字节流(二进制)
0000 - 007F	0xxxxxxx
0080 - 07FF	110xxxxx 10xxxxxx
0800 - FFFF	1110xxxx 10xxxxxx 10xxxxxx
例如“汉”字的Unicode编码是6C49。6C49在0800-FFFF之间，所以肯定要用3字节模板了：1110xxxx 10xxxxxx 10xxxxxx。将6C49写成二进制是：0110 110001 001001， 用这个比特流依次代替模板中的x，得到：11100110 10110001 10001001，即E6 B1 89。

读者可以用记事本测试一下我们的编码是否正确。需要注意，UltraEdit在打开utf-8编码的文本文件时会自动转换为UTF-16，可能产生混淆。你可以在设置中关掉这个选项。更好的工具是Hex Workshop。

UTF-16以16位为单元对UCS进行编码。对于小于0x10000的UCS码，UTF-16编码就等于UCS码对应的16位无符号整数。对于不小于0x10000的UCS码，定义了一个算法。不过由于实际使用的UCS2，或者UCS4的BMP必然小于0x10000，所以就目前而言，可以认为UTF-16和UCS-2基本相同。但UCS-2只是一个编码方案，UTF-16却要用于实际的传输，所以就不得不考虑字节序的问题。

5、UTF的字节序和BOM
UTF-8以字节为编码单元，没有字节序的问题。UTF-16以两个字节为编码单元，在解释一个UTF-16文本前，首先要弄清楚每个编码单元的字节序。例如“奎”的Unicode编码是594E，“乙”的Unicode编码是4E59。如果我们收到UTF-16字节流“594E”，那么这是“奎”还是“乙”？

Unicode规范中推荐的标记字节顺序的方法是BOM。BOM不是“Bill Of Material”的BOM表，而是Byte Order Mark。BOM是一个有点小聪明的想法：

在UCS编码中有一个叫做"ZERO WIDTH NO-BREAK SPACE"的字符，它的编码是FEFF。而FFFE在UCS中是不存在的字符，所以不应该出现在实际传输中。UCS规范建议我们在传输字节流前，先传输字符"ZERO WIDTH NO-BREAK SPACE"。

这样如果接收者收到FEFF，就表明这个字节流是Big-Endian的；如果收到FFFE，就表明这个字节流是Little-Endian的。因此字符"ZERO WIDTH NO-BREAK SPACE"又被称作BOM。

UTF-8不需要BOM来表明字节顺序，但可以用BOM来表明编码方式。字符"ZERO WIDTH NO-BREAK SPACE"的UTF-8编码是EF BB BF（读者可以用我们前面介绍的编码方法验证一下）。所以如果接收者收到以EF BB BF开头的字节流，就知道这是UTF-8编码了。

Windows就是使用BOM来标记文本文件的编码方式的。

6、进一步的参考资料
本文主要参考的资料是 "Short overview of ISO-IEC 10646 and Unicode" (http://www.nada.kth.se/i18n/ucs/unicode-iso10646-oview.html)。

我还找了两篇看上去不错的资料，不过因为我开始的疑问都找到了答案，所以就没有看：

"Understanding Unicode A general introduction to the Unicode Standard" (http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&item_id=IWS-Chapter04a)
"Character set encoding basics Understanding character set encodings and legacy encodings" (http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&item_id=IWS-Chapter03)
我写过UTF-8、UCS-2、GBK相互转换的软件包，包括使用Windows API和不使用Windows API的版本。以后有时间的话，我会整理一下放到我的个人主页上(http://www.fmddlmyy.cn)。

我是想清楚所有问题后才开始写这篇文章的，原以为一会儿就能写好。没想到考虑措辞和查证细节花费了很长时间，竟然从下午1:30写到9:00。希望有读者能从中受益。

附录1 再说说区位码、GB2312、内码和代码页
有的朋友对文章中这句话还有疑问：
“GB2312的原文还是区位码，从区位码到内码，需要在高字节和低字节上分别加上A0。”

我再详细解释一下：

“GB2312的原文”是指国家1980年的一个标准《中华人民共和国国家标准 信息交换用汉字编码字符集 基本集 GB 2312-80》。这个标准用两个数来编码汉字和中文符号。第一个数称为“区”，第二个数称为“位”。所以也称为区位码。1-9区是中文符号，16-55区是一级汉字，56-87区是二级汉字。现在Windows也还有区位输入法，例如输入1601得到“啊”。（这个区位输入法可以自动识别16进制的GB2312和10进制的区位码，也就是说输入B0A1同样会得到“啊”。）

内码是指操作系统内部的字符编码。早期操作系统的内码是与语言相关的。现在的Windows在系统内部支持Unicode，然后用代码页适应各种语言，“内码”的概念就比较模糊了。微软一般将缺省代码页指定的编码说成是内码。

内码这个词汇，并没有什么官方的定义，代码页也只是微软这个公司的叫法。作为程序员，我们只要知道它们是什么东西，没有必要过多地考证这些名词。

Windows中有缺省代码页的概念，即缺省用什么编码来解释字符。例如Windows的记事本打开了一个文本文件，里面的内容是字节流：BA、BA、D7、D6。Windows应该去怎么解释它呢？

是按照Unicode编码解释、还是按照GBK解释、还是按照BIG5解释，还是按照ISO8859-1去解释？如果按GBK去解释，就会得到“汉字”两个字。按照其它编码解释，可能找不到对应的字符，也可能找到错误的字符。所谓“错误”是指与文本作者的本意不符，这时就产生了乱码。

答案是Windows按照当前的缺省代码页去解释文本文件里的字节流。缺省代码页可以通过控制面板的区域选项设置。记事本的另存为中有一项ANSI，其实就是按照缺省代码页的编码方法保存。

Windows的内码是Unicode，它在技术上可以同时支持多个代码页。只要文件能说明自己使用什么编码，用户又安装了对应的代码页，Windows就能正确显示，例如在HTML文件中就可以指定charset。

有的HTML文件作者，特别是英文作者，认为世界上所有人都使用英文，在文件中不指定charset。如果他使用了0x80-0xff之间的字符，中文Windows又按照缺省的GBK去解释，就会出现乱码。这时只要在这个html文件中加上指定charset的语句，例如：
<meta http-equiv="Content-Type" content="text/html; charset=ISO8859-1">
如果原作者使用的代码页和ISO8859-1兼容，就不会出现乱码了。

再说区位码，啊的区位码是1601，写成16进制是0x10,0x01。这和计算机广泛使用的ASCII编码冲突。为了兼容00-7f的ASCII编码，我们在区位码的高、低字节上分别加上A0。这样“啊”的编码就成为B0A1。我们将加过两个A0的编码也称为GB2312编码，虽然GB2312的原文根本没提到这一点。

 