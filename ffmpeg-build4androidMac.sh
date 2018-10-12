# ffmpeg-build4androidMac.sh
# set project dir of FFMPEG
export PROJECT_DIR_FFMPEG=/Users/luciuszhang/development/workspaces/source/FFmpeg
export NDK=/Users/luciuszhang/development/android/android-ndk-r14b
export PREFIX=/Users/luciuszhang/development/workspaces/target/ffmpeg
export TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

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

# open ffmpeg dir
cd $PROJECT_DIR_FFMPEG

echo "Start Compile FFMPEG"
./configure \
--prefix=$PREFIX \
--target-os=linux \
--arch=arm \
--sysroot=$PLATFORM \
--cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
--extra-cflags="-Os -fpic -I/Users/luciuszhang/development/workspaces/target/x264/include" \
--extra-ldflags="-L/Users/luciuszhang/development/workspaces/target/x264/lib" \
--cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \
--nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \
--enable-small \
--enable-gpl \
--enable-shared \
--enable-pthreads \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-doc \
--disable-network \
--enable-protocols \
--enable-filters \
--enable-libx264 \
--enable-decoder=mpeg4 \
--enable-decoder=h264 \
--enable-decoder=mp3 \
--enable-decoder=aac \
--enable-encoder=mpeg4 \
--enable-encoder=libx264 \
--enable-encoder=aac \
--enable-zlib \
--extra-libs="-ldl -lgcc"
make clean
make -j4
make install
echo "==========================================="
# build single so lib
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-ld \
-rpath-link=$PLATFORM/usr/lib \
-L$PLATFORM/usr/lib \
-L$PREFIX/lib \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
$PREFIX/lib/libffmpeg.so \
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
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-strip $PREFIX/lib/libffmpeg.so




