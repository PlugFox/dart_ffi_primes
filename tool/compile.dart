import 'dart:io' as io;

void main() {
  io.Directory.current;

  io.Process.run('ls', ['-l']).then((result) {
    print(result.stdout);
  });

  io.Process.run('gcc', ['--version']).then((result) {
    print(result.stdout);
  });

  // cmake -B build .


}
