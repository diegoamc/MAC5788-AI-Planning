require_relative 'requirements'

#parse the PDDL input
domain_pddl = SExpr.new File.read("domain.pddl")
problem_pddl = SExpr.new File.read("problem.pddl")

#puts "---------------------- Domain ----------------------"
#puts "original pddl domain:\n#{domain_pddl.original}"
#puts "\nruby data structure:\n#{domain_pddl.data}"
#puts "\nand back to S-Expr:\n#{domain_pddl.to_sexpr}"

#puts "\n---------------------- Problem ----------------------"
#puts "original pddl problem:\n#{problem_pddl.original}"
#puts "\nruby data structure:\n#{problem_pddl.data}"
#puts "\nand back to S-Expr:\n#{problem_pddl.to_sexpr}"

problem = Problem.new problem_pddl.data.drop 1
domain = Domain.new domain_pddl.data.drop 1
# puts ""
# puts "=============== Domain Definition ==============="
# puts "domain name: #{domain.name}"
# puts "domain requirements: #{domain.requirements}"
# puts "domain types: #{domain.types}"
# puts "domain constants: #{domain.constants}"
# puts "domain predicates: #{domain.predicates}"
# puts ""
#
# puts "=============== Actions ==============="
# puts "Actions: #{domain.action}"
#
# puts ""
# puts "=============== Problem Definition ==============="
# puts "problem name: #{problem.name}"
# puts "problem domain: #{problem.domain_name}"
# puts "problem objects: #{problem.objects}"
# puts "problem initial state: #{problem.initial_state}"
# puts "problem goal: #{problem.goal}"

puts ""
puts ""


state = problem.initial_state
no = Node.new({:"state" => state})
puts "Node:  #{no.state}"
puts "problem goal: #{problem.goal}"

#problem.goalTest(no)
