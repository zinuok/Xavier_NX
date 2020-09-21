sudo apt-get purge -y libopencv* python-opencv
sudo apt-get update
sudo apt install -y g++-6 gcc-6
sudo apt-get install -y build-essential pkg-config
sudo apt-get install -y cmake libavcodec-dev libavformat-dev libavutil-dev \
    libglew-dev libgtk2.0-dev libgtk-3-dev libjpeg-dev libpng-dev libpostproc-dev \
    libswscale-dev libtbb-dev libtiff5-dev libv4l-dev libxvidcore-dev \
    libx264-dev qt5-default zlib1g-dev libgl1 libglvnd-dev pkg-config \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev mesa-utils #libeigen3-dev # recommend to build from source : http://eigen.tuxfamily.org/index.php?title=Main_Page
sudo apt-get install python2.7-dev python3-dev python-numpy python3-numpy
cd && wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.1.zip # check version
unzip opencv.zip
cd opencv-3.4.1 && mkdir build && cd build


## cmake with opencv_contrib ##
cd && git clone https://github.com/opencv/opencv_contrib.git && cd opencv_contrib
git checkout -b v3.4.1 3.4.1 # change to your opencv version
cd opencv-3.4.1/build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \ # change to your opencv_contrib dir
      -D CMAKE_C_COMPILER=gcc-6 \
      -D CMAKE_CXX_COMPILER=g++-6 \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_CUDA=ON \
      -D CUDA_ARCH_BIN=7.2 \  # 7.2 for for AGX Xavier and Xavier NX
      -D CUDA_ARCH_PTX="" \
      -D ENABLE_FAST_MATH=ON \
      -D CUDA_FAST_MATH=ON \
      -D WITH_CUBLAS=ON \
      -D WITH_LIBV4L=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_GSTREAMER_0_10=OFF \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D BUILD_opencv_cudacodec=OFF \
      -D CUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
      -D WITH_TBB=ON \
      ../

## make and install ##
# first trial <- will be failed
time make -j $(nproc)
# patch
mv ~/Xavier_NX/test1.patch ~/opencv-3.4.1/modules/core/include/opencv2/core
patch -N cvdef.h test1.patch
sudo mv ~/Xavier_NX/test2.patch /usr/local/cuda-10.2/include # change to your CUDA-version
sudo patch -N /usr/local/cuda-10.2/include/cuda_gl_interop.h /usr/local/cuda-10.2/include/test2.patch
time make -j $(nproc) # second trial <= must be succeed
sudo make install
