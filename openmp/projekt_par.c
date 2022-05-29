#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>


int main(int argc, char * argv[]) {
    int threads_num = strtol(argv[1], NULL, 10);;
    int* numbers;
    int range = strtol(argv[2], NULL, 10);
    numbers = (int*)malloc(range * sizeof(int));
    int prime_counter = 0;
    numbers[0] = 0;
    numbers[1] = 0;
    FILE * file = fopen("primes.txt","w");

    double start = omp_get_wtime();

    omp_set_num_threads(threads_num);

    #pragma omp parallel for
    for (int i = 2; i < range; i++){
        numbers[i] = 1;
    }


    for (int i = 2; i < range; i++){
        if (numbers[i] == 1){
            fprintf(file, "%d\n", i);
            prime_counter += 1;
            int j = 0;
            int temp_val = i;
            for(int temp_val = i; temp_val < range; temp_val += i){
                numbers[temp_val] = 0;
            } 
        }
    }
    fclose(file);
    printf("zakres: %d\n", range);
    printf("liczba watkow: %d\n", threads_num);
    printf("liczby pierwsze w danym zakresie: %d\n", prime_counter);
    printf("%f\n", omp_get_wtime() - start);
}
