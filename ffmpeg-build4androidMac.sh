# ffmpeg-build4androidMac.sh
# set project dir of FFMPEG
export PROJECT_DIR_FFMPEG=/Users/luciuszhang/development/workspaces/source/FFmpeg
export NDK=/Users/luciuszhang/development/android/android-ndk-r14b
export PREFIX=/Users/luciuszhang/development/workspaces/target/ffmpeg/optimized

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

CPU=arm
ARCH=arm
#-marm -mthumb gcc编译器参数
#marm性能优于mthumb百分之10到15，mthumb兼容性更好，可以调试用marm，发版用mthumb
ADDI_CFLAGS="-marm"
./configure \
--prefix=$PREFIX \
--target-os=linux \
--arch=$ARCH \
--sysroot=$PLATFORM \
--cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
--extra-ldflags="$ADDI_LDFLAGS" \
--extra-cflags="-Os -fpic $ADDI_CFLAGS" \
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
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-ld \
-rpath-link=$PLATFORM/usr/lib \
-L$PLATFORM/usr/lib \
-L$PREFIX/lib \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
$PREFIX/libffmpeg.so \
libavcodec/libavcodec.a \
libavformat/libavformat.a \
libavutil/libavutil.a \
libavfilter/libavfilter.a \
libavdevice/libavdevice.a \
libpostproc/libpostproc.a \
libswresample/libswresample.a \
libswscale/libswscale.a \
-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
$PREBUILT/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-strip $PREFIX/libffmpeg.so



