# main file
require_relative 'requirements'

domain_name = ARGV[0] # tireworld | navigation_problem
algorithm = ARGV[1] # ILAO | LRTDP | RTDP | VI
problems_directory = "problems/#{domain_name}"

global_results = File.new("results/#{domain_name}/global_#{algorithm}.csv", "w")
global_results.puts "#{domain_name}_#{algorithm}"
global_results.puts "Problem;Elapsed time;Number of trials;Total number of states;Visited states"
Dir.foreach(problems_directory) do |problem_instance|
  next if problem_instance == '.' or problem_instance == '..'

  problem = Parser.new.parse("#{problems_directory}/#{problem_instance}")
  problem.order_action_destinations_by_probability

  puts "---------- Starting #{algorithm} for #{problem_instance} ----------"
  global_results.print "#{problem_instance.gsub(".txt", "")}"
  algorithm_instance = Kernel.const_get(algorithm).new(problem)
  begin
    start_time = Time.now
    algorithm_instance.run
  rescue
  ensure
    end_time = Time.now
    output_file = File.new("results/#{domain_name}/#{problem_instance.gsub(".txt", "")}_#{algorithm}.txt", "w")
    output_file.puts "Elapsed time: #{(end_time - start_time)}"
    global_results.print ";#{(end_time - start_time)}"

    output_file.puts "Number of trials: #{algorithm_instance.trials}"
    global_results.print ";#{algorithm_instance.trials}"

    output_file.puts "Total number of states: #{problem.states.size}"
    global_results.print ";#{problem.states.size}"
    visited_states = 0
    problem.states.each_value {|state| visited_states += 1 if state.visited?}

    output_file.puts "Visited states: #{visited_states}"
    global_results.print ";#{visited_states}"
    output_file.puts "Policy:"
    problem.states.each_value do |state|
      greedy_action = state.greedy_action.nil? ? "" : state.greedy_action.name
      q_value = algorithm_instance.v[state.name].is_a?(Array) ? algorithm_instance.v[state.name].last : algorithm_instance.v[state.name]
      output_file.puts "\tAction(#{state.name}): #{greedy_action} ; V(#{state.name}): #{q_value}"
      #global_results.print ";#{q_value}"
    end
    global_results.puts ""
    output_file.close
  end
end
global_results.close
