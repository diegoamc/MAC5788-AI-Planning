class Action
  attr_accessor :name, :parameters, :precond, :effects

  def initialize name
    @name = name
    @parameters = []
    @precond = []
    @effects = []
  end
end
