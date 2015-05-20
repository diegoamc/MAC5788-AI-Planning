class Hsp
  @@infinity = 999999

  def hspAdd(state, domain, problem)
    return hsp(state, problem, domain, "add")
  end

  def hspMax(state, domain, problem)
    return hsp(state, problem, domain, "max")
  end

  # ground: all actions or ground applicable actions
  # h_type: max or add
  #def self.hsp(state, problem, domain, actions, ground, h_type)
  def hsp(state, problem, domain, h_type)

    @set_preposition = state.clone
    heuristic = Hash.new # predicate,value

    problem.goal.each_key do |predicate|
      state.has_key?(predicate)? heuristic[predicate] = 0 : heuristic[predicate] = @@infinity
    end

    state.each_key do |predicate|
      heuristic[predicate] = 0
    end

    @change = true
    while @change do

      #actions_applicable = actions_applicable(problem, domain, ground, actions, @set_preposition)
      actions_applicable = domain.ground_applicable_actions(problem, @set_preposition)

      @change = false
      actions_applicable.each do |action|
        action.effects.each do |effect|
          if effect.split(" ")[0] != "not" # positive effects
            @change = !@set_preposition.has_key?(effect)
            @set_preposition[effect] = 1
          end
          heuristic[effect] = predicate_cost(h_type, effect, heuristic, action)
        end
      end
    end
    return h_value(heuristic, h_type)
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
    preconditions_value = 0
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

  def h_value(heuristic, h_type)
    if h_type == "max"
      return h_value_max(heuristic)
    else
      return h_value_add(heuristic)
    end
  end

  def h_value_max(heuristic)
    heuristic_value = 0
    heuristic.each do |predicate, value|
      if heuristic_value < value
        heuristic_value = value
      end
    end
    return heuristic_value
  end

  def h_value_add(heuristic)
    heuristic_value = 0
    heuristic.each do |predicate, value|
      heuristic_value += value
    end
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
