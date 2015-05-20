class Step
  attr_accessor :state, :depth, :sucessor, :parent, :actions

  def initialize
    @state = {}
    @actions = []
    @depth = 0
  end

  def contains node
    return @state.has_key?(node.predicate)
  end

  def addNode node
    @state[node.predicate] = node
  end

  def getNode predicate
    return @state[predicate]
  end

  def updateParentNode(predicate, parent)
    @state[predicate].parent.push parent
  end

  def updateSucessorNode(predicate, sucessor)
    @state[predicate].sucessor << sucessor
  end


end
