require_relative 'graphplan'

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

  def self.evaluation_heuristic(heuristic, state, problem, domain)
    send("#{heuristic}", state, problem, domain)
  end

  def graphPlanHeuristic(state, problem, domain)
    GraphPlanner.new.graphPlanner(state, domain, problem)
  end

  def self.hspAddHeuristic(state, problem, domain)
    Hsp.new.hspAdd(state, problem, domain)
  end

  def self.hspMaxHeuristic(state, problem, domain)
    Hsp.new.hspMax(state, problem, domain)
  end

end
