#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "math.h"
#include <stdio.h>
#include <time.h>

int generate_numbers(int range, int range_sqrt) {
    int* numbers;
    size_t bytes = range * sizeof(int);
    cudaMallocManaged(&numbers, bytes);

    for (int i = 2; i <= range; i++) {
        numbers[i] = 1;
    }
    
    for (int i = 2; i <= range_sqrt; i++) {
        if (numbers[i] == 1) {
            int temp_val = i * 2;
            while (temp_val <= range) {
                numbers[temp_val] = 0;
                temp_val += i;
            }
        }
    }

    int counter = 0;
    for (int i = 2; i <= range; i++) {
        if (numbers[i] == 1) {
            counter += 1;
        }
    }
    return counter;
}

int main(int argc, char* argv[]) {
    int range = atoi(argv[1]);
    int range_sqrt = sqrt(range);
    clock_t start, end;
    double total_time;

    //sito
    start = clock();
    int counter = 0;
    counter = generate_numbers(range, range_sqrt);
    end = clock();
    total_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Primes in total: %d\n", counter);
    printf("Time: %f, Range: %d\n", total_time, range);

    return 0;
}