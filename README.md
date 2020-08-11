# Xavier_NX
***
setting guide for Nvidia Xavier NX (arm architecture)
# Index
### 1. Intel Realsense camera: D435i
### 2. CSI camera: IMX477
### 3. Teamviewer for arm-architecture
***
<br><br>

## Intel Realsense camera: D435i
from [IntelRealSense](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)
- version info
+ SDK: 2.36.0
+ Firmware: 5.12.5
```
- Download the complete source tree with git
$ git clone https://github.com/IntelRealSense/librealsense.git

- Download and unzip the latest stable version from here: https://github.com/IntelRealSense/librealsense/releases

- unzip
$ tar -xvf librealsense-[version].tar.gz

- prepare Ubuntu setup
$ sudo apt-get update && sudo apt-get upgrade
$ sudo apt-get install git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev
- for Ubuntu 18.04
$ sudo apt-get install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev

- Building librealsense2 SDK using CMake
- run CMake
cmake \
-DBUILD_EXAMPLES=true \
-DFORCE_LIBUVC=true \
-DBUILD_WITH_CUDA=true \
(if you don't have CUDA, remove the last line)

- recompile and install librealsense binaries
$ sudo make uninstall && make clean
$ make -j4 && sudo make install
```
<br>

## CSI camera: IMX477
shell script for using IMX477 Raspberry camera with Jetson Xavier NX is included.<br>
This scripts is just a automated collection of install commands from [Install guide(Ridgerun)](https://developer.ridgerun.com/wiki/index.php?title=Raspberry_Pi_HQ_camera_IMX477_Linux_driver_for_Jetson#Compatibility_with_NVIDIA.C2.AEJetson.E2.84.A2_Platforms).<br>
+ **usage**
```
$ git clone https://github.com/zinuok/Xavier_NX.git
$ cd Xavier_NX
$ chmod +x imx477.sh && ./imx477.sh
```

this is from [Ridgerun](https://github.com/RidgeRun/NVIDIA-Jetson-IMX477-RPIV3), author of IMX477 driver for Jetson board.<br> 
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

## Teamviewer for arm-architecture
bla~


