function isPrime(n) {
    if (n < 2) return false;
    if (n === 2) return true;
    if (n % 2 === 0) return false;
    for (let i = 3; i * i <= n; i += 2) {
        if (n % i === 0) return false;
    }
    return true;
}

function findNthPrime(n) {
    let count = 0, num = 1;
    while (count < n) {
        num++;
        if (isPrime(num)) count++;
    }
    return num;
}

const startTime = performance.now();
const nthPrime = findNthPrime(50000);
const executionTime = performance.now() - startTime;

console.log(`El primo número 50000 es: ${nthPrime}`);
console.log(`${executionTime.toFixed(6)} ms`);
