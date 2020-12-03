cmake_minimum_required(VERSION 3.16)
project(RtspDecodeOnGPU)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(PC_AVCODEC REQUIRED IMPORTED_TARGET libavcodec)
pkg_check_modules(PC_AVFORMAT REQUIRED IMPORTED_TARGET libavformat)
pkg_check_modules(PC_AVUTIL REQUIRED IMPORTED_TARGET libavutil)
pkg_check_modules(PC_SWRESAMPLE REQUIRED IMPORTED_TARGET libswresample)

set(NV_FFMPEG_HDRS ${PC_AVCODEC_INCLUDE_DIRS})
find_library(AVCODEC_LIBRARY NAMES avcodec
             HINTS
             ${PC_AVCODEC_LIBDIR}
             ${PC_AVCODEC_LIBRARY_DIRS}
             )
find_library(AVFORMAT_LIBRARY NAMES avformat
             HINTS
             ${PC_AVFORMAT_LIBDIR}
             ${PC_AVFORMAT_LIBRARY_DIRS}
             )
find_library(AVUTIL_LIBRARY NAMES avutil
             HINTS
             ${PC_AVUTIL_LIBDIR}
             ${PC_AVUTIL_LIBRARY_DIRS}
             )
find_library(SWRESAMPLE_LIBRARY NAMES swresample
             HINTS
             ${PC_SWRESAMPLE_LIBDIR}
             ${PC_SWRESAMPLE_LIBRARY_DIRS}
             )
set(AVCODEC_LIB ${AVCODEC_LIBRARY})
set(AVFORMAT_LIB ${AVFORMAT_LIBRARY})
set(AVUTIL_LIB ${AVUTIL_LIBRARY})

find_package(OpenCV REQUIRED)
find_package(CUDA REQUIRED)
set(CUDA_HOST_COMPILER ${CMAKE_CXX_COMPILER})
SET(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS})

find_library(CUVID_LIB nvcuvid)
find_library(NVENCODEAPI_LIB nvidia-encode)

LINK_DIRECTORIES(/usr/lib
                 /usr/local/lib
                 /usr/local/cuda/lib64)
message("CUDA_LIBRARY: " ${CUDA_CUDA_LIBRARY})
file(GLOB_RECURSE SOURCES "src/*.cpp")

file(GLOB_RECURSE HEADERS "src/*.h")

cuda_add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})

set_target_properties(${PROJECT_NAME} PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS} ${CUDA_CUDA_LIBRARY} ${CMAKE_DL_LIBS} ${NVENCODEAPI_LIB} ${CUVID_LIB} ${AVCODEC_LIB} ${AVFORMAT_LIB} ${AVUTIL_LIB})
