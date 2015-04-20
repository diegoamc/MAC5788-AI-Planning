class Search
  @@all_nodes = Hash.new
  def self.a_star_tree_search(actions, problem, domain, heuristic)
    root_node = Node.new(state: problem.initial_state, parent: nil, action: nil, path_cost: 0, depth: 0)
    # Initializes a PriorityQueue. Elements with higher priority will be the ones with lower evaluation_functions
    fringe = PQueue.new([root_node], heuristic) do |node, other_node|
                      node.evaluation_function(heuristic) < other_node.evaluation_function(heuristic)
                   end
    @@all_nodes[root_node.state] = root_node
    loop {
      return "Failure" if fringe.empty?
      node = fringe.pop
      return node if problem.goal_test?(node.state)
      domain.match_applicable_actions(actions, problem, node.state) do |action|
        new_state = expand(action, node.state)
        if not @@all_nodes[new_state]
          sucessor = Node.new(state: new_state, parent: node, action: action,
                                              path_cost: (node.path_cost + 1), depth: (node.depth + 1))
          fringe.push(successor)
          @@all_nodes[successor.state] = successor
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
