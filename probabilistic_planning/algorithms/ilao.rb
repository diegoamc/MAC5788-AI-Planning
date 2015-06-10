# LAO algorithm
class ILAO
  include Procedures
  attr_accessor :v
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

  def residual(state)
    q_values = @v[state.name]
    residual = 1
    if q_values.size > 1
      residual = (q_values[q_values.size - 2] - q_values.last).abs
    end
    return residual
  end
end
