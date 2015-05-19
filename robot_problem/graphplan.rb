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
    @relaxed_plan = []
    step = Step.new
    #Initial state
    state.each do |key, value|
      node = RelaxedNode.new key
      step.addNode node
    end
    @steps << step
    while(!@problem.goal_test(@steps.last))
      calculate_relaxed_plan(@steps.last, @domain.grounded_actions)
      #p @steps.last.state
    end
    extractPlan @steps.last
  end

  def plotHashMap state
    state.each do |key, value|
      p "Key #{key} Value: #{value.predicate}"
    end
  end

  def extractPlan last_step
    subgoals = @problem.goal.keys
    current_step = last_step
    while(!current_step.parent.nil?)
      p "========================"
      actual_list = []
      subgoals.each do |predicate_goal|
        p "---------------------"
        node = current_step.getNode(predicate_goal)
        #TODO: heuristic no op first
        if(!node.parent.nil?)
          node.parent.each do |parent|
            actual_list << parent.predicate
          end
        end
      end
      if(current_step.depth % 2 == 0)
        @relaxed_plan << actual_list.clone
      end
      subgoals = subgoals.clear
      subgoals = actual_list
      if(!current_step.parent.nil?)
        current_step = current_step.parent
      end
    end
  end

  def calculate_relaxed_plan(step, actions_list)
    #Create new step of actions
    step_actions = Step.new
    #Create new step of predicates
    step_predicates = Step.new
    #Make it a son of the other step
    step.sucessor = step_actions
    step_actions.parent = step
    step_actions.sucessor = step_predicates
    step_predicates.parent = step_actions
    #Add depths of the new steps
    step_actions.depth = step.depth + 1
    step_predicates.depth = step.depth + 2
    #Get applicable actions
    #p actions_list
    actions_applicable = @domain.match_applicable_actions(actions_list, step.state)
    #Add applicable actions to the action step
    actions_applicable.each do |action|
      #create new node of action
      node = RelaxedNode.new(action.name)
      #Add positive effects as new step
      action.effects.each do |efeito|
        #Verify is a positive effect!
        if(!efeito.start_with?("not"))
          #if so, add effect if not predicate contained
          #create new node and link it to the parent
          effect_Node = RelaxedNode.new(efeito)
          effect_Node.parent << node
          node.sucessor << effect_Node
          #Add nodes to the list of nodes of the step of predicates
          if(!step_predicates.contains(effect_Node))
            step_predicates.addNode(effect_Node)
          else
            #Update node to point to another father
            step_predicates.updateParentNode(efeito, node)
          end
        end
      end
      #Add preconditions
      action.precond.each do |precondition|
        parent_precond_node = step.getNode(precondition)
        node.parent << parent_precond_node
        step.updateSucessorNode(precondition, node)
      end
      #Add nodes to the list of nodes of the step of actions
      step_actions.addNode(node)
    end
    #Add all effects that were already in the state
    #Iterate step and add no-ops to the action step
    step.state.each do |key, value|
      #Create a new action node with the noop action
      action_noop_node = RelaxedNode.new("No-op-" + key)
      effect_noop_node = RelaxedNode.new(key)
      #Adicionamos os noops aos pais e filhos
      step_actions.addNode(action_noop_node)
      step_predicates.addNode(effect_noop_node)
      step_actions.updateParentNode(action_noop_node.predicate, value)
      step_actions.updateSucessorNode(action_noop_node.predicate, effect_noop_node)
      step_predicates.updateParentNode(effect_noop_node.predicate, action_noop_node)
    end
    @steps << step_actions
    @steps << step_predicates
  end
end
