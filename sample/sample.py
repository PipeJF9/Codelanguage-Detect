import time

def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(n**0.5) + 1, 2):
        if n % i == 0:
            return False
    return True

def find_nth_prime(n):
    count, num = 0, 1
    while count < n:
        num += 1
        if is_prime(num):
            count += 1
    return num

start_time = time.time()
nth_prime = find_nth_prime(50000)
execution_time = (time.time() - start_time) * 1000

print(f"El primo número 50000 es: {nth_prime}")
print(f"{execution_time:.6f} ms")
