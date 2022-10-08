---
title: Ruby Cheat Sheet 2 -- 基础
tags: ["Ruby", "笔记"]
key: blog-2022-10-08
---

Ruby 语言有很多特点和标签：面向对象、脚本语言、跨平台、开源，最吸引我的是 Ruby 认为其自身是一种旨在使大家编程时能乐在其中的编程语言，正是所谓的「快乐编程」。因为兴趣原因接触了一下 Ruby 这门语言，但由于目前我来说并不会经常使用 Ruby，所以在这边做一个 Cheat Sheet 的存档，方便之后随时查阅。

* [Ruby Cheat Sheet 1 -- 初体验](https://mim0sa.github.io/2021/02/18/Ruby-Cheat-Sheet-1-%E5%88%9D%E4%BD%93%E9%AA%8C.html)

* Ruby Cheat Sheet 2 -- 基础

> 以下内容应多源于《Ruby 基础教程》一书，作为该书的读书笔记。

<!--more-->



## Ruby 的基础

### 「4」对象、变量和常量

常量、局部变量与全局变量：

```ruby
T = 1   # 常量
x = 0   # 局部变量
$x = 0  # 全局变量
```

多重赋值的使用：

```ruby
a, b, c = 1, 2, 3
a, *b, c = 1, 2, 3, 4, 5 
#=> 1, [2, 3, 4], 5

a, b = b, a  # swap

ary = [1, 2]
a, b = ary  #=> a = 1, b = 2
a, = ary    #=> a = 1
```

### 「5」条件判断

Ruby 中可以作为条件判断的方法：

```ruby
p "".empty?   #=> true
p "A".empty?  #=> false
p /Ruby/ =~ "HiRuby"   #=> 2
p /Ruby/ =~ "Diamond"  #=> nil
```

> 在 Ruby 中除了 `false` 和 `nil` 以外的值都是代表「真」。

> 在 Ruby 中有个约定俗成的规则，返回真假值的方法都要以 `?` 结尾。

`if` 语句的简单使用：

```ruby
a, b = 10, 20
if a > b
  puts "a > b"
elsif a < b
  puts "a < b"
else
  puts "a = b"
end
```

`unless` 语句的简单使用：

```ruby
a, b = 10, 20
unless a > b
  puts "a <= b"
end
```

`case` 语句的简单使用：

```ruby
tags = ["A", "B", "C"]
tags.each do |tag|
	case tag
	when "A"
		puts "A"
	when "B"
		puts "B"
	else
		puts "C"
	end
end
		

ary = ["a", 1, nil]
ary.each do |item|
	case item
	when String
		puts "String"
	when Numeric
		puts "Numeric"
	else
		puts "Somrthing"
	end
end

text = ""
text.each_line do |line|
	case line
	when /^From:/i
		puts "From"
	when /^To:/i
		puts "To"
	when /^Subject:/i
		puts "Subject"
	when /^$/
		puts "Finshed"
		exit
	else
		## jump out
	end
end
```

> `case` 语句实际上是用 `===` 来进行判断的，其比 `==` 的判断内容要更宽泛一些。

> Ruby 中的对象都有一个 `object_id`，可以使用 `equal?` 来比较两个对象是否相等。

### 「6」循环

times 方法

```ruby
5.times do |i|
  puts "第#{i + 1}次循环"
end
```

for 语句

```ruby
name = ["M", "i", "m", "0", "s", "a"]
for char in name do 
  puts char
end
```

while 语句

```ruby
i = 1
while i < 3 do
  puts i
  i += 1
end
```

until 语句

```ruby
i = 1
until i > 3 do
  puts i
  i += 1
end
```

each 方法

```ruby
(1...5).each do |i|
  puts i
end
```

loop 方法

```ruby
loop do
  puts "Ruby"
end
```

循环控制

```ruby
break next redo
```

### 「7」方法

按接收者的种类不同，Ruby 的方法可以分为三类：

* 实例方法
* 类方法
* 函数式方法

>  调用类方法时，可以使用 `::` 代替 `.`

```ruby
def hello(name)
  puts "Hello, #{name}"
end
```

定义带块的方法：

```ruby
def myLoop
  while true
    yield
  end
end

num = 1
myLoop do 
  puts "num is #{num}"
  break if num > 10
  num *= 2
end
```

带关键字参数的方法：

 ```ruby
def meth(x: 0, y: 0, z: 0, **args)
  [x, y, z, args]
end

p meth(x: 3, y: 4, z: 5, v: 6, w: 7)
#=> [3, 4, 5, {:v=>6, :w=>7}]
 ```

### 「8」类和模块

判断某个对象是否属于某个类时：

```ruby
ary = []
p ary.instance_of?(String)
#=> false
p ary.is_a?(Object)
#=> true
```

创建一个类：

```ruby
class HelloWorld
  def initialize(myname = "Ruby")
    @name = myname
  end
  
  def hello
    puts "Hello, world. I am #{@name}."
  end
end

bob = HelloWorld.new("Bob")
ruby = HelloWorld.new("Alice")
bob.hello
```

Ruby 中的存取器：

```ruby
def name
  @name
end

def name=(value)
    @name = value
end
```

为了方便，我们可以用以下来代替存取方法的实现：

| 定义                | 意义                     |
| :------------------ | :----------------------- |
| attr_reader :name   | 只读（定义 name 方法）   |
| attr_writer :name   | 只写（定义 name= 方法）  |
| attr_accessor :name | 读写（定义以上两个方法） |

```ruby
class HelloWorld
  attr_accessor :name
end
```

类方法：

```ruby
class << HelloWorld
  def hello(name)
    puts "#{name} said hello."
  end
end
# 单例类定义
HelloWorld.hello("John") #=> John said hello.

# 也可以这样写
class HelloWorld
  class << self
    def hello(name)
      puts "#{name} said hello."
    end
  end
end

# 或这样
def HelloWorld.hello(name)
  puts "#{name} said hello."
end

# 或这样
class HelloWorld
  def self.hello(name)
    puts "#{name} said hello."
  end
end
```

类中的常量：

```ruby
class Hello
  Version = "1.0"
end

p Hello::Version  #=> "1.0"
```

类变量：

```ruby
class HelloCount
  @@count = 0
  
  def HelloCount.count
    @@count
  end
  
  def initialize(myname = "Ruby")
    @name = myname
  end
  
  def hello
    @@count += 1
    puts "Hello, world. I am #{@name}."
  end
end

p HelloCount.count           #=> 0
bob = HelloCount.new("Bob")
ruby = HelloCount.new()
bob.hello
ruby.hello
p HelloCount.count           #=> 2
```

 限制方法的调用：

```ruby
public private protected
# private 和 protected 的区别很有意思
# 于书 P45 有解释
```

在原有类的基础上添加方法：

```ruby
class String
  def count_word
    ary = self.split(\/s+/)
    return ary.size
  end
end

str = "Just Ruby"
p str.count_word  #=> 2
```

继承一个类：

```ruby
class RingArray < Array
  def [](i)
    idx = i % size
    super(idx)
  end
end

wday = RingArray["m", "i", "m", "0", "s", "a"]
p wday[6]  #=> "m"
```

> 在 Ruby 中如果你不明确的指定父类，那么将会默认以 Object 作为父类，Object 类提供了许多便于编程的方法。但是如果你还想要更加轻量级的类，你可以直接继承 BasicObject 类。

alias 和 undef 的运用：

```ruby
class C1
  def hello
    "Hello"
  end
end

class C2 < C1
  alias old_hello hello
  def hello
    "#{old_hello}, again"
  end
end

obj = C2.new
p obj.old_hello
p obj.hello.     #=> "Hello, again"
```

通过利用单例类定义，给对象添加单例方法：

```ruby
str1 = "Ruby"
str2 = "Ruby"
class << str1
  def hello
    "Hello, #{self}!"
  end
end
p str1.hello #=> "Hello, Ruby!"
p str2.hello #=> Error(NoMethodError)
```

模块，模块是什么？模块是 Ruby 的特色功能之一（有点类似于协议）。如果说类是表示事物的实体及其行为的话，那么模块的表现就只是事物的行为。模块有以下特点：

* 模块不能拥有实例
* 模块不能被继承

利用 Mix-in 扩展功能：

```ruby
module MyModule
  # methods
end

class MyClass1
  include MyModule
  # methods
end

class MyClass2
  include MyModule
  # methods
end
```

创建模块：

```ruby
module HelloModule
  Version = "1.0"
  
  def hello(name)
    puts "Hello, #{name}."
  end
  
  module_function :hello
end

p HelloModule::Version     #=> "1.0"
HelloModule.hello("Alice") #=> Hello, Alice.

include HelloModule
p Version
hello("Alice")
```

在模块中调用 `self` 要小心：

```ruby
module FooModule
   def foo
     p self
   end
  module_function :foo
end

FooModule.foo #=> FooModule
```

> 如果在被 mix-in 的类中调用含 `self` 的方法，将会返回被 mix-in 的那个对象，导致其在不同上下文的情况下，其含义也会不同。

Mix-in 与继承：

```ruby
module M
  def meth
    "meth"
  end
end

class C
  include M
end

c = C.new
p c.meth #=> meth

p c.ancestors  #=> [C, M, Object, Kernel, BasicObject]
p c.superclass #=> Object
```

> 类 C 的实例在调用方法时，Ruby 会按照其 `ancestors` 的顺序去调用查找该方法，更详尽的查找方法规则在书 p105 页。

利用 extend 将模块 mix-in 进对象：

```ruby
module Edition
  def edition(n)
    "#{self} 第 #{n} 版"
  end
end

str = "Mimosa 的生活"
str.extend(Edition)
p str.edition(25) #=> "Mimosa 的生活第 25 版"
```

利用 extend 定义类方法：

```ruby
module ClassMethods
  def cmethod
    "class method"
  end
end

module Instancemethods
  def imethod
    "instance method"
  end
end

class MyClass
  extend ClassMethods
  include Instancemethods 
end

p MyClass.cmethod     #=> "class method"
p MyClass.new.imethod #=> "instance method"
```

面向对象的特征：

```ruby
# 封装
t = Time.now
p t.year

obj = Object.new
str = "Mimosa"
num = Math::PI

p obj.to_s #=> "#<Object:0x7fa1d6bd1008>"
p str.to_s #=> "Ruby"
p num.to_s #=> "3.141592653589793"
```

鸭子类型：

> 鸭子类型(duck typing)是指：对象的特征并不是由其种类(类及其继承关系)决定的，而是由对象本身具有什么样的行为(拥有什么方法)决定的。如下例子中：`fetch_and_downcase` 方法并不关心传进来的到底是数组还是散列。

```ruby
def fetch_and_downcase(ary, index)
  if str = ary[index]
		return str.downcase
  end
end

ary = ["Boo", "Foo", "Woo"]
hash = {0 => "Boo", 1 => "Foo", 2 => "Woo"}

p fetch_and_downcase(ary, 1)  #=> "foo"
p fetch_and_downcase(hash, 1) #=> "foo"
```

> Ruby 中的变量没有限制类型，所以不会出现不是某个特定的类的对象，就不能给变量赋值的情况。因此，在程序开始运行之前，我们都无法知道变量指定的对象的方法调用是否正确。
>
> 这样的做法有个缺点，就是增加了程序运行前检查错误的难度。但是，从另外一个角度来看，则可以非常简单地使没有明确继承关系的对象之间的处理变得通用。只要能执行相同的操作，我们并不介意执行者是否一样；相反，虽然实际上是不同的执行者，但通过定义相同名称的方法，也可以实现处理通用化。这就是鸭子类型思考问题的方法。

运算符：

> Ruby 中的运算符和别的语言的差的不多，详见书「第 9 章 运算符」。

异常处理的写法：

```ruby
 def foo
   File.open("/no/file")
 end

def bar
  foo()
end

begin
  bar()
rescue => ex
  print ex.message, "\n"
  sleep 10
  retry
ensure
  print "ensure sth"
end
```

rescue 修饰符：

```ruby
n = Integer(val) rescue 0
```

> 更多详尽的异常处理语法请看书「第十章 错误处理与异常」

Ruby 中所有的异常都是 `Exception` 类的子类，并根据程序错误的种类来定义相应的异常，`StandardError` 就是它的一个常用子类。通过以下方式捕捉异常的话，同时就会捕捉 `MyError` 类的子类 `MyError1`、`MyError2`、`MyError3` 等。

```ruby
MyError = Class.new(StandardError)
MyError1 = Class.new(MyError)
MyError2 = Class.new(MyError)
MyError3 = Class.new(MyError)

begin
┊
rescue MyError
┊
end
```

块（block）：

```ruby
sum = 0
outcome = {"参加费"=>1000, "挂件费用"=>1000, "联欢会费用"=>4000}
outcome.each do |item, price|
	sum += price
end
puts "合计: #{sum}"
```

> 更多语言自带的排序方法详见书「第 11 章 块」。

定义带块的方法：

```ruby
def total(from, to)
  result = 0
	from.upto(to) do |num|
  	if block_given?
    	result += yield(num)
  	else
    	result += num
		end
	end
  return result
end

p total(1, 10)                   # 从1 到10 的和 => 55
p total(1, 10){ |num| num ** 2 } # 从1 到10 的2 次幂的和 => 385
```

控制块的执行：

```ruby
n = total(1, 10) do |num|
  if num == 5
		break    # break
  end
	num
end
p n    #=> nil

n = total(1, 10) do |num|
  if num % 2 != 0
		next 0    # next
  end
	num
end
p n    #=> 30
```

将块封装为对象：Ruby 还能把块当作对象处理，把块当作对象处理后，就可以在接收块的方法之外的其他地方执行块，或者把块交给其他方法执行。这种情况下需要用到 `Proc` 对象。`Proc` 对象是能让块作为对象在程序中使用的类。

```ruby
hello = Proc.new do |name|
  puts "Hello, #{name}."
end

hello.call("World") 
hello.call("Ruby")

> ruby proc1.rb
# Hello, World.
# Hello, Ruby.
```











