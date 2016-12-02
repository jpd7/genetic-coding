NUM_REG = 8

# OP A B stores in B

# TODO:
#  * DIV
#  * SUB
#  * conditional jumps
#  * more output operations
#  * bitwise operations
#  * some sort of stack?

LOAD = 'load'
ADD  = 'add'
MUL  = 'mul'
# JMP  = 'jmp'
RET  = 'ret'
# PUSH = 'push'
# POP  = 'pop'
INSTRUCTIONS = [
  LOAD,
  ADD,
  MUL,
  # JMP,
  RET,
]

def run_program prog, arg, limit
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
    # when JMP then pc += a
    when RET then return reg[a]
    end
  }

  nil
end
