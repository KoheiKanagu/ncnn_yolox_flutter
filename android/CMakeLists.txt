project(ncnn_yolox_flutter)

cmake_minimum_required(VERSION 3.11)

## If you do not need to download the ncnn library, remove it. 
## From here
include(FetchContent)
FetchContent_Declare(
    ncnn
    URL https://github.com/KoheiKanagu/ncnn_yolox_flutter/releases/download/0.0.5/ncnn-android.zip
)
FetchContent_MakeAvailable(ncnn)
## Up to here

set(ncnn_DIR ${ncnn_SOURCE_DIR}/${ANDROID_ABI}/lib/cmake/ncnn)

# for local debug
# set(ncnn_DIR ${CMAKE_SOURCE_DIR}/ncnn/${ANDROID_ABI}/lib/cmake/ncnn)

find_package(ncnn REQUIRED)

add_library(ncnn_yolox_flutter SHARED ${CMAKE_SOURCE_DIR}../../ios/Classes/yolox.cpp)

target_compile_definitions(ncnn_yolox_flutter PUBLIC USE_NCNN_SIMPLEOCV)

target_link_libraries(ncnn_yolox_flutter ncnn)
