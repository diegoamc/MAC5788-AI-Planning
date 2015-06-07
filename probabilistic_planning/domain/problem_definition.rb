# abstraction for the problem definition
class ProblemDefinition
  attr_accessor :discount_factor, :states, :initial_state, :goal_state

  def initialize
    @states = {}
  end

  def add_state(state_name)
    @states[state_name] = State.new(state_name)
  end

  def add_action(action_name, initial_state, final_state, probability)
    action = Action.new(action_name, initial_state, final_state, probability)
    if not @states[initial_state].actions.has_key?(action_name)
      @states[initial_state].actions[action_name] = action
    else
      @states[initial_state].actions[action_name].destinations << [probability, final_state]
    end
  end

  def add_reward(state_name, reward)
    @states[state_name].reward = reward
  end

  def add_cost(action_name, cost)
    @states.each_value do |state|
      state.actions[action_name].cost = cost if not state.actions[action_name].nil?
    end
  end

  def order_action_destinations_by_probability
    @states.each_value do |state|
      state.actions.each_value do |action|
        action.destinations.sort!
      end
    end
  end
end
