class Knight

  attr_reader :position, :parent
  attr_accessor :children

  def initialize(position, parent)
    @position = position
    @parent = parent
    @children = []
  end

  TRANSFORMATIONS = [[2, 1], [-2, 1], [1, 2], [-1, 2], [1, -2], [-1, -2], [2, -1], [-2, -1]]

  # Method which creates a child node for each valid move from the node the method is called upon. Each child node is added to the parent node's 'children' variable
  def make_children(used)
    childs = TRANSFORMATIONS.map { |move| [position[0] + move[0], position[1] + move[1]] }
                            .select { |p| in_board?(p) }
                            .reject { |p| used.include?(p) }

    childs.each do |child|
      children.push(Knight.new(child, self))
    end
  end

  # Method which returns true if a given position is on an 8x8 board, else returns false
  def in_board?(position)
    position[0].between?(1, 8) && position[1].between?(1, 8)
  end
end

# Method which returns an array of the .position of all parents of a given node.
def parents_array(node, array = [])
  parents_array(node.parent, array) unless node.parent.nil?
  array.push(node.position)
end

# Method which accepts an array of moves and pretty prints the number of moves alongside each move with an arrow showing where the move started and then ended.
def print_path(moves)
  size = moves.size
  puts "You made it from #{moves.first} to #{moves.last} in #{size - 1} moves. The moves were:"
  moves.each_with_index do |move, i|
    i += 1
    puts "#{move} -> #{moves[i]}" if i < size
  end
end

# Method which accepts a start position in the form of an array of two values between 1 & 8 and a finish position in the same format (For example, knight_moves([1, 1], [5, 8])) and creates a tree of moves. The shortest path of moves from the start position to the finish position is then printed.
def knight_moves(start, finish)
  current = Knight.new(start, nil)
  used = [current.position]
  queue = [current]
  while current.position != finish
    current.make_children(used)
    current.children.each do |child|
      queue.push(child)
      used.push(child.position)
    end
    queue.shift
    current = queue[0]
  end
  print_path(parents_array(current))
end

knight_moves([1, 1], [4, 5])
knight_moves([3, 3], [5, 8])
knight_moves([4, 4], [1, 1])
knight_moves([1, 8], [8, 1])
