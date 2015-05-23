require_relative 'graphplan'
require_relative 'graphplanOptimus'

module Heuristics
  #load "graphplan.rb"

  def self.heuristic0(state, problem, domain)
    return 0
  end

  def self.heuristic1(state, problem, domain)
    return 1
  end

  def self.evaluation_function(w, heuristic, state, problem, domain)
    w * send("#{heuristic}", state, problem, domain)
  end

  def self.graphPlanHeuristic(state, problem, domain)
    GraphPlanner.new.graphPlanner(state, problem, domain)
  end

  def self.graphPlanHeuristicOpt(state, problem, domain)
    GraphPlannerOptimus.new.graphPlanner(state, problem, domain)
  end

  def self.hspAddHeuristic(state, problem, domain)
    Hsp.new.hspAdd(state, problem, domain)
  end

  def self.hspMaxHeuristic(state, problem, domain)
    Hsp.new.hspMax(state, problem, domain)
  end

end
