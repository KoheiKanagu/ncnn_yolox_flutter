project(ncnn_yolox_flutter)

cmake_minimum_required(VERSION 3.4.1)

set(ncnn_DIR ${CMAKE_SOURCE_DIR}/ncnn-20220216/${ANDROID_ABI}/lib/cmake/ncnn)
find_package(ncnn REQUIRED)

add_library(ncnn_yolox_flutter SHARED ${CMAKE_SOURCE_DIR}../../ios/Classes/yolox.cpp)

target_compile_definitions(ncnn_yolox_flutter PUBLIC USE_NCNN_SIMPLEOCV)

target_link_libraries(ncnn_yolox_flutter ncnn)
