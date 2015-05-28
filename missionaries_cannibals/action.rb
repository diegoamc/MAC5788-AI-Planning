module Action
  ACTIONS = {
             cc: {missionaries: 0, cannibals: 2},
             mm: {missionaries: 2, cannibals: 0},
             mc: {missionaries: 1, cannibals: 1},
              c: {missionaries: 0, cannibals: 1},
              m: {missionaries: 1, cannibals: 0}
            }

  # REFACTOR ME, PLEASE!
  def applicable_actions(state)
    actions = []
    boat_side, other_side = find_sides(state)
    ACTIONS.each do |action_name, action_move|
      missionaries_boat_side = boat_side[:missionaries] - action_move[:missionaries]
      cannibals_boat_side = boat_side[:cannibals] - action_move[:cannibals]
      missionaries_other_side = other_side[:missionaries] + action_move[:missionaries]
      cannibals_other_side = other_side[:cannibals] + action_move[:cannibals]

      if ((missionaries_boat_side == 0 || missionaries_boat_side >= cannibals_boat_side) &&
          (missionaries_other_side == 0 || missionaries_other_side >= cannibals_other_side) &&
          cannibals_boat_side >=0 && cannibals_other_side >=0)
        if (state.left[:boat])
          successor_state = {left: {missionaries: missionaries_boat_side, cannibals: cannibals_boat_side, boat: false},
                             right: {missionaries: missionaries_other_side, cannibals: cannibals_other_side, boat: true}}
        else
          successor_state = {left: {missionaries: missionaries_other_side, cannibals: cannibals_other_side, boat: true},
                             right: {missionaries: missionaries_boat_side, cannibals: cannibals_boat_side, boat: false}}
        end
        actions << [action_name, State.new(successor_state)]
      end
    end
    actions
  end

  def find_sides(state)
    (state.left[:boat]) ? [state.left, state.right] : [state.right, state.left]
  end
end