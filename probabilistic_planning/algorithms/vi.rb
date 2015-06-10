class VI
  @@epsilon = 0.0000001

  def initialize(problem)
    @problem = problem
    @v = Hash.new(0.0) # its keys are the problem's state names, with default values equal to 0.0
  end

  def run
    loop do
      @problem.states.each_value do |state|
        update_v(state)
      end
      break if converged?
    end
  end

  def update_v(state)
    action = greedy_action(state)
    state.greedy_action = action
    @v[state.name] = action.q_value
  end

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
      sum += (probability * @v[final_state])
    end

    @problem.states[@problem.initial_state].reward + action.cost + @problem.discount_factor * sum
  end

  def converged?
    converged = true
    @problem.states.each_value do |state|
      unless state.is_goal_state?
        if residual(state) > @@epsilon
          converged = false
          break
        end
      end
    end

    return converged
  end

  def residual(state)
    @v[state.name] - greedy_action(state).q_value
  end
end
