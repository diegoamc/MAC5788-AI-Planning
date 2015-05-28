class Lifo < Strategy
  def select_node_from(fringe)
    selected = fringe.pop
    [fringe, selected]
  end
end