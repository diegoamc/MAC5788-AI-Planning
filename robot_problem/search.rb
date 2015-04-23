class Search
  @@all_nodes = Hash.new
  attr_accessor :generated_nodes

  def self.a_star_tree_search(actions, problem, domain, heuristic, ground)
    root_node = Node.new(state: problem.initial_state, parent: nil, action: nil, path_cost: 0, depth: 0)
    # Initializes a PriorityQueue. Elements with higher priority will be the ones with lower evaluation_functions
    fringe = PQueue.new([root_node]) do |node, other_node|
                      node.evaluation_function(heuristic) < other_node.evaluation_function(heuristic)
                   end
    @@all_nodes[root_node.state] = root_node
    @generated_nodes = 0

    if ground == "all"
      domain.ground_all_actions(problem)
    end

    loop {
      return "Failure" if fringe.empty?
      node = fringe.pop
      return node if problem.goal_test(node)

      if ground == "all"
        actions_applicable = domain.match_applicable_actions(actions, node.state)
      else
        actions_applicable = domain.ground_applicable_actions2(problem, node.state)
      end

      actions_applicable.each do |action|
        new_state = expand(action, node.state)
        @generated_nodes +=1
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
    output_string = ""
    output_string << "\n================= Results ================="
    output_string << "\nPath cost: #{node.path_cost}"
    output_string << "\nDepth: #{node.depth}"
    output_string << "\nVisited nodes: #{@@all_nodes.size}"
    output_string << "\nGenerated nodes: #{@generated_nodes}"
    output_string << "\nFactor: %.3f" % (@generated_nodes.to_f/@@all_nodes.size)
    output_string << "\n\tPlan Action"
    while node
      if node.action != nil
        output_string << "\n\t#{node.action.name}"
      end
      node = node.parent
    end
    return output_string
  end

  private

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

  def self.expandHeuristic(action, state)
    new_state = state.clone
    action.effects.each do |effect|
      if effect.split(" ")[0] != "not"
        new_state[effect] = 1
      end
    end
    return new_state
  end

end
