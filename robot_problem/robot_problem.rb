require_relative 'requirements'

#parse the PDDL input
domain_pddl = SExpr.new File.read("domain.pddl")
problem_pddl = SExpr.new File.read("problem.pddl")

puts "---------------------- Domain ----------------------"
puts "original pddl domain:\n#{domain_pddl.original}"
puts "\nruby data structure:\n#{domain_pddl.data}"
puts "\nand back to S-Expr:\n#{domain_pddl.to_sexpr}"

puts "\n---------------------- Problem ----------------------"
puts "original pddl problem:\n#{problem_pddl.original}"
puts "\nruby data structure:\n#{problem_pddl.data}"
puts "\nand back to S-Expr:\n#{problem_pddl.to_sexpr}"

problem = Problem.new problem_pddl.data.drop 1

puts "=============== Problem Definition ==============="
puts "problem name: #{problem.name}"
puts "problem domain: #{problem.domain_name}"
puts "problem objects: #{problem.objects}"
puts "problem initial state: #{problem.initial_state}"
puts "problem goal: #{problem.goal}"
