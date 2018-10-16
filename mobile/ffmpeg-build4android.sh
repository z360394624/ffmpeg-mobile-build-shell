# ffmpeg-build4androidMac.sh
# set project dir of FFMPEG
export PROJECT_DIR_FFMPEG=/Users/luciuszhang/development/workspaces/source/FFmpeg
export NDK=/Users/luciuszhang/development/android/android-ndk-r15c
# export NDK=/Users/luciuszhang/development/android/android-ndk-r14b
export PREFIX=/Users/luciuszhang/development/workspaces/target/ffmpeg
export TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
export X264_LIB=/Users/luciuszhang/development/workspaces/target/x264

if [ ! $PROJECT_DIR_FFMPEG ]; then
    echo "FFMPEG is EMPTY"
    exit -1
fi

if [ ! $NDK ]; then
    echo "NDK is EMPTY"
    exit -1
fi

if [ ! $PREFIX ]; then
    PREFIX=~/
fi

export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt
export PLATFORM=$NDK/platforms/android-14/arch-arm
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

cd $PREFIX
rm -rf include
rm -rf lib
rm -rf share

# open ffmpeg dir
cd $PROJECT_DIR_FFMPEG

echo "Start Compile FFMPEG"


./configure \
--prefix=$PREFIX \
--target-os=linux \
--arch=arm \
--sysroot=$PLATFORM \
--cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
--extra-cflags="-march=armv6 -Os -fpic -I$X264_LIB/include" \
--extra-ldflags="-L$X264_LIB/lib -L$PLATFORM/usr/lib" \
--cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \
--nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \
--enable-small \
--enable-gpl \
--enable-pthreads \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-doc \
--disable-network \
--disable-shared \
--disable-encoders \
--disable-decoders \
--enable-encoder=libx264 \
--enable-protocols \
--enable-filters \
--enable-libx264 \
--enable-zlib
make clean
make -j4
make install
echo "==========================================="
# arm-linux-androideabi-ld一个链接程序，其作用主要是将汇编过的多个二进制文件进行链接，成为一个二进制文件
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-ld -L$PLATFORM/usr/lib -L$PREFIX/lib -L$X264_LIB/lib -I$PLATFORM/usr/include -L$PREFIX/include -I$X264_LIB/include \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/lib/libffmpeg.so \
$X264_LIB/lib/libx264.a \
$PREFIX/lib/libavcodec.a \
$PREFIX/lib/libavformat.a \
$PREFIX/lib/libavutil.a \
$PREFIX/lib/libavfilter.a \
$PREFIX/lib/libavdevice.a \
$PREFIX/lib/libpostproc.a \
$PREFIX/lib/libswresample.a \
$PREFIX/lib/libswscale.a \
-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
$PREBUILT/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
# strip命令从XCOFF对象文件中有选择地除去行号信息、重定位信息、调试段、typchk 段、注释段、文件头以及所有或部分符号表
# $PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-strip $PREFIX/lib/libffmpeg.so