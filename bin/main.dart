import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dart_ffi_primes/primes.dart';

/// How to run:
/// $ dart run bin/main.dart -s 1 -e 100
///
/// $ mkdir build
/// $ dart compile exe bin/main.dart -o build/primes.exe
/// $ ./build/primes.exe -s 1 -e 100
void main(List<String> arguments) {
  final argParser = ArgParser()
    ..addOption('start', abbr: 's', defaultsTo: '1')
    ..addOption('end', abbr: 'e', defaultsTo: '100')
    ..addFlag('help', abbr: 'h', defaultsTo: false, negatable: false);

  final argResult = argParser.parse(arguments);

  if (argResult['help'] == true) {
    io.stdout.writeln(argParser.usage);
    return;
  }

  final start = int.tryParse(argResult.option('start') ?? '1') ?? 1;
  final end = int.tryParse(argResult.option('end') ?? '100') ?? 100;

  io.stdout.writeln('Finding primes between $start and $end');

  final dart = _BenchmarkDart(start, end);
  final ffi = _BenchmarkFfi(start, end);

  final usDart = dart.measure();
  final usFfi = ffi.measure();

  io.stdout
    ..writeln('Dart find ${dart.result.length} primes in ${usDart.toStringAsFixed(2)} us.')
    ..writeln('FFI find ${ffi.result.length} primes in ${usFfi.toStringAsFixed(2)} us.')
    ..writeln('${usDart < usFfi ? 'Dart' : 'FFI'} '
        'is ${(usDart < usFfi ? usFfi / usDart : usDart / usFfi).toStringAsFixed(2)}x faster');
}

final class _BenchmarkDart extends BenchmarkBase {
  _BenchmarkDart(this.start, this.end) : super('Dart primes');

  final int start, end;
  List<int>? _result;
  List<int> get result => _result ?? const [];

  @override
  void run() {
    _result = primes(start, end, dart: true);
  }

  @override
  void teardown() {
    super.teardown();
    final result = _result;
    if (result == null) throw StateError('No result');
  }
}

final class _BenchmarkFfi extends BenchmarkBase {
  _BenchmarkFfi(this.start, this.end) : super('FFI primes');

  final int start, end;
  List<int>? _result;
  List<int> get result => _result ?? const [];

  @override
  void run() {
    _result = primes(start, end, dart: false);
  }

  @override
  void teardown() {
    super.teardown();
    final result = _result;
    if (result == null) throw StateError('No result');
  }
}
