# LRTDP algorithm
class LRTDP
  @@epsilon = 0.0000001

  def initialize(problem)
    @problem = problem
    @v = Hash.new(0.0) # its keys are the problem's state names, with default values equal to 0.0
  end

  def run
    initial_state = @problem.states[@problem.initial_state]
    while (not initial_state.solved?)
      lrtdp_trial(initial_state)
    end
  end

  def lrtdp_trial(state)
    visited = []
    while (not state.solved?) && (visited.size < 50)
      visited.push(state) #insert into visited

      break if state.is_goal_state? #check termination at goal states

      #pick the best action and update hash
      action = greedy_action(state)
      update_v(state)

      #stochastically simulate next state
      state = pick_next_state(action)
    end

    #try labelling visited states in reverse order
    while (not visited.empty?)
      state = visited.pop
      break if not check_solved(state)
    end

  end

  def greedy_action(state)
    state.actions.each_value do |action|
      action.q_value = q_value(action)
    end

    selected_action = state.actions.to_a.min { |action1, action2| action1.last.q_value <=> action2.last.q_value }
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

  def check_solved(state)
    rv = true
    open_states = []
    closed_states = []

    open_states.push(state) if not state.solved?

    while (not open_states.empty?)
      state = open_states.pop
      closed_states.push(state)

      #check residual
      if residual(state) > @@epsilon
        rv = false
        next
      end

      #expand state
      action = greedy_action(state)
      action.destinations.each do |probability, final_state|
        new_state = @problem.states[final_state]
        if (not new_state.solved?) && (not open_states.include?(new_state)) && (not closed_states.include?(new_state))
          open_states.push(new_state)
        end
      end
    end

    if rv
      #label relevant states
      closed_states.each do |closed_state|
        closed_state.solved = true
      end
    else
      #update states with residuals and ancestors
      while (not closed_states.empty?)
        closed_state = closed_states.pop
        update_v(closed_state)
      end
    end
    return rv
  end

  def residual(state)
    @v[state.name] - greedy_action(state).q_value
  end
end
