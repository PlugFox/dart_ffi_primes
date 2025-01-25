#set(CMAKE_C_COMPILER "gcc-14")
#set(CMAKE_CXX_COMPILER "/usr/bin/g++-4.2")

cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(cprime_library VERSION 1.0.0 LANGUAGES C)

# Установка стандартов C и включение диагностики
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Настройка типов сборки и оптимизаций
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Общие опции компиляции
if (WIN32)
    message(STATUS "Platform: Windows")
    set(CMAKE_C_FLAGS "-O3 -mcpu=native -mtune=native -ffast-math -funroll-loops -ftree-vectorize -fomit-frame-pointer")
    set(CMAKE_C_FLAGS_DEBUG "-g")
    set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -DNDEBUG")
elseif(APPLE)
    message(STATUS "Platform: macOS")
    set(CMAKE_C_FLAGS "-O3 -mcpu=native -mtune=native -ffast-math -funroll-loops -ftree-vectorize -fomit-frame-pointer")
    set(CMAKE_C_FLAGS_DEBUG "-g")
    set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG")
else()
    message(STATUS "Platform: Linux")
    set(CMAKE_C_FLAGS "-O3 -mcpu=native -mtune=native -ffast-math -funroll-loops -ftree-vectorize -fomit-frame-pointer")
    set(CMAKE_C_FLAGS_DEBUG "-g")
    set(CMAKE_C_FLAGS_RELEASE "-O3 -march=native -mtune=native -DNDEBUG")
endif()

add_library(cprime_library SHARED prime.c)

# Оптимизации для производительности
target_compile_options(cprime_library PRIVATE
    -O3
    -ffast-math
    -funroll-loops
    -ftree-vectorize
    -fomit-frame-pointer
)

# Настраиваем свойства для библиотеки
set_target_properties(cprime_library PROPERTIES
    PUBLIC_HEADER prime.h                        # Публичный заголовок
    VERSION ${PROJECT_VERSION}                   # Версия библиотеки
    SOVERSION 1                                  # Совместимость API
    OUTPUT_NAME "cprime"                         # Имя выходного файла
)

# Установка разных суффиксов для библиотек на разных платформах
if (WIN32)
    set_target_properties(cprime_library PROPERTIES SUFFIX ".dll")
elseif(APPLE)
    set_target_properties(cprime_library PROPERTIES SUFFIX ".dylib")
else()
    set_target_properties(cprime_library PROPERTIES SUFFIX ".so")
endif()

# Указываем, куда будет установлена библиотека
install(TARGETS cprime_library DESTINATION lib)
#install(TARGETS cprime_library
#    LIBRARY DESTINATION lib
#    PUBLIC_HEADER DESTINATION include
#)

# Устанавливаем файлы (для каждой платформы своя папка)
#if (WIN32)
#    install(TARGETS cprime_library DESTINATION ../assets/lib/windows)
#elseif(APPLE)
#    install(TARGETS cprime_library DESTINATION ../assets/lib/macos)
#else()
#    install(TARGETS cprime_library DESTINATION ../assets/lib/linux)
#endif()

# Опционально: создаём исполняемый файл для тестирования
#add_executable(prime_test main.c)
#target_link_libraries(prime_test PRIVATE cprime_library)

# Устанавливаем заголовочные файлы (опционально)
#install(FILES prime.h DESTINATION include)
