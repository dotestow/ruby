#!/usr/bin/ruby

# 2 x 2 matrices
# |a b|
# |c d|
# take form of array [a, b, c, d]

# Multiplies two 2 x 2 matrices
def mul(a, b)
  res = []
  res << a[0]*b[0] + a[1]*b[2]
  res << a[0]*b[1] + a[1]*b[3]
  res << a[2]*b[0] + a[3]*b[2]
  res << a[2]*b[1] + a[3]*b[3]
  res
end

# Computes n-th power of matrix
# |1 1|
# |1 0|
def matrix_power(n)
  base = [1, 1, 1, 0]
  res = [1, 0, 0, 1]
  matrix_2n = base
  
  while n > 0 do
    if n % 2 == 1
      res = mul(res, matrix_2n)
    end
    
    matrix_2n = mul(matrix_2n, matrix_2n)
    n >>= 1
  end
  
  res
end

# Computes n-th Fibonacci number using formula
#
# |1 1|^n   |Fib(n+1) Fib(n)  |
# |1 0|   = |Fib(n)   Fib(n-1)|
#
# http://en.wikipedia.org/wiki/Fibonacci_number#Matrix_form
def fibonacci(n)
  matrix_power(n)[1]
end

n = ARGV.first.to_i
puts fibonacci(n)
