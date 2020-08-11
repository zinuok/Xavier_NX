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
bla~

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


