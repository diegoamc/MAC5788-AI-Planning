# LRTDP algorithm
class RTDP
  @@epsilon = 0.0000001

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

  def update_v(state)
    action = greedy_action(state)
    state.greedy_action = action
    @v[state.name] = action.q_value
  end

  def pick_next_state(action)
    random_number = Random.new(Random.new_seed).rand
    action.destinations.each do |probability, final_state|
      return @problem.states[final_state] if random_number <= probability
    end

    @problem.states[action.destinations.last.last] #returns the last final state
  end
end
