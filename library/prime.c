#include "prime.h"
#include <stdbool.h>
#include <stdlib.h>
#include <math.h>

// Hint to the compiler for optimization
#ifdef _MSC_VER
#define HOT_FUNCTION
#else
#define HOT_FUNCTION __attribute__((hot))
#endif

// A macro for safe memory allocation
#define SAFE_MALLOC(ptr, size) do { \
    (ptr) = malloc(size); \
    if (!(ptr)) return -2; \
} while(0)

// Function to compute prime numbers
HOT_FUNCTION
int get_primes(uint32_t start, uint32_t end, uint32_t** result, uint32_t* count) {
    if (start > end || !result || !count) {
        return -1;
    }

    // Optimization: reduce the size of the sieve
    uint32_t sieve_size = (end / 2) + 1;
    uint8_t* sieve = calloc(sieve_size, sizeof(uint8_t));
    if (!sieve) {
        return -2;
    }

    // Mark even numbers, except 2
    uint32_t to = sqrt(end);
    for (uint32_t i = 3; i <= to; i += 2) {
        // Skip only odd multiples
        if ((sieve[i/2] & 1) == 0) {
            for (uint32_t j = i * i; j <= end; j += 2 * i) {
                sieve[j/2] |= 1;
            }
        }
    }

    // Count the number of prime numbers
    *count = (start <= 2 && end >= 2) ? 1 : 0;
    for (uint32_t i = (start % 2 == 0 ? start + 1 : start);
         i <= end; i += 2) {
        if ((sieve[i/2] & 1) == 0) {
            (*count)++;
        }
    }

    // Memory allocation
    SAFE_MALLOC(*result, *count * sizeof(uint32_t));
    if (!*result) {
        free(sieve);
        return -2;
    }

    // Filling the array of prime numbers
    uint32_t index = 0;
    if (start <= 2 && end >= 2) {
        (*result)[index++] = 2;
    }

    for (uint32_t i = (start % 2 == 0 ? start + 1 : start);
         i <= end; i += 2) {
        if ((sieve[i/2] & 1) == 0) {
            (*result)[index++] = i;
        }
    }

    free(sieve);
    return 0;
}
