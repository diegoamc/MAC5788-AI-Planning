require_relative 'requirements'

class Domain
  attr_accessor :name, :predicates, :types, :requirements, :constants,
  :action, :grounded_actions, :memoized_actions, :substitution

  def initialize(definitions=[])
    @grounded_actions = []
    raw_objects = raw_initial_state = raw_goal = []
    @action = []
    definitions.each do |definition|
        case definition.first
        when :"domain"
          @name = definition.last
        when :":action"
          @action << parse_action(definition.drop 1)
        when :":requirements"
           parse_requirements definition.drop 1
        when :":types"
          parse_types definition.drop 1
        when :":constants"
          parse_constants definition.drop 1
        when :":predicates"
          parse_predicates definition.drop 1
        else
          puts "You shouldn't be here"
        end
    end
  end

  def ground_all_actions(problem)
    result = []
    @action.each do |defined_action|
      defined_action.parameters.to_a.each do |parameter|
        result = product(problem.objects[parameter.last].zip, result)
      end
      result.each do |combination|
        @grounded_actions << ground_action(defined_action, combination)
      end
      result = []
    end
  end

  def ground_applicable_actions(problem, state)
    @memoized_actions = {}
    result = []
    action_Set = []
    @action.each do |defined_action|
      defined_action.parameters.to_a.each do |parameter|
        result = product(problem.objects[parameter.last].zip, result)
      end
      result.each do |combination|
        if(applicable_combination?(defined_action, combination, state))
          str = "#{defined_action.name} #{combination.join("_")}"
          if(!@memoized_actions.has_key?(str))
            a = ground_action(defined_action, combination)
            @memoized_actions[str] = a
            action_Set << a
          else
            action_Set << @memoized_actions[str]
          end
        end
      end
      result = []
    end
    return action_Set
  end

  def ground_applicable_actions2(problem, state)
    action_Set = []
    @action.each do |defined_action|
      a = add_applicables(problem, defined_action, defined_action.precond, {}, state)
      action_Set = action_Set | a
    end
    return action_Set
  end

  def add_applicables(problem, action, precondition, substitution, state)
    if(precondition.empty?)
      response = substitution.empty? ? [] : complete_substitution(action, substitution, problem)
      return response
    else
      action_set = []
      current_precondition = precondition.first
      state.each_key do |predicate_state|
        predicate_precond = current_precondition.split(" ")
        #verificar se a precond esta no estado
        substituicao_parcial = {}
        if(predicate_state.start_with?(predicate_precond.first))
          #Substituir e verificar q é consistente
          objects = predicate_state.split(" ")
          valid_substitution = true
          for i in 1..(objects.size - 1)
            if((substitution[predicate_precond[i]] != objects[i]) &&
              substitution[predicate_precond[i]])
              valid_substitution = false
              break
            else
              substituicao_parcial[predicate_precond[i]] = objects[i]
              substituicao_parcial = substituicao_parcial.merge(substitution)
            end
          end
          if valid_substitution
            action_set = action_set | add_applicables(problem, action, precondition.drop(1), substituicao_parcial, state)
          end
        end
      end
      return action_set
    end
  end

  def complete_substitution(action, substitution, problem)
    foo = []
    action_set = []
    action.parameters.each do |param_name, param_type|
      if !substitution[param_name.to_s]
        problem.objects[param_type].each do |obj|
          substitution[param_name.to_s] = obj.to_s
          action_set = action_set + complete_substitution(action, substitution, problem)
        end
        return action_set
      else
        foo << substitution[param_name.to_s]
      end
    end
    a = ground_action(action, foo)
    action_set << a
    return action_set
  end

  def match_applicable_actions(action_set, state)
    set_applicable = []
    action_set.each do |action|
      if(applicable_action?(action, state))
        set_applicable << action
      end
    end
    return set_applicable
  end

  private

  def applicable_combination?(action, combination, state)
    index = 0
    precondition = action.precond.join("$")
    action.parameters.each_key do |variable|
      precondition.gsub!("#{variable.to_s}", combination[index].to_s)
      index +=1
    end
    foo = precondition.split("$")
    foo.each do |precond|
      if(!state.has_key?(precond))
        return false
      end
    end
    return true
  end

  def applicable_action?(action, state)
    action.precond.each do |precondition|
      if(!state.has_key?(precondition))
        return false
      end
    end
    return true
  end

  def product(vector1, vector2)
    return vector1 if vector2.empty?
    result =[]
    vector2.each do |el|
      vector1.each do |elb|
        result << [el, elb].flatten if el != elb
      end
    end
    return result
  end

  def ground_action2(action, combination)
    new_action = Action.new("#{action.name} #{combination.join("_")}")
    precondition = action.precond.join("$")
    effect = action.effects.join("$")
    index = 0
    action.parameters.each_key do |variable|
      precondition.gsub!("#{variable.to_s}", combination[index].to_s)
      effect.gsub!("#{variable.to_s}", combination[index].to_s)
      index +=1
    end
    new_action.precond = precondition.split("$")
    new_action.effects = effect.split("$")
    return new_action
  end

  def ground_action(action, combination)
    new_action = Action.new("#{action.name} #{combination.join("_")}")
    precondition = action.precond.join("$")
    effect = action.effects.join("$")
    index = 0
    action.parameters.each_key do |variable|
      precondition.gsub!("#{variable.to_s}", combination[index].to_s)
      effect.gsub!("#{variable.to_s}", combination[index].to_s)
      index +=1
    end
    new_action.precond = precondition.split("$")
    new_action.effects = effect.split("$")
    return new_action
  end

  def parse_action(raw)
    action = Action.new raw.first
    things = {}
    last_key = nil
    same_element_action = []
    raw.each do |element|
      case element
        when :":parameters"
          things[last_key] = same_element_action
          last_key = "parameters"
          same_element_action = []
        when :":precondition"
          things[last_key] = same_element_action
          last_key = "precondition"
          same_element_action = []
        when :":effect"
          things[last_key] = same_element_action
          last_key = "effect"
          same_element_action = []
        else
          same_element_action << element
        end
      end
    things[last_key] = same_element_action
    action.prepare(action.effects, things["effect"].flatten(1))
    action.prepare(action.precond, things["precondition"].flatten(1))
    action.prepare_parameters things["parameters"].flatten
    return action
  end

  def parse_predicates(raw)
    #TODO: How to represent predicates? list? hash? to discuss...
    @predicates = []
    raw.each do |element|
      @predicates << element
    end
  end

  def parse_constants(raw)
    @constants = {}
    same_type_constants = []
    last_constant = nil
    raw.each do |element|
      if last_constant == :-
        @constants[element] = same_type_constants.take(same_type_constants.size-1)
        same_type_constants = []
      else
        same_type_constants << element
      end
      last_constant = element
    end
  end

  def parse_requirements(raw)
    @requirements = []
    raw.each do |element|
      @requirements << element
    end
  end

  def parse_types(raw)
    @types = []
    raw.each do |element|
      @types << element
    end
  end

end
