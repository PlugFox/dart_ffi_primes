#ifndef PRIME_H
#define PRIME_H

#include <stdint.h> // For uint32_t

// Define a macro for function export
#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default")))
#endif

// Function to compute prime numbers
// `result` - pointer to an array allocated by the caller
// `count`  - pointer where the number of found primes will be stored
EXPORT /* DART_EXPORT */ int get_primes(
    uint32_t start,
    uint32_t end,
    uint32_t** result,
    uint32_t* count);

#endif // PRIME_H
