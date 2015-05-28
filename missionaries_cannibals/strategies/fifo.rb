class Fifo < Strategy
  def select_node_from(fringe)
    selected = fringe.shift
    [fringe, selected]
  end
end