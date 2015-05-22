class Hsp
  @@infinity = 999999

  def hspAdd(state, problem, domain)
    return hsp(state, problem, domain, "add")
  end

  def hspMax(state, problem, domain)
    return hsp(state, problem, domain, "max")
  end

  # ground: all actions or ground applicable actions
  # h_type: max or add
  #def self.hsp(state, problem, domain, actions, ground, h_type)
  def hsp(state, problem, domain, h_type)
    @set_preposition = state.clone
    #p @set_preposition
    heuristic = Hash.new # predicate,value
    set_actions = Hash.new

    problem.goal.each_key do |predicate|
      state.has_key?(predicate)? heuristic[predicate] = 0 : heuristic[predicate] = @@infinity
    end

    state.each_key do |predicate|
      heuristic[predicate] = 0
    end

    @change = true
    while @change do
      #actions_applicable = actions_applicable(problem, domain, ground, actions, @set_preposition)
      #actions_applicable = domain.ground_applicable_actions(problem, @set_preposition)
      actions_applicable = domain.match_applicable_actions(domain.grounded_actions, @set_preposition)

      # TODO isso mesmo?
      if actions_applicable.empty?
        return @@infinity
      end

      actions_applicable.each do |action|
        set_actions.has_key?(action.name)? @change = false : @change = true
        set_actions[action.name] = 1

        action.effects.each do |effect|
          if effect.split(" ")[0] != "not" # positive effects
            @set_preposition[effect] = 1
            heuristic[effect] = predicate_cost(h_type, effect, heuristic, action)
          end
        end
      end
    end
    return h_value(heuristic, h_type, problem)
  end

  private

  def predicate_cost(h_type, effect, heuristic, action)
    if not heuristic.has_key?(effect.to_s)
      heuristic[effect] = @@infinity
    end

    h_type == "max"? preconditions_value = preconditions_cost_max(action, heuristic):
      preconditions_value = preconditions_cost_add(action, heuristic)

    preconditions_value += 1
    return [preconditions_value, heuristic[effect]].min
  end

  def preconditions_cost_max(action, heuristic)
    preconditions_value = -1
    action.precond.each do |precond|
      if preconditions_value < heuristic[precond]
        preconditions_value = heuristic[precond]
      end
    end
    return preconditions_value
  end

  def preconditions_cost_add(action, heuristic)
    preconditions_value = 0
    action.precond.each do |precond|
      preconditions_value += heuristic[precond]
    end
    return preconditions_value
  end

  def h_value(heuristic, h_type, problem)
    if h_type == "max"
      return h_value_max(heuristic, problem)
    else
      return h_value_add(heuristic, problem)
    end
  end

  def h_value_max(heuristic, problem)
    heuristic_value = -1
    problem.goal.each_key do |predicate|
      if heuristic_value < heuristic[predicate]
        heuristic_value = heuristic[predicate]
      end
    end
    # p heuristic_value
    return heuristic_value
  end

  def h_value_add(heuristic, problem)
    heuristic_value = 0
    problem.goal.each_key do |predicate|
      heuristic_value += heuristic[predicate]
    end
    # p heuristic_value
    return heuristic_value
  end

  def actions_applicable(problem, domain, ground, actions, set_preposition)
    if ground == "all"
      return domain.match_applicable_actions(actions, set_preposition)
    else
      return domain.ground_applicable_actions(problem, set_preposition)
    end
  end

end
