# parser file
class Parser
  def parse(problem_instance)
    @problem = ProblemDefinition.new
    @file = File.open(problem_instance)

    @marker = ""
    while !@file.eof?
      @current_line = @file.readline
      if @current_line.start_with?("discount")
        @problem.discount_factor = @current_line.strip.split(" ").last.to_f
      elsif not @current_line.start_with?("\r")
        if not @current_line.start_with?("\t") and
          @marker = @marker.empty? ? @current_line.strip : ""
        elsif
          suffix = @marker.split(" ").first
          send("new_#{suffix}")
        end
      end
    end
    return @problem
  end

  def new_states
    states = @current_line.strip.split(", ")
    states.each { |state_name| @problem.add_state(state_name) }
  end

  def new_action
    action_name = @marker.split(" ").last
    initial_state, final_state, probability = @current_line.strip.split(" ")
    @problem.add_action(action_name, initial_state, final_state, probability.to_f)
  end

  def new_reward
    state_name, reward = @current_line.strip.split(" ")
    @problem.add_reward(state_name, reward.to_f)
  end

  def new_cost
    action_name, cost = @current_line.strip.split(" ")
    @problem.add_cost(action_name, cost.to_f)
  end

  def new_initialstate
    state_name = @current_line.strip
    @problem.states[state_name].initial_state = true
    @problem.initial_state = state_name
  end

  def new_goalstate
    state_name = @current_line.strip
    @problem.states[state_name].goal_state = true
    @problem.goal_state = state_name
  end
end
