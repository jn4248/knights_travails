# knights_travails

## Overview
Project 2 of section "Project: Data Structures and Algorithms," from The Odin Project series.  

Main methods created and tested are `knight_moves` from class Knight, and `bfs` (breadth_first_search) from class TreeOfMoves.  

Class TreeOfMoves maintains and creates (via `build_tree`) a tree of all possible moves for a chess piece (here only class Knight is implemented).  Each level of the tree represents one more "move" possible in a succession of any number of moves from the same current location. Once the piece moves to another location, a new tree needs to be created.  However, trees can be built using the piece's current location (default) or any other location passed to the method.  

There is a also a class Node that keeps tracks of the "squares" that are used to create the tree.

A separate file `knights_travails_test.rb` runs methods with console output to test the major methods of `knights_travails.rb.`
