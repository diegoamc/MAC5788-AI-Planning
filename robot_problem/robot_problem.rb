require_relative 'requirements'

#parse the PDDL input
domain_pddl = SExpr.new File.read("domain.pddl")
problem_pddl = SExpr.new File.read("problem.pddl")

problem = Problem.new problem_pddl.data.drop 1
domain = Domain.new domain_pddl.data.drop 1

domain.ground_all_actions(problem)

node_solution = Search.a_star_tree_search(domain.grounded_actions, problem, domain, "heuristic0")

p node_solution.state
if node_solution == "Failure"
  puts ":("
else
  Search.path_to(node_solution)
end
