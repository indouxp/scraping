# -*- encoding: UTF-8 -*-
###############################################################################
# ログ
#
#
###############################################################################
class Logging
  attr_reader :logbasename, :logpath
  attr_accessor :logname

  def initialize(logname=nil)
    @logbasename = File.basename($0)
    @logdirname = File.dirname($0)
    @logname = @logdirname + "/" + @logbasename + ".log"
    @keep_open = false
    @fp = nil
  end

  def puts(msg, open=nil)
    msg = Time.now.strftime('%Y/%m/%d.%H:%M:%S') + ":" + msg
    unless @keep_open
      @fp = open(@logname, "a")
    end
    @fp.puts msg
    unless open == nil
      @keep_open = open
    end
    unless @keep_open
      @fp.close
    end
  end

  def close
    @fp.close if @keep_open
  end
end

if __FILE__ == $0
  logging = Logging.new

  logging.puts("開始", true)
  logging.puts("終了") 
  logging.close

  logging = nil

  logging = Logging.new

  logging.puts("START")
  logging.puts("END") 
  logging.close

  logging = nil

  logging = Logging.new

  logging.puts("START")
  logging.puts("開始", true)
  logging.puts("終了", false)
  logging.puts("END") 
  logging.close

  logging = nil

  logging = Logging.new
  logging.logname = "./log.open.txt"

  logging.puts("開始", true)
  1000.times do |n|
    logging.puts(n.to_s)
  end
  logging.puts("終了",)
  logging.close

  logging = nil

  logging = Logging.new
  logging.logname = "./log.notopen.txt"

  logging.puts("開始", false)
  1000.times do |n|
    logging.puts(n.to_s)
  end
  logging.puts("終了",)
  logging.close

  logging = nil
end
