class Step
  attr_accessor :state, :depth, :sucessor, :parent, :actions

  def initialize
    @state = []
    @actions = []
  end

  def addNode node

  end

  def containsNode node
    @state.each do |precondition|
      
    end
  end
end
