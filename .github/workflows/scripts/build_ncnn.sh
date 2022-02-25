#!/bin/bash -euxo pipefail
WORKDIR=$(pwd)
cd "$(dirname "$0")"

# Clone

git clone https://github.com/Tencent/ncnn.git -b 20220216 --depth 1
cd ncnn

git submodule update --init

# Android NDK setup

wget https://dl.google.com/android/repository/android-ndk-r23b-linux.zip
unzip -q android-ndk-r23b-linux.zip

export ANDROID_NDK=/content/ncnn/android-ndk-r23b

!sed -i -e '/^  -g$/d' $ANDROID_NDK/build/cmake/android.toolchain.cmake

# build

cmake --version

mkdir -p build-android-armv7
cd build-android-armv7

cmake \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=install \
    -DANDROID_ABI="armeabi-v7a" \
    -DANDROID_ARM_NEON=ON \
    -DNCNN_VULKAN=OFF \
    -DANDROID_PLATFORM=android-24 \
    -DNCNN_SIMPLEOCV=ON \
    -DNCNN_BUILD_BENCHMARK=OFF \
    ..

make -j$(nproc)
make install

cd ../

mkdir -p build-android-aarch64
cd build-android-aarch64

cmake \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=install \
    -DANDROID_ABI="arm64-v8a" \
    -DNCNN_VULKAN=OFF \
    -DANDROID_PLATFORM=android-24 \
    -DNCNN_SIMPLEOCV=ON \
    -DNCNN_BUILD_BENCHMARK=OFF \
    ..

make -j$(nproc)
make install

cd ../

# archive
zip -q -r ncnn-build-android.zip build-android-armv7 build-android-aarch64