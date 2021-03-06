# LRTDP algorithm
class LRTDP
  include Procedures
  attr_reader :v, :trials

  @@epsilon = 0.0000001

  def initialize(problem)
    @problem = problem
    @v = Hash.new(0.0) # its keys are the problem's state names, with default values equal to 0.0
    @trials = 0
  end

  def run
    initial_state = @problem.states[@problem.initial_state]
    loop do
      break if initial_state.solved?
      lrtdp_trial(initial_state)
      @trials += 1
    end
  end

  def lrtdp_trial(state)
    visited = []
    loop do
      break if state.solved? || visited.size >= 30
      state.visited = true
      visited.push(state) #insert into visited

      break if state.is_goal_state? #check termination at goal states

      #pick the best action and update hash
      action = greedy_action(state)
      update_v(state)

      #stochastically simulate next state
      state = pick_next_state(action)
    end

    #try labelling visited states in reverse order
    loop do
      break if visited.empty?
      state = visited.pop
      break if not check_solved(state)
    end

  end

  def check_solved(state)
    rv = true
    open_states = []
    closed_states = []

    open_states.push(state) if not state.solved?

    loop do
      break if open_states.empty?
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
      loop do
        break if closed_states.empty?
        closed_state = closed_states.pop
        update_v(closed_state)
      end
    end
    return rv
  end
end
