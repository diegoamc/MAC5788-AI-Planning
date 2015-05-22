class GraphPlannerOptimus
  attr_accessor :steps, :plan, :relaxed_plan
  #Algoritmo Graphplan relaxado (uai so...)
  #TODO: 1- create step predicates
  # 2- Search for applicable actions
  # 3- Expand


  def graphPlanner(state, problem, domain)
    #p "Calculando heuristica"
    #p state
    @steps = []
    @domain = domain
    @problem = problem
    @relaxed_plan = []
    #p state.keys
    expandPlan(state, @domain.grounded_actions, @problem.goal)
    #p "Pronto, vamos extrair o plano"
    extractRelaxedPlan(@problem.goal)
    return @relaxed_plan.size
  end

  def extractRelaxedPlan(goal_list)
    goal_Membership = Hash.new([])
    true_Membership = Hash.new([])
    goals_array = []
    goal_list.each do |predicate_goal, value|
      goals_array << predicate_goal
      goal_Membership[@predicate_step.getNode(predicate_goal).depth] = goals_array
    end
    @step_number.downto(1) do |i|
      iterator_array = []
      iterator_array = goal_Membership[i].clone
      iterator_array.each do |goal_at_i|
        if(!true_Membership[i].include?(goal_at_i) && (@predicate_step.getNode(goal_at_i).depth != 0) && (@predicate_step.getNode(goal_at_i).parent.size > 0) )
          achieving_action_node = @predicate_step.getNode(goal_at_i).parent.pop
          achieving_action = @scheduled_actions[achieving_action_node.predicate]
          @relaxed_plan << achieving_action
          if(achieving_action_node.depth == i -1)
            achieving_action.precond.each do |precondition|
              if(!true_Membership[i-1].include?(precondition) && @predicate_step.getNode(precondition).depth != 0)
                #p precondition
                goal_Membership[@predicate_step.getNode(precondition).depth-1] << precondition
                goal_Membership[@predicate_step.getNode(precondition).depth-1].uniq!
                #p goal_Membership[@predicate_step.getNode(precondition).depth-1]
                #p "Precondition: #{precondition} depth: #{@predicate_step.getNode(precondition).depth}"
              end
            end
          end
          #mark effects as TRUE
          achieving_action.effects.each do |efeito|
            if true_Membership[i].empty?
              true_Membership[i] = [efeito]
            else
              true_Membership[i] << efeito
            end
            if i >= 1 && true_Membership[i-1].empty?
              true_Membership[i-1] = [efeito]
            else
              true_Membership[i-1] << efeito
            end
          end
          #p "True: #{true_Membership[i]}"
        end
      end
    end
  end

  def expandPlan(state, actions_list, goal_list)
    #p "Cheguei no expand"
    #Arrays of relaxed Nodes
    @scheduled_actions = {}
    current_predicates = {}
    next_predicates = {}
    actions_added = {}
    @predicate_step = Step.new
    @action_step = Step.new
    #Goals state
    goal_list.each do |predicate_goal, value|
      goal_node = RelaxedNode.new(predicate_goal)
      @predicate_step.addNode(goal_node)
    end
    #Initial state
    state.each do |key, value|
      predicate_node = RelaxedNode.new(key)
      #p key
      predicate_node.depth = 0
      @predicate_step.addNode(predicate_node)
      current_predicates[key] = 1
    end

    #Initial state actions
    actions_list.each do |action|
      action_node = RelaxedNode.new(action.name)
      action_node.counter = countPreconditions(action)
      @action_step.addNode(action_node)
    end

    #Main Loop
    @step_number = 0
    #for i in 1..2
    while(!goalAchieved(goal_list))
      #p "Iteracao #{@step_number} ======================="
      #First:
      #Adicionando efeitos das açoes possiveis
      #p @scheduled_actions
      @scheduled_actions.each do |key, action_scheduled|
        action_scheduled.effects.each do |efeito|
          #TODO: Revisar condiçao
          #p "Efeito #{efeito} Entra?: #{!efeito.start_with?("not") && !current_predicates.has_key?(efeito)}"
          if(!efeito.start_with?("not") && (!current_predicates.has_key?(efeito)))
          #if(!efeito.start_with?("not") && (!@predicate_step.state.has_key?(efeito)))
            efeito_node = RelaxedNode.new(efeito)
            efeito_node.depth = @step_number
            #p @action_step.getNode(action_scheduled.name)
            efeito_node.parent.push(@action_step.getNode(action_scheduled.name))
            @predicate_step.addNode(efeito_node)
            #scheduled_predicates[@step_number+1] << efeito_node
            next_predicates[efeito] = 1
          elsif(!efeito.start_with?("not"))
            #p "Updating node #{efeito} value: #{@predicate_step.getNode(efeito).depth} new value #{@step_number}"
            #@predicate_step.getNode(efeito).depth = @step_number
            next_predicates[efeito] = 1
          end
        end
      end
      #Second: Verify actions applicable
      actions_list.each do |action|
        #action_node = RelaxedNode.new(action.name)
        action.precond.each do |precond|
          #TODO: Revisar condiçao
          if(@predicate_step.state.has_key?(precond) && @predicate_step.getNode(precond).depth != Float::INFINITY)
            #p "Action name: #{action.name} counter: #{@action_step.getNode(action.name).counter}"
            @action_step.getNode(action.name).counter -= 1 if @action_step.getNode(action.name).counter > 0
            #p "Action name: #{action.name} counter: #{@action_step.getNode(action.name).counter}"
          end
        end
        #p "Action: #{action.name} counter: #{@action_step.getNode(action.name).counter}"
        if(@action_step.getNode(action.name).counter == 0 && !actions_added.has_key?(action.name))
          @action_step.getNode(action.name).depth = @step_number
          actions_added[action.name] = 1
          #p "Action added: #{action.name}"
          @scheduled_actions[action.name] = action
        end
      end
      @step_number += 1
      # p "Actions applicable: #{scheduled_actions.keys}"
      # p "Current predicates: #{current_predicates.keys}"
      # p "Next predicates: #{next_predicates.keys}"
      current_predicates.merge!(next_predicates.clone)
      next_predicates.clear
    end
  end

  def goalAchieved(goal_list)
    goal_list.each do |predicate, value|
      if(@predicate_step.getNode(predicate).depth == Float::INFINITY)
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
