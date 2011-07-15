require File.join(File.dirname(__FILE__), 'puzzle_box')
require File.join(File.dirname(__FILE__), 'solver')

$box = PuzzleBox.new

def move(x,y,z)
  if $box.occupy(x,y,z)
    puts "good points = #{$box.good_points}"
    $box  
  else
    "Illegal move (#{x}, #{y}, #{z})"
  end
end

def undo
  $box.undo
  $box
end

def restart
  $box.reset!
  $box
end

def create(x,y,z,side=8)
  $solver = Solver.new(x,y,z,side,50)
  PuzzleBox.new(x,y,z,side)
end

def box; $box; end

