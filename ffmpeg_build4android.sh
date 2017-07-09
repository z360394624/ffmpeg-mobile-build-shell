#!/bin/sh
. ndk.properties
echo $NDK
#=============for mac start=============
#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#brew install yasm
#brew install pkgconfig
#=============for mac end===============
#git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
./configure \
--prefix=$PREFIX_ANDROID \
--target-os=linux \
--arch=$ARCH \
--sysroot=$PLATFORM \
--cross-prefix=$CROSS_PREFIX/bin/arm-linux-androideabi- \
--extra-ldflags="$ADDI_LDFLAGS" \
--extra-cflags="-Os -fpic $ADDI_CFLAGS" \
--enable-small \
--enable-gpl \
--enable-pthreads \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-doc \
--disable-network \
--disable-shared \
--disable-encoders \
--disable-decoders \
--enable-protocols \
--enable-filters \
--enable-decoder=mpeg4 \
--enable-decoder=h264 \
--enable-decoder=mp3 \
--enable-decoder=aac \
--enable-encoder=mpeg4 \
--enable-encoder=libx264 \
--enable-encoder=aac \
$ADDITIONAL_CONFIGURE_FLAG
make clean
make -j4
make install
$CROSS_PREFIX/bin/arm-linux-androideabi-ld \
-rpath-link=$PLATFORM/usr/lib \
-L$PLATFORM/usr/lib \
-L$PREFIX_ANDROID/lib \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
$PREFIX_ANDROID/libffmpeg.so \
libavcodec/libavcodec.a \
libavformat/libavformat.a \
libavutil/libavutil.a \
libavfilter/libavfilter.a \
libavdevice/libavdevice.a \
libpostproc/libpostproc.a \
libswresample/libswresample.a \
libswscale/libswscale.a \
-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
$CROSS_PREFIX/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
$CROSS_PREFIX/bin/arm-linux-androideabi-strip $PREFIX_ANDROID/libffmpeg.so

