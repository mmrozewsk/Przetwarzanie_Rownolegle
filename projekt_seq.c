#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>


int main(int argc, char * argv[]) {
    int* numbers;
    int range = strtol(argv[1], NULL, 10);
    numbers = (int*)malloc(range * sizeof(int));
    // int numbers[range];
    int prime_counter = 0;
    numbers[0] = 0;
    numbers[1] = 0;
    FILE * file = fopen("primes.txt","w");

    double start = omp_get_wtime();
    for (int i = 2; i < range; i++){
        numbers[i] = 1;
    }


    for (int i = 2; i < range; i++){
        if (numbers[i] == 1){
            fprintf(file, "%d\n", i);
            prime_counter += 1;
            int j = 0;
            int temp_val = i;
            while(temp_val < range){
                numbers[temp_val] = 0;
                temp_val += i;
            } 
        }
    }
    fclose(file);
    printf("zakres: %d\n", range);
    printf("liczby pierwsze w danym zakresie: %d\n", prime_counter);
    printf("%f\n", omp_get_wtime() - start);
}
