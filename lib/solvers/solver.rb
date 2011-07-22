require File.join(File.dirname(__FILE__), '..', 'puzzle_box')

class Solver
  attr_reader :x, :y, :z, :side, :box
  attr_accessor :stopping_limit

  def initialize(x, y, z, side, stopping_limit = 50)
    @x = x
    @y = y
    @z = z
    @side = side
    @stopping_limit = stopping_limit

    @box = PuzzleBox.new(@x, @y, @z, @side)
  end

  def solve(starting_x = nil, starting_y = nil, starting_z = nil, options = {})
    raise "Not Implemented."    # implement this in each subclass
  end
end
