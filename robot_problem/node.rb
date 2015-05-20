class Node
  include Heuristics
  # The attribute state holds only the predicates that are true.
  # We are using the closed world assumption.
  attr_accessor :state, :parent, :action, :path_cost, :depth, :heuristic_value

  # Initializes each attribute on the hash attributes. That hash has the form {attribute_name: value}
  # Attribute names can be state, parent, action, path_cost and depth
  def initialize(attributes={})
    attributes.each { |field, value| send("#{field}=", value) }
  end
end
