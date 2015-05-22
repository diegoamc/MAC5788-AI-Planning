require_relative 'requirements'

domain_name = ARGV[0] # domain.pddl | blocksWorldDomain.pddl | satelliteDomain.pddl
problem_test = ARGV[1]
heuristic = ARGV[2] # graphPlanHeuristic | heuristic0 | heuristic1
ground = ARGV[3] # all

# run examples:
# ruby robot_problem.rb robotDomain.pddl problem2Box2Room.pddl graphPlanHeuristic all
# ruby robot_problem.rb robotDomain.pddl problem6Box2Room.pddl heuristic0 all
# ruby robot_problem.rb blocksWorldDomain.pddl probBLOCKS-4-0.pddl graphPlanHeuristic all
# ruby robot_problem.rb blocksWorldDomain.pddl probBLOCKS-4-0.pddl heuristic0 all

# parse the PDDL input
domain_pddl = SExpr.new File.read(domain_name)
problem_pddl = SExpr.new File.read("problems/#{domain_name.gsub(".pddl", "")}/" << problem_test)

problem = Problem.new problem_pddl.data.drop 1
domain = Domain.new domain_pddl.data.drop 1

#TODO:
# 1 - selecionar cada dominio e: para cada problema, testar com cada configuração
# 2 - Outputar num arquivo para cada dominio, separando com pontos e virgulas especificando os nomes do dominio
#   e do problema, as heurísticas usadas e tudo.
# 3 - Se der timeout (30 min.), ele tem que mostrar simplesmente um -1
# 4 - Criar os graficos
#30 min = 1800 seg.

time_selected = 1800
begin
  Timeout.timeout(time_selected) do
    start_time = Time.now
    node_solution = Search.a_star_tree_search(domain.grounded_actions, problem, domain, heuristic, ground)
    end_time = (Time.now - start_time) * 1000
    time = ("Time: %.2f" % end_time + "ms")

    if node_solution == "Failure"
      result = ":("
    else
      result = Search.path_to(node_solution)
    end
  end
rescue
  puts "Demorou muito tempo, teste nao conseguido."
end

out_file = File.new("results/#{domain_name.gsub(".pddl", "")}/#{problem_test.gsub(".pddl", "")}_#{heuristic}_#{ground}.txt", "w")
out_file.puts("#{time}\n#{result}")
out_file.close
