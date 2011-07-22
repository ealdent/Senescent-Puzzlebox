# Technically this should be called "Greedy Brute Force Solver"
require File.join(File.dirname(__FILE__), 'puzzle_box')

class BruteForceSolver
  attr_reader :x, :y, :z, :side
  attr_accessor :stopping_limit

  def initialize(x, y, z, side, stopping_limit=50)
    @x = x
    @y = y
    @z = z
    @side = side
    @stopping_limit = stopping_limit

    @box = PuzzleBox.new(@x, @y, @z, @side)
  end

  def solve(starting_x = nil, starting_y = nil, starting_z = nil)
    limit = 1
    if starting_x.nil? || starting_y.nil? || starting_z.nil?
      starting_x = rand(@side)
      starting_y = rand(@side)
      starting_z = rand(@side)
    end

    unless @box.occupy(starting_x, starting_y, starting_z)
      raise "Starting square occupied or threatened."
    end

    current_score = @box.good_points
    index_to_look_at = [0]

    while !@box.solved?
      moves = []
      (0...@side).each do |xi|
        (0...@side).each do |yi|
          (0...@side).each do |zi|
            if @box.occupy(xi, yi, zi)
              moves << [[xi, yi, zi], @box.good_points - current_score]
              @box.undo
            end
          end
        end
      end
      if moves.empty? || index_to_look_at.last > moves.count || limit >= @stopping_limit
        index_to_look_at.pop if index_to_look_at.last > moves.count
        puts "No valid moves remaining. :("
        @box.undo
        limit -= 1
        index_to_look_at << (index_to_look_at.last || 0) + 1
      else
        moves.sort! { |a, b| b[1] <=> a[1] }
        idx = index_to_look_at.pop
        @box.occupy(*moves[idx][0])
        limit += 1
        current_score = @box.good_points
        puts "Moved to #{moves[idx][0].inspect} ---> #{current_score}"
        index_to_look_at << 0
      end
    end

    puts "Final state: #{@box}"
  end
end
