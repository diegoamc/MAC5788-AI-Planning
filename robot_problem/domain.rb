require_relative 'requirements'

class Domain
  attr_accessor :name, :predicates, :types, :requirements, :constants, :action

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

  private

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
    action.parameters = things["parameters"].flatten
    action.precond = things["precondition"].flatten(1)
    action.effects = things["effect"].flatten(1)
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
