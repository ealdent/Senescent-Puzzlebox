require File.join(File.dirname(__FILE__), 'solver')
require 'matrix'

class FastGreedyBruteForceAdjacencySolver < Solver
  def solve(starting_x = nil, starting_y = nil, starting_z = nil, options = {})
    @box.reset!

    @adjacency_matrix ||= @box.adjacency_matrix.map { |row| Vector.elements(row) }
    goal_idx = compute_index(@x, @y, @z)

    if starting_x && starting_y && starting_z
      if @box.occupy(starting_x, starting_y, starting_z)
        running_vector = @adjacency_matrix[compute_index(starting_x, starting_y, starting_z)]
      else
        raise "Starting square occupied."
      end
    else
      running_vector = Vector.elements([0] * (@side ** 3), false)
    end

    @adjacencies ||= @box.goal_adjacencies.map { |ga| compute_index(*ga) }

    while !@box.partially_solved?
      best_idx = -1
      best_score = -1
      (@side ** 3).times do |row_idx|
        next if row_idx == goal_idx
        next if running_vector[row_idx] > 0
        next if @adjacency_matrix[goal_idx][row_idx] > 0
        next unless check_adjacencies(@adjacency_matrix[row_idx])

        candidate_vector = vector_or(running_vector, @adjacency_matrix[row_idx])
        score = @adjacencies.inject(0) { |sum, i| sum + candidate_vector[i] }
        if score > best_score
          best_idx = row_idx
          best_score = score
        end
      end

      unless best_idx < 0
        unless @box.occupy(*decompose_index(best_idx))
          puts "**************************************************************"
          puts "*** Failed to move to (#{decompose_index(best_idx).join(', ')})!"
          puts "*** #{running_vector[best_idx]}"
          puts "**************************************************************"
        end
        running_vector = vector_or(running_vector, @adjacency_matrix[best_idx])
        score = @adjacencies.inject(0) { |sum, i| sum + running_vector[i] }
        puts "Moved to (#{decompose_index(best_idx).join(', ')}) (#{vector_val(running_vector)}/#{@side ** 3}) (#{score})."
        puts running_vector if options[:verbose]

        if @box.partially_solved?
          puts "**************************************************************"
          puts "*******                   VICTORY                     ********"
          puts "**************************************************************"
          break
        end
      else
        puts "No valid moves remaining. :("
        break
      end
    end

    puts "Final state: #{@box}"

    running_vector
  end

  private

  def check_adjacencies(test_vector)
    @adjacencies.inject(false) { |bool, a| bool || (test_vector[a] > 0) }
  end

  def decompose_index(idx)
    x = idx % @side
    y = (idx / @side) % @side
    z = idx / (@side * @side)

    [x, y, z]
  end

  def compute_index(x, y, z)
    x + y * @side + z * @side * @side
  end

  def vector_or(vector1, vector2)
    (vector1 + vector2).map { |i| i > 0 ? 1 : 0 }
  end

  def vector_val(vector)
    vector.inject(0) { |sum, i| sum + i }
  end
end
