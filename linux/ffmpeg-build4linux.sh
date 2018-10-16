# ffmpeg-build4androidMac.sh
# set project dir of FFMPEG
export PROJECT_DIR_FFMPEG=/Users/luciuszhang/development/workspaces/source/FFmpeg
export PREFIX=/Users/luciuszhang/development/workspaces/target/ffmpeg/linux
export X264_LIB=/Users/luciuszhang/development/workspaces/target/x264/linux

if [ ! $PROJECT_DIR_FFMPEG ]; then
    echo "FFMPEG is EMPTY"
    exit -1
fi


if [ ! $PREFIX ]; then
    PREFIX=~/
fi

cd $PREFIX
rm -rf include
rm -rf lib
rm -rf share

# open ffmpeg dir
cd $PROJECT_DIR_FFMPEG

echo "Start Compile FFMPEG"


./configure \
--prefix=$PREFIX \
--extra-cflags="-Os -fpic -I$X264_LIB/include" \
--extra-ldflags="-L$X264_LIB/lib" \
--enable-small \
--enable-gpl \
--enable-pthreads \
--disable-asm
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
ld -L./lib -L/Users/luciuszhang/development/workspaces/target/x264/linux/lib \
-arch x86_64 \
-dylib \
-o ./lib/libffmpeg.so \
$X264_LIB/lib/libx264.a \
./lib/libavcodec.a \
./lib/libavformat.a \
./lib/libavutil.a \
./lib/libavfilter.a \
./lib/libavdevice.a \
./lib/libpostproc.a \
./lib/libswresample.a \
./lib/libswscale.a \
-lc -lm -lz -ldl
# strip命令从XCOFF对象文件中有选择地除去行号信息、重定位信息、调试段、typchk 段、注释段、文件头以及所有或部分符号表
strip ./lib/libffmpeg.so