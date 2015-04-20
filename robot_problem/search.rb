class Search
  @@all_nodes = Hash.new
  def self.a_star_tree_search(actions, problem, domain, heuristic)
    root_node = Node.new(state: problem.initial_state, parent: nil, action: nil, path_cost: 0, depth: 0)
    # Initializes a PriorityQueue. Elements with higher priority will be the ones with lower evaluation_functions
    fringe = PQueue.new([root_node]) do |node, other_node|
                      node.evaluation_function(heuristic) < other_node.evaluation_function(heuristic)
                   end
    @@all_nodes[root_node.state] = root_node
    loop {
      return "Failure" if fringe.empty?
      node = fringe.pop
      return node if problem.goal_test(node)

      domain.match_applicable_actions(actions, node.state).each do |action|
        new_state = expand(action, node.state)
        if not @@all_nodes[new_state]
          successor = Node.new(state: new_state, parent: node, action: action,
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
      # puts "\t#{node.action} \t| #{node.state.snapshot}"
      if node.action != nil
        puts "\t#{node.action.name} \t| #{node.state}"
      end
      node = node.parent
    end
  end

  # private

  def self.expand(action, state)
    new_state = state.clone
    action.effects.each do |effect|
      if effect.split(" ")[0] == "not"
        #TODO remove var remove_predicate
        remove_predicate = effect.gsub("not ", "")
        new_state.delete(remove_predicate)
      else
        new_state[effect] = 1
      end
    end
    return new_state
  end

end
