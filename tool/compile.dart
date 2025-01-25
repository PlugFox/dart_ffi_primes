import 'dart:io' as io;

import 'package:path/path.dart' as p;

/// Compiles the C library using CMake.
/// $ dart run tool/compile.dart
void main() => Future<void>(() {
      // Get the current directory and create the assets directory
      final assets = io.Directory(p.join(io.Directory.current.path, 'assets/'));
      if (!assets.existsSync()) assets.createSync(recursive: true);

      // Run the CMake build
      runCMakeBuild();

      // Copy the compiled library to the assets directory
      final names = <String>{'libcprime.dylib', 'libcprime.so', 'cprime.dll'};

      final files = io.Directory('build')
          .listSync(recursive: true, followLinks: false)
          .whereType<io.File>()
          .where((f) => names.contains(p.basename(f.path)));

      for (final file in files) file.copySync(p.normalize(p.join(assets.path, p.basename(file.path))));
    });

Future<void> runCMakeBuild() async {
  final buildDir = io.Directory('build');
  final env = {
    ...io.Platform.environment,
    // Use GCC on macOS from Homebrew
    //if (io.Platform.isMacOS) ...{
    //  'CC': 'gcc-14',
    //  'CXX': 'g++-14',
    //},
  };

  // Создаём директорию для сборки, если её нет
  if (!buildDir.existsSync()) buildDir.createSync();

  // Первая команда: cmake -B build ../library
  final cmakeGenerate = await io.Process.run(
    'cmake',
    ['library', '-B', 'build'],
    runInShell: true,
    environment: env,
  );

  if (cmakeGenerate.exitCode != 0) {
    io.stderr
      ..writeln('Error running CMake generate step:')
      ..writeln(cmakeGenerate.stdout)
      ..writeln(cmakeGenerate.stderr);
    io.exit(cmakeGenerate.exitCode);
  } else {
    io.stdout
      ..writeln('CMake generation completed:')
      ..writeln(cmakeGenerate.stdout);
  }

  // Вторая команда: cmake --build build -- -j$(nproc)
  final threads = io.Platform.isWindows
      ? io.Platform.numberOfProcessors.toString()
      : (await io.Process.run('nproc', [])).stdout.trim();

  // -DCMAKE_C_COMPILER=/opt/homebrew/bin/gcc
  final cmakeBuild = await io.Process.run(
    'cmake',
    [
      // Use GCC on macOS from Homebrew
      //if (io.Platform.isMacOS) '-D CMAKE_C_COMPILER=gcc-14',
      '--build',
      'build',
      '--config=Release',
      '--',
      if (io.Platform.isMacOS) '-j$threads',
      if (io.Platform.isLinux) '-j$threads',
      if (io.Platform.isWindows) '/m:$threads',
    ],
    runInShell: true,
    environment: env,
  );

  if (cmakeBuild.exitCode != 0) {
    io.stderr
      ..writeln('Error running CMake build step:')
      ..writeln(cmakeBuild.stdout)
      ..writeln(cmakeBuild.stderr);
    io.exit(cmakeBuild.exitCode);
  } else {
    io.stdout
      ..writeln('CMake build completed:')
      ..write(cmakeBuild.stdout);
  }
}
