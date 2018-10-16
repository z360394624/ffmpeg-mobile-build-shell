export PROJECT_DIR_X264=/Users/luciuszhang/development/workspaces/source/x264
export NDK=/Users/luciuszhang/development/android/android-ndk-r15c
# export NDK=/Users/luciuszhang/development/android/android-ndk-r14b
export PREFIX=/Users/luciuszhang/development/workspaces/target/x264/mobile
export PLATFORM=$NDK/platforms/android-14/arch-arm
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt

# open ffmpeg dir
cd $PROJECT_DIR_X264
./configure \
--prefix=$PREFIX \
--enable-static \
--enable-pic \
--disable-cli \
--disable-asm \
--host=arm-linux \
--cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
--sysroot=$PLATFORM
make clean
make -j4
make install 