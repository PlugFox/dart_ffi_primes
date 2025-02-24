# dart_ffi_primes

## Generate FFI bindings

Generate FFI bindings with **ffigen**

```bash
dart pub get
dart run ffigen
```

## Compile C library

Compile the C library with **Dart** script

```bash
dart run tool/compile.dart
```

or directly with **CMake**

```bash
mkdir build
cd build
cmake ../library/
cmake --build .
```

or for **macOS** with standard C compiler

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

or for **macOS** with GCC 14 (installed via Homebrew)

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

## Compile and run Dart code

Run the Dart code with **Dart VM**

```bash
dart run bin/main.dart -s 1 -e 10000000
```

or compile and run the Dart code with **Dart Runtime**

```bash
dart compile exe bin/main.dart -o ./build/primes.exe
./build/primes.exe -s 1 -e 10000000
```
