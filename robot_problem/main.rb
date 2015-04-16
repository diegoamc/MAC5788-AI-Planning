require_relative 'requirements'

sexpr = SExpr.new File.read("problem.pddl")

#puts "original sexpr:\n#{sexpr.original}"

puts "\nruby data structure:\n#{sexpr.data}"
puts "\nand back to S-Expr:\n#{sexpr.to_sexpr}"
