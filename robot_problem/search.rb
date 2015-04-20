class Search
  @@visited_nodes = []
  def self.graph_search(problem, strategy)
    fringe = [problem[:initial_state]]
    loop {
      return "Failure" if fringe.empty?
      fringe, node = strategy.select_node_from(fringe)
      @@visited_nodes << node if not already_visited?(node)
      return node if node.is_goal_state?(problem[:goal_test])
      node.expand.each do |successor|
        if not already_visited?(successor)
          fringe = insert_on(fringe, successor)
        end
      end
    }
  end

  def self.path_to(node)
    puts "\n================= Results ================="
    puts "Path cost: #{node.path_cost}"
    puts "Depth: #{node.depth}"
    puts "Visited nodes: #{@@visited_nodes.size}"
    puts "\tAction \t| State "
    while node
      puts "\t#{node.action} \t| #{node.state.snapshot}"
      node = node.parent
    end
  end

  # TODO: Maybe create a hash table
  def self.already_visited?(node)
    visited = @@visited_nodes.select do |visited_node|
      visited_node.state.snapshot == node.state.snapshot
    end
    !visited.empty?
  end

  def self.insert_on(fringe, successor)
    lower_cost = nil
    fringe.each_with_index do |node, index|
      if node.state.snapshot == successor.state.snapshot && node.path_cost > successor.path_cost
        lower_cost = index
      end
    end
    return (fringe + [successor]) if lower_cost.nil?
    fringe[lower_cost] = successor
    fringe
  end
end