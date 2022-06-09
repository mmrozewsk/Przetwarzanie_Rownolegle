#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <device_functions.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "math.h"

__global__ void generate_numbers(int range, int* numbers, int range_sqrt) {

    int beg = threadIdx.x * range / blockDim.x;
    int end = (threadIdx.x + 1) * range / blockDim.x - 1;

    //jedynki
    numbers[2] = 1;
    for (int i = beg; i <= end; i++) {
        if (i > 1 && i%2 == 1)
            numbers[i] = 1;
    }

    __syncthreads();
    //sito
    if (threadIdx.x == blockDim.x - 1) {

        for (int i = 3; i <= range_sqrt; i += 2) {
            if (numbers[i] == 1) {
                int temp_val = i * 2;
                while (temp_val <= range) {
                    numbers[temp_val] = 0;
                    temp_val += i;
                }
            }
        }
    }

    int counter = 0;
    __syncthreads();
    //zliczanie
    for (int i = beg; i <= end; i++) {
        if (numbers[i] == 1) {
            counter += 1;
        }
    }

    __shared__ int counters[8];
    counters[threadIdx.x] = counter;
    __syncthreads();
    //wynik
    if (threadIdx.x == blockDim.x - 1) {
        counter = 0;
        for (int i = 0; i < blockDim.x; i++) {
            counter += counters[i];
        }
        printf("Primes in total: %d\n", counter);
    }

    __syncthreads();

}

int main(int argc, char* argv[]) {
    int range = atoi(argv[1]);
    int threads = atoi(argv[2]);
    int range_sqrt = sqrt(range);
    clock_t start_time, end_time;

    double total_time;

    int* numbers;
    size_t mem = range * sizeof(int);
    cudaMallocManaged(&numbers, mem);

    dim3 THREADS(threads, threads);
    start_time = clock();
    generate_numbers << <1, threads, threads * sizeof(int) >> > (range, numbers, range_sqrt);
    cudaDeviceSynchronize();
    end_time = clock();
    total_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("Time: %f, Range: %d, Threads:%d\n", total_time, range, threads);

    return 0;
}