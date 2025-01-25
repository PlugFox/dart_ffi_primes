# dart_ffi_primes

## Compile C library

```bash
dart run tool/compile.dart
```

or

```bash
mkdir build
cd build
cmake ../library/
cmake --build .
```

## Generate FFI bindings

```bash
dart pub get
dart run ffigen
```

## Compile and run Dart code

```bash
dart run bin/main.dart -s=1 -e=100
```

or

```bash
dart compile exe bin/main.dart -o ./build/primes.exe
./build/primes.exe -s=1 -e=100
```
