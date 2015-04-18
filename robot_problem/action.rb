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

  def prepare(object , list)
    if list.first == :and
      list.drop(1).each do |element|
        object.send("<<", element.join(" "))
      end
    else
      object.send("<<", list.join(" "))
    end
  end
end
