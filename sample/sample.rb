require 'time'

def is_prime(n)
    return false if n < 2
    return true if n == 2
    return false if n.even?
    (3..Math.sqrt(n)).step(2).each do |i|
        return false if n % i == 0
    end
    true
end

def find_nth_prime(n)
    count, num = 0, 1
    while count < n
        num += 1
        count += 1 if is_prime(num)
    end
    num
end

start_time = Time.now
nth_prime = find_nth_prime(50000)
execution_time = (Time.now - start_time) * 1000

puts "El primo número 50000 es: #{nth_prime}"
puts "#{execution_time.round(6)} ms"