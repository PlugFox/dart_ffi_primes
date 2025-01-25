#include <stdio.h>
#include <stdlib.h>
#include <string.h> // Для strcat

#include "prime.h"

// Точка входа в программу
// Вызывает функцию get_primes и выводит результат на экран
// Пример использования библиотеки:
// $ mkdir build
// $ gcc -o build/main library/main.c library/prime.c
// $ ./build/main
int main() {
    uint32_t start = 1000, end = 5000;
    uint32_t* primes = NULL;  // Указатель на массив простых чисел
    uint32_t count = 0;       // Количество найденных чисел

    // Вызываем функцию
    int status = get_primes(start, end, &primes, &count);

    if (status != 0) {
        printf("Failed to calculate primes. Error code: %d\n", status);
        return 1;
    }

    // Создаём буфер для вывода
    const size_t buffer_size = count * 12; // Выделяем память: максимум 11 символов на число + пробел
    char* buffer = malloc(buffer_size);
    if (!buffer) {
        printf("Failed to allocate buffer memory.\n");
        free(primes);
        return 1;
    }

    buffer[0] = '\0'; // Инициализируем пустую строку

    // Заполняем буфер числами
    for (uint32_t i = 0; i < count; i++) {
        char temp[12]; // Временный буфер для одного числа
        snprintf(temp, sizeof(temp), "%u ", primes[i]);
        strcat(buffer, temp); // Добавляем число в общий буфер
    }

    printf("Found %u primes:\n%s\n", count, buffer);

    // Освобождаем память
    free(buffer);
    free(primes);
    return 0;
}