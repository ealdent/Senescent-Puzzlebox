require File.join(File.dirname(__FILE__), 'solver')

class GreedyBruteForceSolver < Solver
  def solve(starting_x = nil, starting_y = nil, starting_z = nil, options = {})
    limit = 0
    if starting_x && starting_y && starting_z
      if @box.occupy(starting_x, starting_y, starting_z)
        limit += 1
      else
        raise "Starting square occupied."
      end
    end
    current_score = @box.good_points

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

      if moves.empty? || limit >= @stopping_limit
        puts "No valid moves remaining. :("
        break
      else
        moves.sort! { |a, b| b[1] <=> a[1] }
        @box.occupy(*moves[0][0])
        limit += 1
        current_score = @box.good_points
        puts "Moved to #{moves[0][0].inspect} ---> #{current_score}"
        puts @box if options[:verbose]
      end
    end

    puts "Final state: #{@box}"
  end
end
