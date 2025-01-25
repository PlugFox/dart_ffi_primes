import 'dart:math' as math;
import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Finds prime numbers in the range from [start] to [end] inclusive.
/// Using Dart implementation and the sieve of Eratosthenes algorithm.
@internal
List<int> primesDart(int start, int end) {
  if (start > end || start < 0 || end < 0) {
    throw ArgumentError('Invalid range: start=$start, end=$end');
  }

  // Оптимизированное решето с уменьшенным размером
  final sieveSize = (end ~/ 2) + 1;
  final sieve = Uint8List(sieveSize);

  // Помечаем четные числа, кроме 2
  final to = math.sqrt(end).ceil();
  for (var i = 3; i <= to; i += 2) {
    if (sieve[i ~/ 2] == 0) {
      for (var j = i * i; j <= end; j += 2 * i) {
        sieve[j ~/ 2] = 1;
      }
    }
  }

  // Подсчет простых чисел
  var count = (start <= 2 && end >= 2) ? 1 : 0;
  for (var i = (start % 2 == 0 ? start + 1 : start); i <= end; i += 2) {
    if (sieve[i ~/ 2] == 0) {
      count++;
    }
  }

  // Создание массива простых чисел
  final primes = Uint32List(count);
  var index = 0;

  // Добавляем 2, если он в диапазоне
  if (start <= 2 && end >= 2) {
    primes[index++] = 2;
  }

  // Заполнение массива простыми числами
  for (var i = (start % 2 == 0 ? start + 1 : start); i <= end; i += 2) {
    if (sieve[i ~/ 2] == 0) {
      primes[index++] = i;
    }
  }

  return primes;
}
