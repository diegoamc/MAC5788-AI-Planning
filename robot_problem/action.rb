class Action
  attr_accessor :name, :parameters, :precond, :effects

  def initialize name
    @name = name
    @parameters = {}
    @precond = []
    @effects = []
  end

  def prepareParameters parameters_list
    same_type_parameters = []
    last_element = nil
    parameters_list.each do |param|
      if last_element == :-
        same_type_parameters.take(same_type_parameters.size-1).each do |element|
          parameters[element] = param
        end
        same_type_parameters = []
      else
        same_type_parameters << param
      end
      last_element = param
    end
  end

  def preparePreconditions predicates_list
    #TODO: Daria para desduplicar este método e evitar ter ele replicado abaixo?
    if predicates_list.first == :and
      predicates_list.drop(1).each do |element|
        precond << element.join(" ")
      end
    else
      precond << predicates_list.join(" ")
    end
  end

  def prepareEffects predicates_list
    if predicates_list.first == :and
      predicates_list.drop(1).each do |element|
        effects << element.join(" ")
      end
    else
      effects << predicates_list.join(" ")
    end
  end

end
