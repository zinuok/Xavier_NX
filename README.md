# Xavier_NX
***
setting guide for Nvidia Xavier NX (arm architecture)
# Index
### 1. Intel Realsense camera: D435i
### 2. CSI camera: IMX477
### 3. Teamviewer for arm-architecture
***
<br><br>

## 1. Intel Realsense camera: D435i
from [IntelRealSense](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)
+ **version info**
    + SDK - 2.36.0
    + Firmware: 5.12.5


+ **Download the complete source tree with git**
```
$ git clone https://github.com/IntelRealSense/librealsense.git
```

+ **Download and unzip the latest stable version from [here](https://github.com/IntelRealSense/librealsense/releases)**

+ **unzip**
```
$ tar -xvf librealsense-[version].tar.gz
```
+ **prepare Ubuntu setup**
```
$ sudo apt-get update && sudo apt-get upgrade
$ sudo apt-get install -y git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev
```

+ **for Ubuntu 18.04**
```
$ sudo apt-get install -y libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev
```

+ **Run CMake(if you don't have CUDA, remove the last line)**
```
$ cmake ../ -DBUILD_EXAMPLES=true -DFORCE_LIBUVC=true -DBUILD_WITH_CUDA=true
```
+ **recompile and install librealsense binaries**
```
$ sudo make uninstall && make clean
$ make -j4 && sudo make install
```
<br>

## 2. CSI camera: IMX477
shell script for using IMX477 Raspberry camera with Jetson Xavier NX is included.<br>
This script is just a automated collection of install commands from [Install guide(Ridgerun)](https://developer.ridgerun.com/wiki/index.php?title=Raspberry_Pi_HQ_camera_IMX477_Linux_driver_for_Jetson#Compatibility_with_NVIDIA.C2.AEJetson.E2.84.A2_Platforms).<br>
+ **usage**
```
$ git clone https://github.com/zinuok/Xavier_NX.git
$ cd Xavier_NX
$ chmod +x imx477.sh && ./imx477.sh
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

## 3. Teamviewer for arm-architecture
from [here](https://medium.com/@hmurari/how-to-install-teamviewer-on-a-jetson-nano-38080f87f039)
+ **Download the TeamViewer host for Raspberry Pi**<br>
[Download link](https://www.teamviewer.com/en-us/download/raspberry-pi/)

+ **add armv7–32bit architecture for apt packages.**
```
$ sudo dpkg --add-architecture armhf
$ sudo apt update
$ sudo apt install -y libxtst6:armhf
```

+ **Install Teamviewer** (some error may occur. it's normal in arm-based architecture)
```
$ cd ~/Downloads
$ sudo dpkg -i teamviewer-host_[version]_armhf.deb
```

+ **Fix the installation errors observed above**
```
$ sudo apt install -f
```

+ **Enable Teamviewer as a Daemon**
```
$ sudo systemctl enable teamviewerd.service
$ sudo service teamviewerd start
```

+ **Adding aarch64 architecture info**<br>
If you try to execute teamviewer, 'unknown architecture 'aarch64'' error will occur.<br>
To avoid this problem, you have to add the architecture info.<br><br>
access 'tvw_main' and change "( armv7l )" to "( armv71 | aarch64 )". Make sure to 'space' between them.
```
$ vi /opt/teamviewer/tv_bin/script/tvw_main 
```



+ **Execute**
```
$ teamviewer
```

