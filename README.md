# Xavier_NX
***
setting guide for Nvidia Xavier NX (arm architecture)
# Index
### 1. OpenCV (ver. 3.4.1) install 
### 2. Intel Realsense camera: D435i
### 3. CSI camera: IMX477
### 4. Teamviewer for arm-architecture
### 5. GPS reading from NEO-M8N (model: pixhawk here2) 
***
<br><br>

## 1. OpenCV (ver. 3.4.1) install 
from [engcang](https://github.com/engcang/vins-application#-opencv-with-cuda--necessary-for-gpu-version-1)
+ if you build OpenCV manually, you have to do some fix. Please follow the steps from [here](https://github.com/engcang/vins-application#-opencv-with-cuda--necessary-for-gpu-version-1)
+ CUDA_ARCH_BIN = 7.2 for AGX Xavier and Xavier NX, 6.2 for TX2  
+ when patch using **test.patch**
```
$ mv test.patch ~<opencv directory>/opencv-3.4.1/modulest/core/include/opencv2/core/
$ patch -N cvdef.h test.patch
```
+ build OpenCV with **opencv_contrib** <br>
some packges you will use need the header file defined in 'opencv_contrib'. In this case, you can build OpenCV with the opencv_contrib.
**if you build OpenCV with CUDA, should use multicore: 'sudo make install -j6' (otherwise, it's too slow)**

+ download OpenCV 3.4.1
```bash
sudo apt-get purge libopencv* python-opencv
sudo apt-get update
sudo apt-get install -y build-essential pkg-config
sudo apt install -y g++-6 gcc-6
sudo apt-get install -y cmake libavcodec-dev libavformat-dev libavutil-dev \
    libglew-dev libgtk2.0-dev libgtk-3-dev libjpeg-dev libpng-dev libpostproc-dev \
    libswscale-dev libtbb-dev libtiff5-dev libv4l-dev libxvidcore-dev \
    libx264-dev qt5-default zlib1g-dev libgl1 libglvnd-dev pkg-config \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev mesa-utils #libeigen3-dev
sudo apt-get install python2.7-dev python3-dev python-numpy python3-numpy
mkdir <opencv_source_directory> && cd <opencv_source_directory>
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.1.zip # check version
unzip opencv.zip
cd <opencv_source_directory>/opencv && mkdir build && cd build
```

+ build OpenCV with contib
```bash
git clone https://github.com/opencv/opencv_contrib.git && cd opencv_contrib
git checkout -b v<your OpenCV version> <your OpenCV version>
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D OPENCV_EXTRA_MODULES_PATH=<opencv_contrib path>/modules \
      -D CMAKE_C_COMPILER=gcc-6 \
      -D CMAKE_CXX_COMPILER=g++-6 \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_CUDA=ON \
      -D CUDA_ARCH_BIN=7.2 \  # 7.2 for for AGX Xavier and Xavier NX, 6.2 for TX2
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
```

+ install OpenCV
```bash
time make -j8
sudo make install -j6
```

## 2. Intel Realsense camera: D435i
from [IntelRealSense](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)
+ **verified version info**
    + SDK/Firmware - 2.36.0 / 5.12.6.0
    + SDK/Firmware - 2.45.0


+ **Download the complete source tree with git**
```bash
git clone https://github.com/IntelRealSense/librealsense.git
```

+ **Download and unzip the latest stable version from [here](https://github.com/IntelRealSense/librealsense/releases)**

+ **unzip**
```bash
tar -xvf librealsense-[version].tar.gz
cd librealsense
```

+ **prepare Ubuntu setup**
```bash
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev
```

+ **for Ubuntu 18.04**
```bash
sudo apt-get install -y libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev
```

+ **Run CMake(if you don't have CUDA, remove the last line)**
```bash
mkdir build && cd build
cmake ../ -DBUILD_EXAMPLES=true -DFORCE_LIBUVC=true -DBUILD_WITH_CUDA=true
```

+ **recompile and install librealsense binaries**
```bash
sudo make uninstall && make clean
make -j4 && sudo make install
```

**< Trouble shooting >**
+ 'Failed to set power state error' or 'UDEV-Rules are missing' <br>
This is because you are using outdated UDEV-Rules. Follow this:
```bash
sudo cp $(pwd)/config/99-realsense-libusb.rules /etc/udev/rules.d/99-realsense-libusb.rules && sudo udevadm control --reload-rules && udevadm trigger
reboot
```
**< with ROS >**
+ prerequisite
```bash
sudo apt install -y ros-melodic-ddynamic-reconfigure
```

+ download realsense-ros package
```bash
git clone https://github.com/IntelRealSense/realsense-ros.git
```

+ edit CMakeLists.txt: change **find_package(realsense2 2.36.0)** to **find_package(realsense2 [your SDK version])**
```bash
gedit ~/catkin_ws/src/realsense-ros/realsense2-camera/CMakeLists.txt
```

+ catkin build
```bash
cd ~/catkin_ws && catkin build -DCMAKE_BUILD_TYPE=Release -j3 
```

## 3. CSI camera: IMX477
**update(2020.08.14): <br>
Ridgerun has implemented the easier method using Deb packages. Please refer option A in [Ridgerun](https://github.com/RidgeRun/NVIDIA-Jetson-IMX477-RPIV3)**<br>
**following method is option B, more complicated one than option A. You don't have to use this method anymore**<br><br>
shell script for using IMX477 Raspberry camera with Jetson Xavier NX is included.<br>
This script is just an automated collection of install commands from [Install guide(Ridgerun)](https://developer.ridgerun.com/wiki/index.php?title=Raspberry_Pi_HQ_camera_IMX477_Linux_driver_for_Jetson#Compatibility_with_NVIDIA.C2.AEJetson.E2.84.A2_Platforms).<br>
+ **usage**
```bash
git clone https://github.com/zinuok/Xavier_NX.git
cd Xavier_NX
chmod +x imx477.sh && ./imx477.sh
```

Whole install informations and sources are from [Ridgerun](https://github.com/RidgeRun/NVIDIA-Jetson-IMX477-RPIV3), author of IMX477 driver for Jetson board.<br> 
Thanks to **RidgeRun**
<br>
+ **hardware & software setup**
    + jetson Xavier NX - Jetpack 4.4
    + IMX477 HQ camera V1.0 2018 **(you should remove R8 resistor from camera board. refer below link)**
    <br>
+ **reference links**
    + [Ridgerun github](https://github.com/RidgeRun/NVIDIA-Jetson-IMX477-RPIV3)
    + [Install guide](https://developer.ridgerun.com/wiki/index.php?title=Raspberry_Pi_HQ_camera_IMX477_Linux_driver_for_Jetson#Compatibility_with_NVIDIA.C2.AEJetson.E2.84.A2_Platforms)
<br>

## 4. Teamviewer for arm-architecture
from [here](https://medium.com/@hmurari/how-to-install-teamviewer-on-a-jetson-nano-38080f87f039)
+ **Download the TeamViewer host for Raspberry Pi**<br>
[Download link](https://www.teamviewer.com/en-us/download/raspberry-pi/)

+ **add armv7–32bit architecture for apt packages.**
```bash
sudo dpkg --add-architecture armhf
sudo apt update
sudo apt install -y libxtst6:armhf
```

+ **Install Teamviewer** (some error may occur. it's normal in arm-based architecture)
```bash
cd ~/Downloads
sudo dpkg -i teamviewer-host_[version]_armhf.deb
```

+ **Fix the installation errors observed above**
```bash
sudo apt install -f
```

+ **Enable Teamviewer as a Daemon**
```bash
sudo systemctl enable teamviewerd.service
sudo service teamviewerd start
```

+ **Adding aarch64 architecture info**<br>
If you try to execute teamviewer, 'unknown architecture 'aarch64'' error will occur.<br>
To avoid this problem, you have to add the architecture info.<br><br>
access 'tvw_main' and change **( armv7l )** to **( armv71 | aarch64 )**. Make sure to 'space' between them.
```bash
vi /opt/teamviewer/tv_bin/script/tvw_main 
```

+ **Additional problem fixing**
from [here](https://medium.com/@hmurari/how-to-install-teamviewer-on-a-jetson-nano-38080f87f039)<br>
Once you followed aboved sequence, you could execute Teamviewer.<br>
If you reboot your system and try to execute Teamviewer, however, Teamviewer will not be executed.<br>
So you have to rename the '50_mesa.json' Teamviewer uses.
```bash
sudo mv /usr/share/glvnd/egl_vendor.d/50_mesa.json /usr/share/glvnd/egl_vendor.d/50_mesa-old.json
```

+ **Execute**
```bash
teamviewer
```

## 5. GPS data reading from NEO-M8N (model: pixhawk here2)
from [KumarRobotics/ublox](https://github.com/KumarRobotics/ublox)
+ Download the ROS package from above link and build.
+ to work with NEO-M8N, use [this](https://github.com/zinuok/Xavier_NX/blob/master/here2.yaml) yaml file from my repo.
