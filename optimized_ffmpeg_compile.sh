#optimized_ffmpeg_compile.sh
export NDK=/Users/luciuszhang/Library/Android/sdk/ndk-bundle

export PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt

export PLATFORM=$NDK/platforms/android-14/arch-arm


PREFIX=/Users/luciuszhang/development/workspaces/target/ffmpeg/optimized
CPU=arm
ARCH=arm
#-marm -mthumb gcc编译器参数
#marm性能优于mthumb百分之10到15，mthumb兼容性更好，可以调试用marm，发版用mthumb
ADDI_CFLAGS="-marm"

#配置  
./configure \
--prefix=$PREFIX \
--target-os=linux \
--arch=$ARCH \
--sysroot=$PLATFORM \
--cross-prefix=$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi- \
#gcc编译器会用到的一些优化参数，也可以在里面指定库文件的位置。用法：LDFLAGS=“-L/usr/lib -L/path/to/your/lib”
--extra-ldflags="$ADDI_LDFLAGS" \
#C编译器的选项，但是加入的是头文件（.h文件）的路径，如：CFLAGS=“-I/usr/include -I/path/to/your/include”
--extra-cflags="-Os -fpic $ADDI_CFLAGS" \
#压缩编译后的包
--enable-small \
--enable-gpl \
--enable-pthreads \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-doc \
--disable-symver \
--disable-avdevice \
--disable-avfilter \
--disable-swscale \
--disable-network \
--disable-everything \
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
-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
$PREBUILT/darwin-x86_64/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
$PREBUILT/darwin-x86_64/bin/arm-linux-androideabi-strip $PREFIX/libffmpeg.so




