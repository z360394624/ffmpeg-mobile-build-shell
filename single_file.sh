#!/bin/bash  
export NDK=/Users/luciuszhang/Library/Android/sdk/ndk-bundle
#配置平台
export PLATFORM=$NDK/platforms/android-14/arch-arm

#配置工具链
export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt

#配置编译好了之后的文件输出目录
export PREFIX=/Users/luciuszhang/development/workspaces/target/ffmpeg/single/
CPU=arm 
ARCH=arm
ADDI_CFLAGS="-marm"  
#配置  
./configure \
    --prefix=$PREFIX \
    --arch=$ARCH \
    --cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
    --extra-ldflags="$ADDI_LDFLAGS" \
    --sysroot=$PLATFORM \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
    --target-os=linux \
    --enable-cross-compile \
    --enable-gpl \
    --disable-shared \
    --enable-static \
    --disable-doc \
    --disable-debug \
    --enable-small \
    --disable-programs \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    $ADDITIONAL_CONFIGURE_FLAG
  
#编译  
make clean  
  
make -j4  
  
make install
  
#打包  
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-ld \
    -rpath-link=$PLATFORM/usr/lib \
    -L$PLATFORM/usr/lib \
    -L$PREFIX/lib \
    -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
    $PREFIX/libffmpeg.so \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    libavdevice/libavdevice.a \
    libpostproc/libpostproc.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    $PREBUILT/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
  
#strip
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-strip  $PREFIX/libffmpeg.so
