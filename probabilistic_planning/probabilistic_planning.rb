# main file
require_relative 'requirements'

domain_name = ARGV[0] # tireworld | navigation_problem
problems_directory = "problems/#{domain_name}"

Dir.foreach(problems_directory) do |problem_instance|
  next if problem_instance == '.' or problem_instance == '..'

  problem = Parser.new.parse("#{problems_directory}/#{problem_instance}")
  problem.order_action_destinations_by_probability

  lrtdp = LRTDP.new(problem)
  start_time = Time.now
  lrtdp.run
  end_time = Time.now

  p (end_time - start_time)
end
