class Problem
  attr_accessor :name, :domain_name, :objects, :initial_state, :goal

  def initialize(definitions=[])
    raw_objects = raw_initial_state = raw_goal = []
    definitions.each do |definition|
        case definition.first.downcase
        when :problem
          @name = definition.last
        when :":domain"
          @domain_name = definition.last
        when :":objects"
          parse_objects definition.drop 1
        when :":init"
          if(definition[1].first.to_s == "and")
            @initial_state = parse_predicate(definition.drop(1).first.drop(1))
          else
            @initial_state = parse_predicate definition.drop 1
          end
        when :":goal"
          @goal = parse_predicate(definition.drop(1).first.drop(1))
        else
          p definition
          puts "You shouldn't be here"
        end
    end
  end

  def goal_test(node)

    goal.each do |key, value|
      if not node.state.has_key?(key.to_s)
        return false
      end
    end
    return true
  end

  private

  def parse_objects(raw)
    @objects = {}
    same_type_objects = []
    last_object = nil
    raw.each do |element|
      element = element.downcase
      if last_object == :-
        #------mudança
        if(@objects.has_key?(element))
          aux_array = []
          aux_array = @objects[element]
          aux_array << same_type_objects.take(same_type_objects.size-1)
          same_type_objects = []
          @objects[element] = aux_array.flatten
        #------end-mudança
        else
          @objects[element] = same_type_objects.take(same_type_objects.size-1)
          same_type_objects = []
        end
      else
        same_type_objects << element
      end
      last_object = element
    end
  end

  def parse_state(raw)
    state_hash = Hash.new([])
    raw.each do |element|
      values = element.size == 2 ? element.drop(1) : [element.drop(1)]
      state_hash[element.first] = state_hash[element.first] + values
    end
    return state_hash
  end

  def parse_predicate(raw)
    state_hash = Hash.new([])
    raw.each do |element|
      state_hash[element.join(" ").downcase]=1
    end
    return state_hash
  end
end
