library;

import 'src/primes_dart.dart';
import 'src/primes_ffi.dart';

/// Finds prime numbers in the range from [start] to [end] inclusive.
/// Using the sieve of Eratosthenes algorithm.
/// If [dart] is true, then the Dart implementation is used.
/// Otherwise, the FFI implementation is used.
List<int> primes(int start, int end, {bool dart = false}) => dart ? primesDart(start, end) : primesFFI(start, end);
