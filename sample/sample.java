package sample;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class sample {
    public static boolean isPrime(int n) {
        if (n < 2) return false;
        if (n == 2) return true;
        if (n % 2 == 0) return false;
        for (int i = 3; i * i <= n; i += 2) {
            if (n % i == 0) return false;
        }
        return true;
    }

    public static int findNthPrime(int n) {
        int count = 0, num = 1;
        while (count < n) {
            num++;
            if (isPrime(num)) count++;
        }
        return num;
    }

    public static void main(String[] args) {
        long startTime = System.nanoTime();

        int nthPrime = findNthPrime(50000);
        
        long endTime = System.nanoTime() - startTime;
        double executionTimeMs = endTime / 1_000_000.0;

        System.out.println("El primo número 50000 es: " + nthPrime);
        System.out.println(executionTimeMs + " ms");
    }
}
