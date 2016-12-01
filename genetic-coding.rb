#!/usr/bin/ruby

require 'pp'

NUM_REG = 8

# OP A B stores in B

LOAD = :load
ADD  = :add
MUL  = :mul
NEG  = :neg
JMP  = :jmp
RET  = :ret
# PUSH = :push
# POP  = :pop

def run_program prog, limit=1000
  reg = Array.new(NUM_REG, 0)
  pc = 0

  limit.times {
    return nil if pc < 0 or pc >= prog.size
    op, a, b = *prog[pc]
    pc += 1
    case op
    when LOAD then reg[b] = a
    when ADD then reg[b] += reg[a]
    when MUL then reg[b] *= reg[a]
    when NEG then reg[a] *= -1
    when JMP then pc += reg[a]
    when RET then return reg[a]
    end
  }

  nil
end

def random_program length=50
  Array.new(50) {
    case rand 6
    when 0 then [LOAD, rand(100), rand(NUM_REG)]
    when 1 then [ADD, rand(NUM_REG), rand(NUM_REG)]
    when 2 then [MUL, rand(NUM_REG), rand(NUM_REG)]
    when 3 then [NEG, rand(NUM_REG)]
    when 4 then [JMP, -10 + rand(20)]
    when 5 then [RET, rand(NUM_REG)]
    end
  }
end

# p run_program [
#     [LOAD, 3, 0],
#     [MUL, 0, 0],
#     [RET,  0],
# ]

prog = random_program
pp prog
p run_program(prog)
