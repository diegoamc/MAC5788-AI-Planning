# LRTDP algorithm
class RTDP
  include Procedures
  attr_accessor :v

  def initialize(problem)
    @problem = problem
    @v = Hash.new(0.0) # its keys are the problem's state names, with default values equal to 0.0
  end

  def run
    initial_state = @problem.states[@problem.initial_state]
    Timeout.timeout(60) do
      loop do
        rtdp_trial(initial_state)
      end
    end
  end

  def rtdp_trial(state)
    loop do
      break if state.is_goal_state?

      #pick the best action and update hash
      action = greedy_action(state)
      update_v(state)

      #stochastically simulate next state
      state = pick_next_state(action)
    end
  end
end
