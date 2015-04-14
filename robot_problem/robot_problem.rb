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
