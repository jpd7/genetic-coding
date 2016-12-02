# OP A B means A = A `OP` B

# TODO:
#  * SUB
#  * more output operations
#  * bitwise operations
#  * some sort of stack?
#  * some sort of heap?
#  * pointers
#  * floating point numbers
#  * rewrite in something faster?

NUM_REG = 8

LOAD = 'load'
MOV  = 'mov'
ADD  = 'add'
MUL  = 'mul'
DIV  = 'div'
MOD  = 'mod'
CMP  = 'cmp'
JMP  = 'jmp'
JIF  = 'jif'
HALT = 'halt'

INSTRUCTIONS = [
  LOAD, MOV, ADD, MUL, DIV, MOD, CMP, JMP, JIF, HALT
]

COMPARISON_TYPES = ['g', 'e', 'eg', 'l', 'lg', 'le']

def bad_instruction type
  raise "Unrecognized instruction type: " + type
end

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
    when LOAD
      reg[a] = b
    when MOV
      reg[a] = reg[b]
    when ADD
      reg[a] += reg[b]
    when MUL
      reg[a] *= reg[b]
    when DIV
      return nil if reg[b] == 0
      reg[a] /= reg[b]
    when MOD
      return nil if reg[b] == 0
      reg[a] %= reg[b]
    when CMP
      cr = compare reg[a], reg[b]
    when JMP
      pc += a
    when JIF
      pc += a if b.include? cr
    when HALT
      return reg[7]
    else
      bad_instruction op
    end
  }

  nil
end
