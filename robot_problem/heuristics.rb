module Heuristics
  def heuristic0
    return 0
  end

  def heuristic1
    return 1
  end

  def evaluation_function(heuristic)
    path_cost + send("#{heuristic}")
  end
end
