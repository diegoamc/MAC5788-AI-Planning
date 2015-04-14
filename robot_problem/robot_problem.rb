require_relative 'requirements'

#parse the PDDL input
domain_pddl = File.read("domain.pddl")
problem_pddl = File.read("problem.pddl")
