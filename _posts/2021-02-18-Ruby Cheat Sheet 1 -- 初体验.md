---
title: Ruby Cheat Sheet 1 -- 初体验
tags: ["Ruby", "笔记"]
key: blog-2021-02-18
---

Ruby 语言有很多特点和标签：面向对象、脚本语言、跨平台、开源，最吸引我的是 Ruby 认为其自身是一种旨在使大家编程时能乐在其中的编程语言，正是所谓的「快乐编程」。因为兴趣原因接触了一下 Ruby 这门语言，但由于目前我来说并不会经常使用 Ruby，所以在这边做一个 Cheat Sheet 的存档，方便之后随时查阅。

> 以下内容应多源于《Ruby 基础教程》一书，算是该书的读书笔记。书是二手买来的，但是新的很，发现果然还是纸质书有质感一些吧🤔。

<!--more-->



## Ruby 初体验

### 「1」Ruby 初探

可以使用两种方法来执行 Ruby 命令：

```ruby
# 执行 Ruby 文件
> ruby helloruby.rb

# 使用 irb（更适合简单的小测试）
> irb
```

`\` 是转译符，程序会对字符串中 `\` 后面的字符做特殊处理，在 `''` 中则不会转译：

 ```ruby
print("Hello,\nRuby\n!\n")
# Hello,
# Ruby
# !
#  => nil

print("Hello \\ Ruby!")
# Hello \ Ruby! => nil

print('Hello,\nRuby\n!\n')
# Hello,\nRuby\n!\n => nil
 ```

> 在 `''` 中想嵌入 `\` 或 `''` 的话是例外，仍需要在之前加上 `\`。

Ruby 中有许多输出的方法：

```ruby
print "100"  #=> 100
put 	"100"  #=> 100\n
p 		"100"  #=> "100"
```

> 在使用 `p` 方法时，不会转译字符串中的内容。原则上 `p` 方法是给编程者使用的。
>
> 另还有 `pp` 方法，如其名 `pretty print`，可以将带嵌套的信息更易懂地打印出来。

如何打印一个变量：

```ruby
print "表面积 = ", area, "\n"
# or
puts "表面积 = #{area}"
```

Ruby 中的注释和多行注释：

```ruby
=begin
多行注释
2021年02月18日创建
=end
# 单行注释
```

简单的条件与循环语句：

```ruby
# if
a = 20
if a >= 10 then  # then 可以省略
  print "greater\n"
else
  print "smaller\n"
end

# while
i = 1
while 1 <= 10 do  # do 可以省略
  puts i
  i = i + 1
end
  
# times
100.times do
  puts "Hello, Ruby!"
end
```

### 「2」便利的对象

数组的简单使用：

```ruby
name = ["M", "i", "m", "0", "s", "a"]
name[1]  #=> "i"
name[3] = "o"
name[7] = "?"
puts name
# ["M", "i", "m", "o", "s", "a", nil, "?"]
name.each do |char|
  puts char
end
```

符号 `symbol` 是什么：

> 符号 `symbol` 与字符串很像，一般作为名称标签使用，比如作为散列的键，可以将符号简单理解为轻量级的字符串，其与字符串之间也可以相互转换。

散列的简单使用：

```ruby
person = {name: "Mim0sa", nickName: "Mimoku"}
person = {:name=>"Mim0sa", :nickName=>"Mimoku"}
person[:nickName] = "Mim0ku"
person.each do |key, value|
  puts "#{key}: #{value}"
end
```

模式匹配的简单使用：

```ruby
/Ruby/  # is a pattern
/Ruby/ =~ "Hi Ruby"  #=> 3
/Ruby/ =~ "Diamond"  #=> nil
/Ruby/ =~ "HI RUBY"  #=> nil
/Ruby/i =~ "HIRUBY"  #=> 2
```

### 「3」创建命令

怎么输入数据：

```ruby
puts "第1个参数: #{ARGV[0]}"
puts "第2个参数: #{ARGV[1]}"
puts "第3个参数: #{ARGV[2]}"
> ruby RubyDemo.rb 1 2 3
# 第1个参数: x
# 第2个参数: y
# 第3个参数: z
```

怎么读取文件:

```ruby
filename = ARGV[0]
file = File.open(filename)
text = file.read
print text
file.close
# or
print File.read(ARGV[0])
```

使用模式匹配逐行匹配内容并输出：

```ruby
pattern = Regexp.new(ARGV[0])
filename = ARGV[1]

file = File.open(filename)
file.each_line do |line|
  if pattern =~ line
    print line
  end
end
file.close
```

定义一个方法以及从其他文件引用：

```ruby
# hello.rb
def hello
  puts "Hello, Ruby!"
end

# use_hello.rb
require_relative "hello"

hello()
```



