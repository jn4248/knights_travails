require "./knights_travails"

# header for test sections
def test_header(test_name)
  puts "\n===================================================================="
  puts "====================================================================\n"
  puts "\n                     #{test_name}"
  puts "\n===================================================================="
  puts "====================================================================\n"
end

# test the bfs method of class TreeOfMoves (breadth-first search)
# Parameters:  tree          class TreeOfMoves
#              location      location being searched. a location array (eg: [x,y])
#              expect_match  boolean, whether the passed location should be correct
def test_bfs(tree, location, expect_match = true)
  puts "\n-----------------------------------------------------------------\n "
  puts "Testing bfs method..."
  puts "\nInitial location: Tree Root = [#{tree.root.location.to_s}]\n "
  node_match = tree.bfs(location)
  results_match = true
  if expect_match
    if node_match.nil?
      results_match = false
    else
      puts "Node match found for [#{location[0]}, #{location[1]}]"
      node_match.show_stats
      results_match = false unless node_match.location == location
    end
  else
    puts "No match found"
    results_match = false unless node_match.nil?
  end
  puts ">>>>>>  ERROR  <<<<<" unless results_match
  puts "\n-----------------------------------------------------------------\n "
end

# test the get_path_to_node and show_path_to_node methods of class TreeOfMoves
# Parameters:   tree         class TreeOfMoves
#               location     location being searched. a location array (eg: [x,y])
def check_path(tree, location)
  puts "\n_________________________________________________________________\n "
  puts "Testing node path methods..."
  puts "\nInitial location: Tree Root = [#{tree.root.location.to_s}]\n "
  node = tree.bfs(location)
  puts "path list:"
  path_list = tree.get_path_to_node(node)
  # path list includes initial square
  puts "#{path_list.size - 1} moves were needed to get to [#{location[0]}, #{location[1]}]"
  puts "The path taken was:"
  tree.show_path_to_node(node)
  puts "\n_________________________________________________________________\n "
end

# test the knights_move method of class TreeOfMoves
# Parameters:  knight           Kight object to be moved
#              initial          initial location. a location array (eg: [x,y])
#              final            final location. a location array (eg: [x,y])
#              msg_condition    Description of current conditions being tested
def test_knight_moves(knight, initial, final, msg_condition)
  puts "\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n "
  puts "Testing knight_moves method..."
  puts "\nCondition: #{msg_condition}"
  puts "\nInitial knight location = [#{knight.cur_location[0]}, #{knight.cur_location[1]}]"
  puts "\nInitial: [#{initial[0]}, #{initial[1]}],  Final: [#{final[0]}, #{final[1]}]\n "
  knight.knight_moves(initial, final)
  puts "\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n "
end



# Create a Knight with default location, create and build the tree of moves
k1 = Knight.new()
puts "New Knight - current location (default should be [0, 0]):"
p k1.cur_location
t1 = TreeOfMoves.new(k1)
t1.build_tree    # defaults to using cur_location as root


# Create a Knight with a given location, create and build the tree of moves
k2 = Knight.new([3,3])
puts "New Knight - current location (should be [3, 3]):"
p k2.cur_location
t2 = TreeOfMoves.new(k2)
t2.build_tree    # defaults to using cur_location as root



# Test method bfs (breadth-first search). Target = node location being searched.
test_header("METHOD:  BFS")

target = [0,0]
test_bfs(t1, target)

target = [5,4]
test_bfs(t1, target)

target = [7,4]
test_bfs(t1, target)

target = [4,3]
test_bfs(t2, target)



# Test methods get/show_path_to_node. Target = node location being searched.
test_header("METHOD:  GET/SHOW_PATH_TO_NODE")

target = [0,0]
check_path(t1, target)

target = [5,4]
check_path(t1, target)

target = [7,4]
check_path(t1, target)

target = [4,3]
check_path(t2, target)



# test method king_moves
test_header("METHOD: KNIGHT_MOVES")

k3 = Knight.new
initial = [0,0]
final = [4,5]
msg = "Default knight initial position; moving from same initial position."
test_knight_moves(k3, initial, final, msg)

k4 = Knight.new
initial = [2,1]
final = [6,7]
msg = "Default knight initial position; moving from different initial position."
test_knight_moves(k4, initial, final, msg)

k5 = Knight.new([3,3])
initial = [3,3]
final = [4,3]
msg = "Non-default knight initial position; moving from same initial position."
test_knight_moves(k5, initial, final, msg)

k6 = Knight.new([6,7])
initial = [3,3]
final = [4,3]
msg = "Non-default knight initial position; moving from different initial position."
test_knight_moves(k6, initial, final, msg)
