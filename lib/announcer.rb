class Announcer
  def initialize
    @listeners = []
  end

  def add_listener listener
    @listeners << listener
  end

  def remove_listener listener
    @listeners.delete listener
  end

  def method_missing name, *args
    @listeners.each {|l| l.send name, *args }
  end
end
