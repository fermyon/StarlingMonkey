set(WASI_SDK_VERSION 20 CACHE STRING "Version of wasi-sdk to use")

set(WASI_SDK_URL "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.0-${HOST_OS}.tar.gz")
CPMAddPackage(NAME wasi-sdk URL ${WASI_SDK_URL})
set(WASI_SDK_PREFIX ${CPM_PACKAGE_wasi-sdk_SOURCE_DIR})
set(CMAKE_TOOLCHAIN_FILE ${CPM_PACKAGE_wasi-sdk_SOURCE_DIR}/share/cmake/wasi-sdk.cmake)
