class RelaxedNode
  attr_accessor :sucessor, :parent, :predicate, :depth

  def initialize predicate
    @predicate = predicate
    @depth = Float::INFINITY
    @sucessor = []
    # Here we are using the Noop-first heuristic combined with the difficulty heuristic
    @parent = PQueue.new([]) do |relaxed1, relaxed2|
      if relaxed1.predicate.start_with?("No-op") && !relaxed2.predicate.start_with?("No-op")
        1
      elsif relaxed2.predicate.start_with?("No-op") && !relaxed1.predicate.start_with?("No-op")
        -1
      else
        relaxed1.depth < relaxed2.depth
      end
    end
  end
end
