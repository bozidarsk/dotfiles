sudo pacman -Sy cuda ffnvcodec-headers avisynthplus frei0r-plugins ladspa
export PATH="$PATH:/opt/cuda/bin"
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg-nvidia
cd ffmpeg-nvidia
./configure $(ffmpeg --help 2>&1 | grep configuration: | sed -E 's/\s+configuration:\s+(.+)/\1/') --enable-nonfree --enable-libnpp --extra-cflags=-I/opt/cuda/include --extra-ldflags=-L/opt/cuda/lib64 --disable-cude-nvcc --enable-cuda-llvm --enable-frei0r --disable-amf
make -j $(nproc)
sudo make install
sudo install ffmpeg /usr/local/bin/ffmpeg-nvidia

# ffmpeg-nvidia -hwaccel nvdec -c:v h264_cuvid -i src.ts -c:v h264_nvenc -preset fast dest.mp4
