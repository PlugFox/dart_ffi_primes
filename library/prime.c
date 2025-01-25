#include "prime.h"
#include <stdbool.h> // Для типа bool
#include <stdlib.h>  // Для malloc

// Макрос для безопасного выделения памяти
#define SAFE_MALLOC(ptr, size) do { \
    (ptr) = malloc(size); \
    if (!(ptr)) return -2; \
} while(0)

// Функция для вычисления простых чисел
__attribute__((hot)) // Подсказка компилятору для оптимизации
int get_primes(uint32_t start, uint32_t end, uint32_t** result, uint32_t* count) {
    if (start > end || !result || !count) {
        return -1;
    }

    // Оптимизация: уменьшаем размер решета
    uint32_t sieve_size = (end / 2) + 1;
    uint8_t* sieve = calloc(sieve_size, sizeof(uint8_t));
    if (!sieve) {
        return -2;
    }

    // Помечаем четные числа, кроме 2
    for (uint32_t i = 3; i * i <= end; i += 2) {
        if ((sieve[i/2] & 1) == 0) {
            // Пропускаем только нечетные кратные
            for (uint32_t j = i * i; j <= end; j += 2 * i) {
                sieve[j/2] |= 1;
            }
        }
    }

    // Подсчет количества простых чисел
    *count = (start <= 2 && end >= 2) ? 1 : 0;
    for (uint32_t i = (start % 2 == 0 ? start + 1 : start);
        i <= end; i += 2) {
        if ((sieve[i/2] & 1) == 0) {
            (*count)++;
        }
    }

    // Выделение памяти
    SAFE_MALLOC(*result, *count * sizeof(uint32_t));
    if (!*result) {
        free(sieve);
        return -2;
    }

    // Заполнение массива простых чисел
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