require_relative 'requirements'

if (ARGV.size != 1) || (!Strategy::STRATEGIES.include?(ARGV[0]))
  raise ArgumentError, "\nUsage: ruby missionaries_cannibals.rb <strategy>\n<strategy> can be one of: #{Strategy.strategies}"
end

strategy = Strategy.use(ARGV[0])
initial_state = State.new({left: {missionaries: 3, cannibals: 3, boat: true},
                           right: {missionaries: 0, cannibals: 0, boat: false}})
goal_state = State.new({left: {missionaries: 0, cannibals: 0, boat: false},
                           right: {missionaries: 3, cannibals: 3, boat: true}})

puts "Initial state:\t#{initial_state.snapshot}"
puts "Goal state:\t#{goal_state.snapshot}"

root = Node.new(state: initial_state, parent: nil, action: nil, path_cost: 0, depth: 0)

start = Time.now
result = Search.graph_search({initial_state: root, goal_test: goal_state}, strategy)
finish = Time.now

result.is_a?(Node) ? Search.path_to(result) : puts(result)

puts "\nRunning time: #{finish - start}"