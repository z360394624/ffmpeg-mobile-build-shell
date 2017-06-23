#清除上次编译的东西
make clean
#配置NDK路径
export NDK=/Users/luciuszhang/Library/Android/sdk/ndk-bundle
#配置工具链
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt
#配置平台
export PLATFORM=$NDK/platforms/android-14/arch-arm
#配置编译好了之后的文件输出目录，$(pwd)当前目录下
export PREFIX=/Users/luciuszhang/development/workspaces/target/ffmpeg/multi/
build_one(){
  ./configure --target-os=linux --prefix=$PREFIX \
--enable-cross-compile \
--enable-runtime-cpudetect \
--disable-asm \
--arch=arm \
--cc=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-gcc \
--cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
--disable-stripping \
--nm=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-nm \
--sysroot=$PLATFORM \
--enable-gpl --enable-shared --disable-static --enable-nonfree --enable-version3 --enable-small \
--enable-zlib --disable-ffprobe --disable-ffplay --disable-ffmpeg --disable-ffserver --disable-debug \
--extra-cflags="-fPIC -DANDROID -D__thumb__ -mthumb -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp -marm -march=armv7-a" 
}
build_one

#4线程编译
make -j4
make install