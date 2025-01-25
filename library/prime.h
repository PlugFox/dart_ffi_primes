#ifndef PRIME_H
#define PRIME_H

#include <stdint.h> // Для uint32_t

// Определяем макрос для экспорта функций
#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT __attribute__((visibility("default")))
#endif

// Функция для вычисления простых чисел
// `result` - указатель на массив, выделенный вызывающей стороной
// `count`  - указатель, куда будет записано количество найденных чисел
EXPORT /* DART_EXPORT */ int get_primes(
    uint32_t start,
    uint32_t end,
    uint32_t** result,
    uint32_t* count);

#endif // PRIME_H
