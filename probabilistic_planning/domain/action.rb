# abstraction for the actions
class Action
  attr_accessor :name, :initial_state, :destinations, :cost

  def initialize(name, initial_state, final_state, probability)
    @name = name
    @initial_state = initial_state
    @destinations = [[final_state, probability]]
  end
end
