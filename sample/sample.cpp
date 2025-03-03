#include <iostream>
#include <cmath>
#include <chrono>

bool isPrime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;
    for (int i = 3; i * i <= n; i += 2) {
        if (n % i == 0) return false;
    }
    return true;
}

int findNthPrime(int n) {
    int count = 0, num = 1;
    while (count < n) {
        num++;
        if (isPrime(num)) count++;
    }
    return num;
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    int nthPrime = findNthPrime(50000);
    auto end = std::chrono::high_resolution_clock::now();
    double executionTime = std::chrono::duration<double, std::milli>(end - start).count();

    std::cout << "El primo número 50000 es: " << nthPrime << std::endl;
    std::cout << executionTime << " ms" << std::endl;
    return 0;
}