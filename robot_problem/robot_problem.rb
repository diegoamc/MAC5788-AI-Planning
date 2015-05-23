require_relative 'requirements'

domain_name = ARGV[0] # domain.pddl | blocksWorldDomain.pddl | satelliteDomain.pddl
#problem_test = ARGV[1]
#heuristic = ARGV[2] # graphPlanHeuristic | heuristic0 | heuristic1
heuristic = ["heuristic0", "graphPlanHeuristic", "graphPlanHeuristicOpt", "hspAddHeuristic", "hspMaxHeuristic"]
ground = ARGV[1] # all
w = ARGV[2].nil? ? 1 : ARGV[2].to_i # WA* parameter. Default is 1

# run examples:
# ruby robot_problem.rb robotDomain.pddl problem2Box2Room.pddl graphPlanHeuristic all
# ruby robot_problem.rb robotDomain.pddl problem6Box2Room.pddl heuristic0 all
# ruby robot_problem.rb blocksWorldDomain.pddl probBLOCKS-4-0.pddl graphPlanHeuristic all
# ruby robot_problem.rb blocksWorldDomain.pddl probBLOCKS-4-0.pddl heuristic0 all

# ruby robot_problem.rb robotDomain.pddl all

# parse the PDDL input
domain_pddl = SExpr.new File.read(domain_name)
global_file = File.new("results/Global_Result#{domain_name.gsub(".pddl", "")}.txt", "w")

#TODO:
# 1 - selecionar cada dominio e: para cada problema, testar com cada configuração
# 2 - Outputar num arquivo para cada dominio, separando com pontos e virgulas especificando os nomes do dominio
#   e do problema, as heurísticas usadas e tudo.
# 3 - Se der timeout (30 min.), ele tem que mostrar simplesmente um -1
# 4 - Criar os graficos

#30 min = 1800 seg.
time_selected = 1800
dir_string = "problems/#{domain_name.gsub(".pddl", "")}/"
Dir.foreach(dir_string) do |item|
  next if item == '.' or item == '..'
  p "Instance #{item} ================================"
  string_problem_instance = "problems/#{domain_name.gsub(".pddl", "")}/" << item

  problem_pddl = SExpr.new File.read(string_problem_instance)
  problem = Problem.new problem_pddl.data.drop 1
  domain = Domain.new domain_pddl.data.drop 1

  heuristic.each do |heuristic_used|
    p heuristic_used
    begin
      Timeout.timeout(1800) do
        problem = Problem.new problem_pddl.data.drop 1
        domain = Domain.new domain_pddl.data.drop 1

        start_time = Time.now
        node_solution = Search.a_star_tree_search(domain.grounded_actions, problem, domain, heuristic_used, w, "all")
        end_time = (Time.now - start_time) * 1000
        time = ("Time: %.2f" % end_time + "ms")

        if node_solution == "Failure"
          p "Failure! :("
          result = ":("
          out_string = "Domain:#{domain_name.gsub(".pddl", "")};Problem:#{item.gsub(".pddl", "")};#{heuristic_used};Time: -1;Path cost: -1;Visited nodes: -1;Generated nodes: -1;Factor: -1;"
        else
          result = Search.path_to(node_solution)
          out_string = "Domain:#{domain_name.gsub(".pddl", "")};Problem:#{item.gsub(".pddl", "")};#{heuristic_used};Time:#{end_time};Path cost: #{node_solution.path_cost};Visited nodes: #{Search.all_nodes.size};Generated nodes: #{Search.number_nodes};Factor: %.3f ;" % (Search.number_nodes.to_f/Search.all_nodes.size)
          global_file.puts(out_string)
        end

        out_file = File.new("results/#{domain_name.gsub(".pddl", "")}/#{item.gsub(".pddl", "")}_#{heuristic_used}_#{ground}.txt", "w")
        out_file.puts("#{time}\n#{result}")
        out_file.close
      end
    rescue Exception => e
      p e
      out_string = "Domain:#{domain_name.gsub(".pddl", "")};Problem:#{item.gsub(".pddl", "")};#{heuristic_used};Time: -1;Path cost: -1;Visited nodes: -1;Generated nodes: -1;Factor: -1;"
      global_file.puts(out_string)
      puts "Demorou muito tempo, teste nao conseguido."
    end

  end
end
global_file.close
