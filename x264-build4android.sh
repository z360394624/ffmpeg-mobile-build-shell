export PROJECT_DIR_X264=/Users/luciuszhang/development/workspaces/source/x264
export NDK=/Users/luciuszhang/development/android/android-ndk-r12b
export PREFIX=/Users/luciuszhang/development/workspaces/target/x264
export PLATFORM=$NDK/platforms/android-14/arch-arm
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt

# open ffmpeg dir
cd $PROJECT_DIR_X264
./configure \
--prefix=$PREFIX \
--disable-cli \
--enable-static \
--disable-asm \
--enable-pic \
--host=arm-linux \
--cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
--sysroot=$PLATFORM
make clean
make -j4
make install 