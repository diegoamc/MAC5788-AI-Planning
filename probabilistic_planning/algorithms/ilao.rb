# LAO algorithm
class ILAO
  @@epsilon = 0.0000001

  def initialize(problem)
    @problem = problem
    @v = Hash.new([0.0]) # its keys are the problem's state names, with default values equal to [0.0]
    @z = []
  end

  def run
    initial_state = @problem.states[@problem.initial_state]
    loop do
      lao_trial(initial_state)
      break if converged?
    end
  end

  def lao_trial(state)
    if (not state.is_goal_state?) && (not state.visited?)
      state.visited = true

      @z.push(state) unless @z.include?(state)

      action = greedy_action(state)
      action.destinations.each do |probability, final_state|
        lao_trial(@problem.states[final_state])
      end
    end
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
      sum += (probability * @v[final_state].last)
    end

    @problem.states[@problem.initial_state].reward + action.cost + @problem.discount_factor * sum
  end

  def converged?
    converged = false
    while (not @z.empty?)
      state = @z.pop
      unless state.is_goal_state?
        state.visited = false
        update_v(state)
        converged = true if residual(state) <= @@epsilon
      end
    end

    return converged
  end

  def update_v(state)
    action = greedy_action(state)
    state.greedy_action = action
    @v[state.name] << action.q_value
  end

  def residual(state)
    q_values = @v[state.name]
    residual = 1
    if q_values.size > 1
      residual = (q_values[q_values.size - 2] - q_values.last).abs
    end
    return residual
  end
end
