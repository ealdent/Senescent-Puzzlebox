require File.join(File.dirname(__FILE__), 'solver')
require 'matrix'

class RandomSolver < Solver
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

    while !@box.solved?
      row_idx = rand(@side ** 3)
      next if row_idx == goal_idx
      next if running_vector[row_idx] > 0
      next if @adjacency_matrix[goal_idx][row_idx] > 0

      if @box.occupy(*decompose_index(row_idx))
        running_vector = vector_or(running_vector, @adjacency_matrix[row_idx])
        puts "Moved to (#{decompose_index(row_idx).join(', ')}) (#{vector_val(running_vector)}/#{@side ** 3})."
        puts running_vector if options[:verbose]
      end

      if @box.solved?
        puts "**************************************************************"
        puts "*******                   VICTORY                     ********"
        puts "**************************************************************"
        break
      end
    end

    puts "Final state: #{@box}"

    running_vector
  end

  private

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
