module Procedures
  def greedy_action(state)
    state.actions.each_value do |action|
      action.q_value = q_value(action)
    end

    selected_action = state.actions.to_a.max { |action1, action2| action1.last.q_value <=> action2.last.q_value }
    return selected_action.last
  end

  def q_value(action)
    sum = 0.0
    action.destinations.each do |probability, final_state|
      value = @v[final_state].is_a?(Array) ? @v[final_state].last : @v[final_state]
      sum += (probability * value)
    end

    @problem.states[action.initial_state].reward - action.cost + @problem.discount_factor * sum
  end

  def update_v(state)
    action = greedy_action(state)
    state.greedy_action = action
    if @v[state.name].is_a?(Array)
      @v[state.name] << action.q_value
    else
      @v[state.name] = action.q_value
    end
  end

  def pick_next_state(action)
    random_number = Random.new(Random.new_seed).rand
    action.destinations.each do |probability, final_state|
      return @problem.states[final_state] if random_number <= probability
    end

    @problem.states[action.destinations.last.last] #returns the last final state
  end

  def residual(state)
    @v[state.name] - greedy_action(state).q_value
  end
end
