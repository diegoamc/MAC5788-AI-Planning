class VI
  include Procedures
  attr_reader :v, :trials
  @@epsilon = 0.0000001

  def initialize(problem)
    @problem = problem
    @v = Hash.new(0.0) # its keys are the problem's state names, with default values equal to 0.0
    @trials = 0
  end

  def run
    loop do
      @problem.states.each_value do |state|
        state.visited = true
        update_v(state)
      end
      @trials += 1
      break if converged?
    end
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
end
