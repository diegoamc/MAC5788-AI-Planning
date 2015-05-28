class State
  include Action
  attr_reader :left, :right

  def initialize(attributes={})
    @left = attributes[:left]
    @right = attributes[:right]
  end

  def snapshot
    state = {}
    state.merge({left: @left, right: @right})
  end

  def successors
    applicable_actions(self)
  end
end