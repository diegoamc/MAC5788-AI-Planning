class GraphPlanner
  attr_accessor :steps, :plan, :relaxed_plan
  #Algoritmo Graphplan relaxado (uai so...)
  #TODO: 1- create step predicates
  # 2- Search for applicable actions
  # 3- Expand


  def graphPlanner(state, problem, domain)
    @steps = []
    @domain = domain
    @problem = problem
    @relaxed_plan = {}
    expandPlan(state, @domain.grounded_actions)
  end


  def expandPlan(state, actions_list)
    predicate_step = Step.new
    action_step = Step.new
    #Initial state
    state.each do |key, value|
      predicate_node = RelaxedNode.new(key)
      predicate_node.depth = 0
      predicate_step.addNode(predicate_node)
    end
    #Initial state actions
    actions_list.each do |action|
      action_node = RelaxedNode.new(action.name)
      action_step.addNode(action_node)
    end
  end

end
