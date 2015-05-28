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

  # (Number of people on the initial side) - 1
  def heuristic1(state)
    (state.left[:missionaries] + state.left[:cannibals]) - 1
  end

  # (Number of people on the initial side) / Boat Capacity
  def heuristic2(state)
    (state.left[:missionaries] + state.left[:cannibals]) / 2
  end

  def evaluation_funcion(node)
    node.path_cost + heuristic1(node.state)
  end
end