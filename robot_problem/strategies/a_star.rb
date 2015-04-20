class Astar < Strategy
  # TODO: Maybe use a heap
  def select_node_from(fringe)
    selected = nil
    min = 10000000000000000
    fringe.each do |node|
      evaluation = evaluation_funcion(node)
      if evaluation < min
        min = evaluation
        selected = node
      end
    end
    selected = fringe.delete(selected)
    [fringe, selected]
  end

  def heuristic0
    return 0
  end

  def heuristic1
    return 1
  end

  def evaluation_funcion(node)
    node.path_cost + heuristic0
  end
end
