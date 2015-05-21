require_relative 'requirements'

problem_test = ARGV[0]
ground = ARGV[1]

#parse the PDDL input
#domain_pddl = SExpr.new File.read("domain.pddl")
domain_pddl = SExpr.new File.read("satelliteDomain.pddl")
#domain_pddl = SExpr.new File.read("blocksWorldDomain.pddl")
#problem_pddl = SExpr.new File.read("problems/" << problem_test)
problem_pddl = SExpr.new File.read("problems/Satellites/" << problem_test)
#problem_pddl = SExpr.new File.read("problems/BlocksWorld/" << problem_test)

problem = Problem.new problem_pddl.data.drop 1
domain = Domain.new domain_pddl.data.drop 1

start_time = Time.now
node_solution = Search.a_star_tree_search(domain.grounded_actions, problem, domain, h_type, ground)
end_time = (Time.now - start_time) * 1000
time = ("Time: %.2f" % end_time + "ms")

if node_solution == "Failure"
  result = ":("
else
  result = Search.path_to(node_solution)
end

#out_file = File.new("results/Blocks/result_NoOp_#{problem_test.gsub(".pddl", "")}_#{ground}.txt", "w")
#out_file = File.new("results/HeuristicFF/result_NoOp_#{problem_test.gsub(".pddl", "")}_#{ground}.txt", "w")
out_file = File.new("results/Satellites/result_NoOp_#{problem_test.gsub(".pddl", "")}_#{ground}.txt", "w")
out_file.puts("#{time}\n#{result}")
out_file.close
