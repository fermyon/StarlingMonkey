include("add_builtin")

set(INSTALL_BUILTINS ${CMAKE_CURRENT_BINARY_DIR}/builtins.incl CACHE INTERNAL "Path to the builtins.incl file" FORCE)
file(WRITE ${INSTALL_BUILTINS} "// This file is generated by CMake\n")

add_library(builtins STATIC builtins/install_builtins.cpp)
target_include_directories(builtins PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(builtins PRIVATE extension_api)

add_builtin(builtins/web/global_self.cpp)

add_builtin(builtins/web/url.cpp)
target_include_directories(builtins_web_url PRIVATE runtime)

add_builtin(builtins/web/base64.cpp)

add_builtin(builtins/web/console.cpp)

add_builtin(builtins/web/dom-exception.cpp)
target_include_directories(builtins_web_dom_exception PRIVATE runtime)

add_builtin(builtins/web/performance.cpp)
add_builtin(builtins/web/queue-microtask.cpp)
add_builtin(builtins/web/structured-clone.cpp)

add_builtin(builtins/web/timers.cpp)
target_include_directories(builtins_web_timers PRIVATE runtime)

add_builtin(builtins/web/worker-location.cpp)

add_builtin(
        builtins::web::text-codec
        SRC
            builtins/web/text-codec/text-codec.cpp
            builtins/web/text-codec/text-decoder.cpp
            builtins/web/text-codec/text-encoder.cpp)
target_include_directories(builtins_web_text_codec PRIVATE runtime)

add_builtin(
        builtins::web::streams
        SRC
            builtins/web/streams/compression-stream.cpp
            builtins/web/streams/decompression-stream.cpp
            builtins/web/streams/native-stream-sink.cpp
            builtins/web/streams/native-stream-source.cpp
            builtins/web/streams/streams.cpp
            builtins/web/streams/transform-stream.cpp
            builtins/web/streams/transform-stream-default-controller.cpp)
target_include_directories(builtins_web_streams PRIVATE runtime)

add_builtin(
        builtins::web::fetch
        SRC
        builtins/web/fetch/fetch-api.cpp
        builtins/web/fetch/headers.cpp
        builtins/web/fetch/request-response.cpp)

add_builtin(builtins/web/fetch/fetch_event.cpp)
target_link_libraries(builtins_web_fetch_fetch_event PRIVATE host_api)
target_include_directories(builtins_web_fetch_fetch_event PRIVATE runtime ${HOST_API}/bindings/)

add_builtin(
        builtins::web::crypto
        SRC
        builtins/web/crypto/crypto.cpp
        builtins/web/crypto/crypto-algorithm.cpp
        builtins/web/crypto/crypto-key.cpp
        builtins/web/crypto/crypto-key-ec-components.cpp
        builtins/web/crypto/crypto-key-rsa-components.cpp
        builtins/web/crypto/json-web-key.cpp
        builtins/web/crypto/subtle-crypto.cpp)
target_link_libraries(builtins_web_crypto PRIVATE OpenSSL::Crypto fmt)
target_include_directories(builtins_web_crypto PRIVATE runtime)
