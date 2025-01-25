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

or for macOS with standard C compiler

```bash
mkdir build
gcc -shared -o build/libcprime.dylib \
    -O3 \
    -ffast-math \
    -funroll-loops \
    -ftree-vectorize \
    -fomit-frame-pointer \
    library/prime.c
```

or for macOS with GCC 14 (installed via Homebrew)

```bash
mkdir build
gcc-14 -shared -o build/libcprime.dylib \
    -O3 \
    -ffast-math \
    -funroll-loops \
    -ftree-vectorize \
    -fomit-frame-pointer \
    -flto \
    -fno-semantic-interposition  \
    -march=native \
    -fopenmp \
    library/prime.c
```

## Generate FFI bindings

```bash
dart pub get
dart run ffigen
```

## Compile and run Dart code

```bash
dart run bin/main.dart -s 1 -e 10000000
```

or

```bash
dart compile exe bin/main.dart -o ./build/primes.exe
./build/primes.exe -s 1 -e 10000000
```
