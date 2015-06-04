# abstraction for the state
class State
  attr_accessor :name, :actions, :reward

  def initialize(name)
    @name = name
    @actions = {}
  end
end
