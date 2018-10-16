export PROJECT_DIR_X264=/Users/luciuszhang/development/workspaces/source/x264
export PREFIX=/Users/luciuszhang/development/workspaces/target/x264/linux

# # open ffmpeg dir
# # –lstdc++表示连接c++标准库， -lc连接c语言标准库
cd $PROJECT_DIR_X264
./configure --prefix=$PREFIX --enable-static --disable-cli --disable-asm
make clean
make -j4
make install
