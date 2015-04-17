require_relative 'requirements'

class Domain
  attr_accessor :name, :predicates, :types, :requirements, :constants,
  :action, :groundedActions

  def initialize(definitions=[])
    raw_objects = raw_initial_state = raw_goal = []
    @action = []
    definitions.each do |definition|
        case definition.first
        #when :problem
        #  @name = definition.last
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

  def groundAllActions(problem)
    groundedActions = {}
    param = {}
    ex = []
    result = []
    action.each do |act|
      act.parameters.each do |key, type|
        param[key] = problem.objects[type]
      end
    end
    ex << param.keys
    test = ex.flatten(1)
    result << param[test.first]
    result = result.flatten
    test.drop(1).each do |el|
      result = product(result, param[el])
    end
      #param.each do |key, objects|
      # objects.each do |object|
      #   ex << object
      # end
      # puts "#{result}"
  end

  private

  def product(vector1, vector2)
    result =[]
    vector1.each do |el|
      vector2.each do |elb|
        result << [el, elb].flatten if el != elb
      end
    end
    return result
  end

  def groundAction(action, param)
    action.precond.each do |element|
      #TODO: Verificar se contem um parametro a ser substituido ?x
    end
    action.effects.each do |eff|
    end
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
    #action.precond = things["precondition"].flatten(1)
    #action.effects = things["effect"].flatten(1)
    action.prepareEffects things["effect"].flatten(1)
    action.preparePreconditions things["precondition"].flatten(1)
    action.prepareParameters things["parameters"].flatten
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
