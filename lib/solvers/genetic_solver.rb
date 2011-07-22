require File.join(File.dirname(__FILE__), 'genetic_solver_gene')

class GeneticSolver
  MUTATION_RATE = 0.025

  attr_reader :x, :y, :z, :side, :limit, :population_size, :population, :current_generation

  def initialize(x, y, z, side, limit, population_size)
    @x = x
    @y = y
    @z = z
    @side = side
    @limit = limit
    @population_size = population_size + population_size % 2
    @population = (1..@population_size).map { SolverGene.new(@x, @y, @z, @side, @limit) }
    @current_generation = 0
  end

  def prune_generation
    fitnesses = []
    @population.each do |individual|
      individual.evaluate_fitness
      fitnesses << individual
    end
    fitnesses.sort! { |a, b| b.fitness <=> a.fitness }
    @population = fitnesses[0, (fitnesses.count / 2)]

    @population.count
  end

  def run(generations = 10)
    generations.times do |g|
      run_generation
    end
    @population[0].box
  end

  def run_generation
    @current_generation += 1
    to_generate = (@population_size - prune_generation) / 2
    to_generate.times do |i|
      o1, o2 = mate_pair(@population[i * 2], @population[i * 2 + 1])
      @population << o1
      @population << o2
    end
    display_generation
  end

  def display_generation
    puts "-----------------------------------"
    puts "Generation ##{@current_generation}"
    @population.each_with_index do |p, i|
      if p.fitness
        puts "\t#{i}:  #{p.fitness}"
      end
    end
    puts "-----------------------------------"
  end

  def mate_pair(a, b)
    o1 = SolverGene.new(@x, @y, @z, @side, @limit)
    o2 = SolverGene.new(@x, @y, @z, @side, @limit)

    gene_size = o1.genes.count
    crossover_point = rand(gene_size - 1) + 1
    o1.genes = a.genes[0, crossover_point] + b.genes[crossover_point, gene_size]
    o2.genes = b.genes[0, crossover_point] + a.genes[crossover_point, gene_size]

    if rand < MUTATION_RATE || (a.genes == b.genes && rand < 0.5)
      o1.genes[rand(gene_size)] = [rand(side), rand(side), rand(side)]
      puts "                                                                      (mutation)"
    end
    if rand < MUTATION_RATE || (a.genes == b.genes && rand < 0.5)
      o2.genes[rand(gene_size)] = [rand(side), rand(side), rand(side)]
      puts "                                                                      (mutation)"
    end

    [o1, o2]
  end
end
