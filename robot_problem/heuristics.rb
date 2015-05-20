require_relative 'graphplan'
require_relative 'graphplanOptimus'

module Heuristics
  #load "graphplan.rb"

  def heuristic0(state, problem, domain)
    return 0
  end

  def heuristic1(state, problem, domain)
    return 1
  end

  def evaluation_function(heuristic, state, problem, domain)
    path_cost + send("#{heuristic}", state, problem, domain)
  end

  def graphPlanHeuristic(state, problem, domain)
    GraphPlanner.new.graphPlanner(state, domain, problem)
  end

  def graphPlanHeuristicOpt(state, problem, domain)
    GraphPlannerOptimus.new.graphPlanner(state, domain, problem)
  end

end
