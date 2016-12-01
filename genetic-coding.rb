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

def random_program length=50
  Array.new(length) {
    case INSTRUCTIONS.sample
    when LOAD then [LOAD, rand(2),       rand(NUM_REG)]
    when ADD  then [ADD,  rand(NUM_REG), rand(NUM_REG)]
    when MUL  then [MUL,  rand(NUM_REG), rand(NUM_REG)]
    when NEG  then [NEG,  rand(NUM_REG)]
    when JMP  then [JMP,  -10 + rand(20)]
    when RET  then [RET,  rand(NUM_REG)]
    end
  }
end

10000.times {
  prog = random_program 4
  if 100.times.all? {|n| run_program(prog, n) == n * n + 1}
    pp prog
    exit
  end
}
puts "Failed"
