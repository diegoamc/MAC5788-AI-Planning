# main file
require_relative 'requirements'

domain_name = ARGV[0] # tireworld | navigation_problem
algorithm = ARGV[1] # ILAO | LRTDP | RTDP | VI
problems_directory = "problems/#{domain_name}"

Dir.foreach(problems_directory) do |problem_instance|
  next if problem_instance == '.' or problem_instance == '..'

  problem = Parser.new.parse("#{problems_directory}/#{problem_instance}")
  problem.order_action_destinations_by_probability

  algorithm_instance = Kernel.const_get(algorithm).new(problem)
  begin
    start_time = Time.now
    algorithm_instance.run
  rescue
  ensure
    end_time = Time.now
    p "====================================="
    problem.states.each_value do |state|
      greedy_action = state.greedy_action.nil? ? "" : state.greedy_action.name
      q_value = algorithm_instance.v[state.name].is_a?(Array) ? algorithm_instance.v[state.name].last : algorithm_instance.v[state.name]
      puts "Action(#{state.name}): #{greedy_action} ; V(#{state.name}): #{q_value}"
    end
    p (end_time - start_time)
    p "Number of trials: #{algorithm_instance.trials}"
  end
end
