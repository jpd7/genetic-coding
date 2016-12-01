#!/usr/bin/ruby

require 'pp'

NUM_REG = 2

# OP A B stores in B

LOAD = :load
ADD  = :add
MUL  = :mul
NEG  = :neg
JMP  = :jmp
RET  = :ret
# PUSH = :push
# POP  = :pop
INSTRUCTIONS = [
  LOAD,
  ADD,
  MUL,
  NEG,
  JMP,
  RET,
]

def run_program prog, arg, limit=200
  reg = Array.new(NUM_REG, 0)
  pc = 0

  reg[0] = arg

  limit.times {
    return nil if pc < 0 or pc >= prog.size
    op, a, b = *prog[pc]
    pc += 1
    case op
    when LOAD then reg[b] = a
    when ADD then reg[b] += reg[a]
    when MUL then reg[b] *= reg[a]
    when NEG then reg[a] *= -1
    when JMP then pc += a
    when RET then return reg[a]
    end
  }

  nil
end

def signed_rand max
  rand(2 * max - 1) - max + 1
end

def random_instruction
  case INSTRUCTIONS.sample
  when LOAD then [LOAD, rand(2),       rand(NUM_REG)]
  when ADD  then [ADD,  rand(NUM_REG), rand(NUM_REG)]
  when MUL  then [MUL,  rand(NUM_REG), rand(NUM_REG)]
  when NEG  then [NEG,  rand(NUM_REG)]
  when JMP  then [JMP,  signed_rand(10)]
  when RET  then [RET,  rand(NUM_REG)]
  end
end

def random_program length=50
  Array.new(length) {random_instruction}
end

def mutate_program prog
  10.times {
    case rand 4
    when 0 then prog.delete_at rand(prog.size)
    when 1 then prog.insert rand(prog.size + 1), random_instruction
    when 2, 3
      instr = prog.sample
      case instr[0]
      when LOAD
        case rand 2
        when 0 then instr[1] += signed_rand 5
        when 1 then instr[2] = rand(NUM_REG)
        end
      when ADD, MUL
        case rand 2
        when 0 then instr[1] = rand(NUM_REG)
        when 1 then instr[2] = rand(NUM_REG)
        end
      when NEG, RET
        instr[1] = rand(NUM_REG)
      when JMP
        instr[1] += signed_rand 5
      end
    end
  }
end

def run_evolution num_generations,
                  population_size,
                  children_per_parent,
                  generate_individual,
                  mutate_individual,
                  score_individual
  population = Array.new(population_size) {
    individual = generate_individual.call
    score = score_individual.call individual
    [score, individual]
  }.sort_by {|x| x[0]}
  num_generations.times {
    pp population[0]; puts
    return population[0][1] if population[0][0] == 0
    population = (population + population.flat_map {|parent_score, parent|
                    Array.new(children_per_parent) {
                      child = mutate_individual.call parent
                      child_score = score_individual.call child
                      [child_score, child]
                    }
                  }).sort_by {|x| x[0]}[0...population_size]
  }
  nil
end

solution = run_evolution 10,
                         50,
                         2,
                         lambda {random_program 20},
                         lambda {|prog| mutate_program prog.map(&:dup)},
                         lambda {|prog|
  100.times.map {|n|
    result = run_program(prog, n)
    result ? (n * n + 1 - result).abs : 9999999999
  }.reduce(&:+)
}

if solution
  p solution
else
  puts "Failed"
end
