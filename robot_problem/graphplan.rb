class graphPlanner
  attr_accessor :steps, :plan
  #Algoritmo Graphplan relaxado (uai so...)
  #TODO: 1- create step predicates
  # 2- Search for applicable actions
  # 3- Expand


  def graphPlanner(state, domain, problem)
    @steps = []
    @domain = domain
    @problem = problem
    step = []
    step.depth = 0
    #Initial state
    state.each do |key, value|
      step.state[key] = value
    end
    @steps << step
    calculate_relaxed_plan(step, @domain.actions)
    extractPlan @steps.last
  end

  def extractPlan last_step
    @problem.goal.each do |predicate_goal|
      last_step.parent
    end
  end

  def calculate_relaxed_plan(step, actions_list)
    while(!@problem.goal_test(step.state))
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
      step_actions = step.depth + 1
      step_predicates = step.depth + 2
      #Get applicable actions
      actions_applicable = @domain.match_applicable_actions(actions_list, step.state)
      #Add applicable actions to the action step
      actions_applicable.each do |action|
        step_actions.actions << action.name
        #Add positive effects as new step
        action.effects.each do |efeito|
          step_predicates.state[efeito] = 1
        end
      end
      #Add all effects that were already in the state
      #Iterate step and add no-ops to the action step
      step.state.each do |key, value|
        step_predicates.state[key] = 1
        step_actions.actions << "No-op-" + key
      end
      @steps << step_actions
      @steps << step_predicates
    end
  end
end
