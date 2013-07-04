require 'pp'

class Object
  def tap_pp
    pp self
    self
  end
end

module Enumerable
  def each_pp
    self.each{|e| pp e }
  end
end

module PrintOutExceptions
  def self.included(controller)
    controller.around_filter :__print_out_exceptions
  end

  def __print_out_exceptions
    begin
      yield
    rescue
      puts %{= EXCEPTION ======================================}
      puts %{*** #{$!.inspect}}
      $!.backtrace.each{|line| puts line }
      puts %{^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}
      raise
    end
  end
end