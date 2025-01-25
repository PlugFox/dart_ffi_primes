# dart_ffi_primes

## Compile C library

```bash
mkdir build
cd build
cmake ../library
cmake --build .
cmake --install .
```

## Generate FFI bindings

```bash
dart pub get
dart run ffigen
```
