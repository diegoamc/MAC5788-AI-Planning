# main file
require_relative 'requirements'

domain_name = ARGV[0] # tireworld | navigation_problem
problems_directory = "problems/#{domain_name}"

Dir.foreach(problems_directory) do |problem_instance|
  next if problem_instance == '.' or problem_instance == '..'

  problem = Parser.new.parse("#{problems_directory}/#{problem_instance}")

  puts problem.initial_state
  puts problem.goal_state
  puts problem.discount_factor
  problem.states.each do |state_name, state|
    puts "=========" + state_name + "========="
    puts "\t" + state.name
    puts "\t" + state.reward
    state.actions.each do |action_name, action|
      puts "++++++++" + action_name + "++++++++"
      puts "\t\t" + action.name
      puts "\t\t" + action.initial_state
      puts "\t\t" + action.cost
      puts "\t\t #{action.destinations}"
    end
  end
end
