require_relative 'requirements'

class Search
  @@all_nodes = Hash.new
  @@number_nodes = 0
  attr_accessor :generated_nodes

  def self.a_star_tree_search(actions, problem, domain, heuristic, w, ground)

    if ground == "all"
      domain.ground_all_actions(problem)
    end

    heuristic_value = Heuristics.evaluation_function(w, heuristic, problem.initial_state, problem, domain)
    root_node = Node.new(state: problem.initial_state, parent: nil, action: nil, path_cost: 0,
                                                  depth: 0, heuristic_value: heuristic_value)
    # Initializes a PriorityQueue. Elements with higher priority will be the ones with lower evaluation_functions
    @@all_nodes.clear
    fringe = PQueue.new([root_node]) do |node, other_node|
                      node.heuristic_value < other_node.heuristic_value
                  end
    @@all_nodes[root_node.state] = root_node
    @generated_nodes = 0

    loop {
      return "Failure" if fringe.empty?
      node = fringe.pop
      return node if problem.goal_test(node)

      if ground == "all"
        actions_applicable = domain.match_applicable_actions(actions, node.state)
      else
        actions_applicable = domain.ground_applicable_actions(problem, node.state)
      end
      actions_applicable.each do |action|
        new_state = expand(action, node.state)
        @generated_nodes +=1
        if not @@all_nodes[new_state]
          heuristic_value = Heuristics.evaluation_function(w, heuristic, new_state, problem, domain)
          successor = Node.new(state: new_state, parent: node, action: action,
                                            path_cost: (node.path_cost + 1), depth: (node.depth + 1),
                                            heuristic_value: (heuristic_value + node.depth + 1))
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
    @@number_nodes = @generated_nodes
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

  def self.all_nodes
    return @@all_nodes
  end

  def self.number_nodes
    return @@number_nodes
  end

  private

  def self.expand(action, state)
    new_state = state.clone
    action.effects.each do |effect|
      if effect.split(" ")[0] == "not"
        new_state.delete(effect.gsub("not ", ""))
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
