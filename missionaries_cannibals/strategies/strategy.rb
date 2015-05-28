class Strategy
  STRATEGIES = %w(LIFO FIFO Astar)
  def self.use(strategy)
    Object.const_get(strategy.capitalize).new
  end

  def self.strategies
    STRATEGIES.inject("") {|strategy, string| string + " #{strategy}"}
  end
end