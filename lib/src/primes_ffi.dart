import 'dart:ffi' as ffi;
import 'dart:io' as io;

import 'package:ffi/ffi.dart' as ffi;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import 'primes_ffi.g.dart';

PrimesLibrary? _lib;

/// Initializes the library.
void initLibrary() {
  String getPath() {
    final currentPath = io.Directory.current.absolute.path;

    final possiblePaths = [
      currentPath,
      p.join(currentPath, 'build/'),
      p.join(currentPath, 'assets/'),
      p.join(currentPath, 'build', 'assets/'),
    ];
    for (final path in possiblePaths) {
      if (!io.Directory(path).existsSync()) continue;
      final String file;
      if (io.Platform.isMacOS) {
        file = p.join(path, 'libcprime.dylib');
      } else if (io.Platform.isWindows) {
        file = p.join(path, 'Debug', 'cprime.dll');
      } else {
        file = p.join(path, 'libcprime.so');
      }
      if (io.File(file).existsSync()) return file;
    }
    throw StateError('Library not found');
  }

  _lib = PrimesLibrary(ffi.DynamicLibrary.open(getPath()));
}

/// Finds prime numbers in the range from [start] to [end] inclusive
@internal
List<int> primesFFI(int start, int end) {
  final lib = _lib ?? (throw StateError('Library not initialized'));
  final count = ffi.calloc<ffi.Uint32>();
  final result = ffi.calloc<ffi.Pointer<ffi.Uint32>>();

  try {
    final flag = lib.get_primes(start, end, result, count);
    if (flag != 0) throw Exception('Error calculating primes. Status: $flag');
    final countValue = count.value;
    return result.value.asTypedList(countValue);
  } on Exception {
    rethrow;
  } finally {
    ffi.calloc.free(count);
    ffi.calloc.free(result);
  }
}
