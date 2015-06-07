# abstraction for the actions
class Action
  attr_accessor :name, :initial_state, :destinations, :cost, :q_value

  def initialize(name, initial_state, final_state, probability)
    @name = name
    @initial_state = initial_state
    @destinations = [[probability, final_state]]
    @q_value = 0.0
  end
end
