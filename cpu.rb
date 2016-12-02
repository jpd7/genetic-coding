NUM_REG = 8

# OP A B means A = A `OP` B

# TODO:
#  * SUB
#  * more output operations
#  * bitwise operations
#  * some sort of stack?
#  * floating point numbers

LOAD = 'load'
ADD  = 'add'
MUL  = 'mul'
DIV  = 'div'
MOD  = 'mod'
CMP  = 'cmp'
JMP  = 'jmp'
JIF  = 'jif'
DONE = 'done'

INSTRUCTIONS = [
  LOAD, ADD, MUL, DIV, MOD, CMP, JMP, JIF, DONE
]

COMPARISON_TYPES = ['g', 'e', 'eg', 'l', 'lg', 'le']

def compare a, b
  case
  when a < b then 'l'
  when a == b then 'e'
  else 'g'
  end
end

def run_program prog, arg, limit
  reg = Array.new(NUM_REG, 0)
  pc = 0
  cr = ''

  reg[0] = arg

  limit.times {
    return nil if pc < 0 or pc >= prog.size
    op, a, b = *prog[pc]
    pc += 1
    case op
    when LOAD then reg[a] = b
    when ADD then reg[a] += reg[b]
    when MUL then reg[a] *= reg[b]
    when DIV
      return nil if reg[b] == 0
      reg[a] /= reg[b]
    when MOD
      return nil if reg[b] == 0
      reg[a] %= reg[b]
    when CMP then cr = compare reg[a], reg[b]
    when JMP then pc += a
    when JIF then pc += a if b.include? cr
    when DONE then return reg[7]
    end
  }

  nil
end
