# Пример компиляции для Linux
# $ gcc -shared -o libcprime.so -fPIC prime.c
# Пример компиляции для macOS
# $ gcc -shared -o libcprime.dylib -fPIC prime.c
# Пример компиляции для Windows
# $ gcc -shared -o cprime.dll prime.c -Wl,--out-implib,libcprime.a

cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(cprime_library VERSION 1.0.0 LANGUAGES C)

# Добавляем исходный файл
add_library(cprime_library SHARED prime.c)

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

# Опционально: создаём исполняемый файл для тестирования
#add_executable(cprime_test main.c)

# Указываем, куда будет установлена библиотека
install(TARGETS cprime_library DESTINATION lib)

# Устанавливаем файлы (для каждой платформы своя папка)
#if (WIN32)
#    install(TARGETS cprime_library DESTINATION ../assets/lib/windows)
#elseif(APPLE)
#    install(TARGETS cprime_library DESTINATION ../assets/lib/macos)
#else()
#    install(TARGETS cprime_library DESTINATION ../assets/lib/linux)
#endif()

# Устанавливаем заголовочные файлы (опционально)
#install(FILES prime.h DESTINATION include)