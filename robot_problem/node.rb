class Node
  # The attribute state holds only the predicates that are true.
  # We are using the closed world assumption.
  attr_accessor :state, :parent, :action, :path_cost, :depth

  # Initializes each attribute on the hash attributes. That hash has the form {attribute_name: value}
  # Attribute names can be state, parent, action, path_cost and depth
  def initialize(attributes={})
    attributes.each { |field, value| send("#{field}=", value) }
  end

  def expand
    # This does not work since state is not a class
    #state_sucessors = self.state.successors
    #state_sucessors.map do |action, state|
    #  Node.new(state: state, parent: self, action: action,
    #           path_cost: self.path_cost + 1, depth: self.depth + 1)
    #end
  end

end
