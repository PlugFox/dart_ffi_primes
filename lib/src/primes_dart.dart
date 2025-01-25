import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Finds prime numbers in the range from [start] to [end] inclusive.
/// Using Dart implementation and the sieve of Eratosthenes algorithm.
@internal
List<int> primesDart(int start, int end) {
  if (start > end || start < 0 || end < 0) {
    throw ArgumentError('Invalid range: start=$start, end=$end');
  }

  // Решето Эратосфена
  final sieve = Uint8List(end + 1); // Флаг для чисел
  sieve[0] = 1; // 0 не простое число
  if (end > 0) sieve[1] = 1; // 1 тоже не простое

  for (var i = 2; i * i <= end; i++) {
    if (sieve[i] == 0) {
      for (var j = i * i; j <= end; j += i) {
        sieve[j] = 1; // Отмечаем как составное
      }
    }
  }

  // Подсчитываем количество простых чисел в диапазоне
  var count = 0;
  for (var i = start; i <= end; i++) {
    if (sieve[i] == 0) {
      count++;
    }
  }

  // Создаём массив точного размера для простых чисел
  final primes = Uint32List(count);
  var index = 0;

  // Заполняем массив простыми числами
  for (var i = start; i <= end; i++) {
    if (sieve[i] == 0) {
      primes[index++] = i;
    }
  }

  return primes;
}
