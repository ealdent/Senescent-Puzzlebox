require File.join(File.dirname(__FILE__), '..', 'puzzle_box')

class GeneticSolverGene
  attr_accessor :genes, :fitness
  attr_reader :x, :y, :z, :side, :limit, :box

  def initialize(x, y, z, side, limit)
    @x = x
    @y = y
    @z = z
    @side = side
    @limit = limit
    @fitness = -1
    @genes = self.class.generate_random_gene(side, limit)
    @box = PuzzleBox.new(x, y, z, side)
  end

  def evaluate_fitness
    total_score = @side ** 3
    bad_genes = 0
    @genes.each_with_index do |gene, i|
      if !@box.occupy(*gene)
        bad_genes += 1
      end

      if @box.solved?
        puts "Box solved in #{i} moves: #{@genes[0,i].inspect}"
      end
    end
    @fitness = (@box.good_points / total_score.to_f) #+ ((@limit - bad_genes) / @limit.to_f)
  end

  class << self
    def generate_random_gene(side, limit)
      # (x,y,z) = z * y0 * x0 + y * x0 + x
      gene = []

      limit.times do
        x = rand(side)
        y = rand(side)
        z = rand(side)
        gene << [x, y, z]
      end
      
      gene
    end
  end
end
