

# Chess piece - Knight
class Knight

  attr_accessor :cur_location

  def initialize(initial_location = [0,0])
    @initial_location = initial_location    # array ([x,y])
    @cur_location = initial_location        # array ([x,y])
  end

  # Determines the shortest path for a Knight to take, to move from the 'initial'
  # square to the 'final' square, within a grid of 8 x 8 squares (passed as [x,y]).
  # Assumes parameters are arrays of the form [x,y], where x and y are integers
  # between 0 and 7, inclusive.
  # Note: There may be more than one path that results in the least number of
  # moves.  This algorithm only returns one such path.
  # Note: Does not reset knights current location, if (initial != cur_location).
  def knight_moves(initial, final)
    tree = TreeOfMoves.new(self)
    tree.build_tree(initial)
    square = tree.bfs(final)
    path_list = tree.get_path_to_node(square)
    puts "#{path_list.size - 1} moves were needed to get from [#{initial[0]}, #{initial[1]}] to [#{final[0]}, #{final[1]}]"
    puts "\nThe path taken was:\n "
    tree.show_path_to_node(square)
  end

  # Returns an array of legal moves from the piece's current location array [x,y].
  # Moves are filtered from a list of all possbile 'next' moves, removing any
  # that land out of bounds.
  def get_legal_moves(location)
    x = location[0]
    y = location[1]
    moves = [
            [x+2, y+1],
            [x+2, y-1],
            [x-2, y+1],
            [x-2, y-1],
            [x+1, y+2],
            [x+1, y-2],
            [x-1, y+2],
            [x-1, y-2] ]
    legal_moves = []
    # only use if move lands in-bounds
    moves.each do |move|
      unless move.any? {|value| value < 0 || value > 7}
        legal_moves << move
      end
    end
    return legal_moves
  end

  # resets knight ot it's own particular initial state when initialized.
  def reset
    @cur_lcoation = @initial_location
  end

end  # end class Knight


# Tree that considers all possible sequences of moves from the current location.
# Initializes using a chess piece object (eg: Knight)
class TreeOfMoves

  attr_reader :root, :character

  def initialize(character)
    @character = character
    @root = nil       # Node (not an array)
  end

  # build a tree of moves for character (chess piece) associated with the
  # tree.  Tree attempts to reach as many squares on the board (8 x 8 , ranging
  # from 0 to 7 in each direction), with each tree level representing a "move."
  # Thus a location on the third level of the tree would require 2 moves from
  # the initial (root) position.
  # Defaults to creating the root node as the character's current location, but
  # this can be overridden by passing in a different location.  Selecting a
  # different location does not affect the charater's current position.
  def build_tree(location = @character.cur_location)
    @root = Node.new(location)
    node_queue = [@root]
    locations_added = [@root.location]
    # make new nodes from each possible good move, and then check those nodes
    # for moves until no new lcotions appear, or until all move locations
    # have already been explored
    until node_queue.empty?
      cur_node = node_queue.shift
      @character.get_legal_moves(cur_node.location).each do |square|
        unless locations_added.include?(square)
          # create a new node with cur_node as parent
          child = Node.new(square, cur_node)
          cur_node.create_child(child)
          node_queue << child
          locations_added << square
        end
      end
    end
  end

  # Breadth-first search for a node, based on its location on the game board.
  # Assumes location is a non-trivial array, [x,y], where x and y are
  # integers from 0 to 7, inclusive
  def bfs(location)
    queue = [@root]
    node_match = nil
    match_found = false
    until queue.empty? || match_found || @root.nil?
      cur_node = queue.shift
      if cur_node.location == location
        match_found = true
        node_match = cur_node
      else
        unless cur_node.children.nil?
          cur_node.children.each {|child| queue.push(child)}
        end
      end
    end
    return node_match
  end

  # # same method with debug output
  # def bfs(location)
  #   search_order = []                                         # For Debug output
  #   queue = [@root]
  #   node_match = nil
  #   match_found = false
  #   until queue.empty? || match_found || @root.nil?
  #     cur_node = queue.shift
  #     cur_node_location = cur_node.nil? ? "nil" : cur_node.location # For Debug output
  #     search_order << cur_node_location                             # For Debug output
  #     if cur_node.location == location
  #       match_found = true
  #       node_match = cur_node
  #     else
  #       unless cur_node.children.nil?
  #         cur_node.children.each {|child| queue.push(child)}
  #       end
  #     end
  #   end
  #   puts "Breadth-first search order for nodes visited:"      # For Debug output
  #   p search_order                                            # For Debug output
  #   puts "\nTotal nodes visited:  #{search_order.size}"       # For Debug output
  #   return node_match
  # end

  # Returns shortest path from root to node, as an array of locations, in order.
  def get_path_to_node(node)
    path_location_list = [node.location]
    until node.parent.nil?
      node = node.parent
      path_location_list.unshift(node.location)
    end
    return path_location_list
  end

  # Displays to console a string representation of the path to the node
  # from the tree's root.
  # Locations are shown as an array ([x,y]), one per line.
  def show_path_to_node(node)
    path_location_list = get_path_to_node(node)
    path_location_list.each_with_index do |location, index|
      location_string = "[#{location[0]}, #{location[1]}]"
      if index == 0
        puts location_string + "   (Initial Square)"
      elsif index == (path_location_list.size - 1)
        puts location_string + "   (Final Square)"
      else
        puts location_string
      end
    end
  end

end  # end class TreeOfMoves

# A node in the tree of moves that a knight can travel
class Node

  attr_reader :location, :parent, :children

  def initialize(location, parent = nil)
    @location = location    # array ([x,y])
    @parent   = parent      # Node
    @children = nil         # array of Nodes
  end

  # Adds the passed node as a child, but does not add the child to the tree
  def create_child(node)
    if @children.nil?
      @children = [node]
    else
      @children << node
    end
  end

  # Resets the node variables to nil
  def clear
    @location = nil
    @parent   = nil
    @children = nil
  end

  # Returns a string representation of the node, showing its location (eg: [x,y])
  def to_s
    return "[#{@location[0]}, #{@location[1]}]"
  end

  # Returns a string representation of the passed array of nodes.
  # The string shows the locations of the nodes, as arrays [ [x,y], [x,y]]
  def node_array_to_string(arr)
    node_string = ""
    if arr.nil?
      node_string = "none"
    else
      index_last = arr.size - 1
      arr.each_with_index do |node, index|
        # Don't add separator after last element
        separator = (index == index_last) ? "" : ", "
        node_string += node.to_s + separator
      end
      node_string = "[ #{node_string} ]"
    end
    return node_string
  end

  # Displays to console the main qualities of the node
  def show_stats
    puts "\nNode Statistics:"
    loc = @location.nil? ? "nil" : self.to_s
    par = @parent.nil? ? "nil" : @parent.to_s
    chld = node_array_to_string(@children)

    puts "Location:              '#{loc}'"
    puts "Parent location:       '#{par}'"
    puts "Children locations:    '#{chld}'"
  end

end  # end class Node
