# -*- coding:utf-8 -*-

def output(line, stack_level)
  printf "%s%s\n", " " * stack_level, line
end

stack_level = 0
while line = ARGF.gets
  line = line.chomp
  if /^<\// =~ line
    stack_level -= 1
    output(line, stack_level)
  elsif /^</ =~ line
    case
    when /<link/ =~ line  ||
          /<meta/ =~ line ||
          /<img/ =~ line  ||
          /<input/ =~ line||
          /<br/ =~ line
      output(line, stack_level)
    else
      output(line, stack_level)
      stack_level += 1
    end
  else
    output(line, stack_level)
  end
end
