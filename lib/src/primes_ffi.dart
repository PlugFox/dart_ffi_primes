import 'dart:ffi' as ffi;
import 'dart:io' as io;

import 'package:ffi/ffi.dart' as ffi;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import 'primes_ffi.g.dart';

PrimesLibrary? _lib;

/// Initializes the library.
@internal
PrimesLibrary initLibrary() {
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
        file = p.join(path, 'cprime.dll');
      } else {
        file = p.join(path, 'libcprime.so');
      }
      if (io.File(file).existsSync()) return file;
    }

    // Fallback to current path
    final candidates = io.Directory.current.listSync().whereType<io.File>().where((file) {
      if (io.Platform.isMacOS && file.path.endsWith('.dylib')) {
        return true;
      } else if (io.Platform.isWindows && file.path.endsWith('.dll')) {
        return true;
      } else if (file.path.endsWith('.so')) {
        return true;
      } else {
        return false;
      }
    }).where((file) => p.basename(file.path).contains('cprime'));
    final first = candidates.firstOrNull;
    if (first != null) return first.path;

    throw StateError('Library not found');
  }

  return _lib = PrimesLibrary(ffi.DynamicLibrary.open(getPath()));
}

/// Finds prime numbers in the range from [start] to [end] inclusive
@internal
List<int> primesFFI(int start, int end) {
  final lib = _lib ??= initLibrary();

  //final count = ffi.calloc<ffi.Uint32>();
  //final result = ffi.calloc<ffi.Pointer<ffi.Uint32>>(end - start + 1);
  //final result = ffi.malloc<ffi.Pointer<ffi.Uint32>>(end - start + 1);

  final arena = ffi.Arena();
  final count = arena<ffi.Uint32>();
  final result = arena<ffi.Pointer<ffi.Uint32>>(end - start + 1);

  try {
    final flag = lib.get_primes(start, end, result, count);
    if (flag != 0) throw Exception('Error calculating primes. Status: $flag');
    return result.value.asTypedList(count.value);
  } on Exception {
    rethrow;
  } finally {
    //ffi.calloc.free(count);
    //ffi.calloc.free(result);
    arena
      ..free(count)
      ..free(result);
  }
}
