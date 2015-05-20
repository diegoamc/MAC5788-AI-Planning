class GraphPlannerOptimus
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
    expandPlan(state, @domain.grounded_actions, @problem.goal)
    p "Pronto"
  end


  def expandPlan(state, actions_list, goal_list)
    #Arrays of relaxed Nodes
    scheduled_actions = []
    predicate_step = Step.new
    action_step = Step.new
    #Initial state
    state.each do |key, value|
      predicate_node = RelaxedNode.new(key)
      predicate_node.depth = 0
      predicate_step.addNode(predicate_node)
    end
    #Goals state
    goal_list.each do |predicate_goal, value|
      p predicate_goal
      goal_node = RelaxedNode.new(predicate_goal)
      predicate_step.addNode(goal_node)
    end
    #Initial state actions
    actions_list.each do |action|
      action_node = RelaxedNode.new(action.name)
      action_node.counter = countPreconditions(action)
      action_step.addNode(action_node)
    end

    #Main Loop
    step_number = 0
    for i in 1..2
    #while(!goalAchieved(goal_list, predicate_step))
      #First: Verify actions applicable
      actions_list.each do |action|
        #action_node = RelaxedNode.new(action.name)
        action.precond.each do |precond|
          p predicate_step.state.keys
          if(predicate_step.state.has_key?(precond) && predicate_step.getNode(precond).counter != Float::INFINITY)
            p "Predicado dentro"
            action_step.getNode(action.name).counter -= 1 if action_step.getNode(action.name).counter > 0
          end
        end
        #p "Action: #{action.name} counter: #{action_step.getNode(action.name).counter}"
        if(action_step.getNode(action.name).counter == 0)
          action_step.getNode(action.name).depth = step_number
          scheduled_actions << action_step.getNode(action.name)
        end
      end
      scheduled_actions.each do |action_scheduled|
        action_scheduled.effects do |efeito|
          if(!efeito.start_with?("not") && (!predicate_step.state.has_key?(efeito)))
            efeito_node = RelaxedNode.new(efeito)
            efeito_node.depth = step_number
            predicate_step.addNode(efeito_node)
          end
        end
      end
      step_number += 1
    end
  end

  def goalAchieved(goal_list, predicate_step)
    goal_list.each do |predicate|
      if(predicate_step.getNode(predicate).depth == Float::INFINITY)
        return false
      end
    end
    return true
  end

  def countPreconditions(action)
    counter = 0
    action.precond.each do |precondition|
      counter += 1
    end
    return counter
  end

end
