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
--enable-small \
--enable-gpl \
--enable-pthreads \
--disable-doc \
--enable-ffmpeg \
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
--extra-cflags="-Os -fpic -marm=armv6" \
--extra-ldflags="-marm=armv6"
make clean
make -j4
make install