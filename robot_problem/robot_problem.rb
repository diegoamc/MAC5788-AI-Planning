require_relative 'requirements'

problem = ARGV[0]
ground = ARGV[1]

#parse the PDDL input
domain_pddl = SExpr.new File.read("domain.pddl")
problem_pddl = SExpr.new File.read("problems/" << problem)

problem = Problem.new problem_pddl.data.drop 1
domain = Domain.new domain_pddl.data.drop 1

start_time = Time.now
node_solution = Search.a_star_tree_search(domain.grounded_actions, problem, domain, "heuristic0", ground)
end_time = (Time.now - start_time) * 1000
puts ("%.2f" % end_time + "ms")


# p node_solution.state
if node_solution == "Failure"
  puts ":("
else
  Search.path_to(node_solution)
end
