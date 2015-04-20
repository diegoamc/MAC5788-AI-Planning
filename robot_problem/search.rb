class Search
  @@all_nodes = Hash.new
  def self.a_star_tree_search(problem, heuristic)
    root_node = Node.new(state: problem.initial_state, parent: nil, action: nil, path_cost: 0, depth: 0)
    fringe = PriorityQueue.new(root_node, heuristic)
    @@all_nodes[root_node.object_id] = root_node
    loop {
      return "Failure" if fringe.empty?
      node = fringe.select_node
      return node if problem.goal_test?(node.state)
      node.expand.each do |successor|
        if not @@all_nodes[successor.object_id]
          fringe.add(successor)
          @@all_nodes[successor.object_id] = successor
        end
      end
    }
  end

  def self.path_to(node)
    puts "\n================= Results ================="
    puts "Path cost: #{node.path_cost}"
    puts "Depth: #{node.depth}"
    puts "Visited nodes: #{@@all_nodes.size}"
    puts "\tAction \t| State "
    while node
      puts "\t#{node.action} \t| #{node.state.snapshot}"
      node = node.parent
    end
  end
end
