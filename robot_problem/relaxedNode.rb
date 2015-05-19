class RelaxedNode
  attr_accessor :sucessor, :parent, :predicate, :depth

  def initialize predicate
    @predicate = predicate
    @depth = Float::INFINITY
    @sucessor = []
    @parent = []
  end
end
