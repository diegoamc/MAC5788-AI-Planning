require_relative 'requirements'

problem_test = ARGV[0]
ground = ARGV[1]

#parse the PDDL input
domain_pddl = SExpr.new File.read("domain.pddl")
problem_pddl = SExpr.new File.read("problems/" << problem_test)

problem = Problem.new problem_pddl.data.drop 1
domain = Domain.new domain_pddl.data.drop 1

start_time = Time.now
node_solution = Search.a_star_tree_search(domain.grounded_actions, problem, domain, "graphPlanHeuristic", ground)

#node_solution = Search.a_star_tree_search(domain.grounded_actions, problem, domain, "heuristic2", ground)

end_time = (Time.now - start_time) * 1000
time = ("Time: %.2f" % end_time + "ms")

if node_solution == "Failure"
  result = ":("
else
  result = Search.path_to(node_solution)
end

out_file = File.new("results/result_#{problem_test.gsub(".pddl", "")}_#{ground}.txt", "w")
out_file.puts("#{time}\n#{result}")
out_file.close
