# abstraction for the state
class State
  attr_accessor :name, :actions, :reward, :greedy_action
  attr_writer :solved, :initial_state, :goal_state, :visited, :stacked

  def initialize(name)
    @solved = false
    @initial_state = false
    @goal_state = false
    @visited = false
    @name = name
    @actions = {}
  end

  def solved?
    @solved
  end

  def is_goal_state?
    @goal_state
  end

  def visited?
    @visited
  end

  def stacked?
    @stacked
  end
end
