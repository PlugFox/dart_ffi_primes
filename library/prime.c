#include "prime.h"
#include <stdbool.h> // Для типа bool
#include <stdlib.h>  // Для malloc

// Реализация функции вычисления простых чисел
int get_primes(uint32_t start, uint32_t end, uint32_t** result, uint32_t* count) {
    if (start > end || !result || !count) {
        return -1; // Ошибка: неправильные аргументы
    }

    // Создаём массив для решета
    uint8_t* sieve = calloc(end + 1, sizeof(uint8_t));
    if (!sieve) {
        return -2; // Ошибка: недостаточно памяти
    }

    sieve[0] = 1; // 0 не простое число
    if (end > 0) sieve[1] = 1; // 1 тоже не простое

    for (uint32_t i = 2; i * i <= end; i++) {
        if (sieve[i] == 0) {
            for (uint32_t j = i * i; j <= end; j += i) {
                sieve[j] = 1; // Отмечаем как составное
            }
        }
    }

    // Подсчитываем количество простых чисел
    *count = 0;
    for (uint32_t i = start; i <= end; i++) {
        if (sieve[i] == 0) {
            (*count)++;
        }
    }

    // Выделяем память для массива простых чисел
    *result = malloc(*count * sizeof(uint32_t));
    if (!*result) {
        free(sieve);
        return -2; // Ошибка: недостаточно памяти
    }

    // Заполняем массив простыми числами
    uint32_t index = 0;
    for (uint32_t i = start; i <= end; i++) {
        if (sieve[i] == 0) {
            (*result)[index++] = i;
        }
    }

    free(sieve); // Освобождаем память для решета
    return 0;    // Успешное выполнение
}
