#!/bin/bash

# ref link: https://developer.ridgerun.com/wiki/index.php?title=Raspberry_Pi_HQ_camera_IMX477_Linux_driver_for_Jetson#Compatibility_with_NVIDIA.C2.AEJetson.E2.84.A2_Platforms

# Get input #
if [ $# -ne 1 ] ; then
	echo "usage: ./imx477.sh [path of directory where the SDK Manager placed the JetPack_4.4_Linux_JETSON_[PLATFORM]_DEVKIT folder]"
	echo "for xavier nx, [PLATFORM] is 'XAVIER_NX'"
	echo "ex) ./imx477.sh /home/zinuok/nvidia/nvidia_sdk"
	exit
fi

JETPACK_DIR=$1
#JETPACK_DIR=~/nvidia/nvidia_sdk
echo "$JETPACK_DIR"


# Download the Jetpack 4.4 sources #
cd ~/Downloads
wget https://developer.nvidia.com/embedded/L4T/r32_Release_v4.3/sources/T186/public_sources.tbz2
tar -xvf public_sources.tbz2
cd Linux_for_Tegra/source/public/
tar -xvf kernel_src.tbz2
JETSON_KERNEL_SOURCE=$JETPACK_DIR/JetPack_4.4_Linux_JETSON_XAVIER_NX_DEVKIT/Linux_for_Tegra/source/
mkdir -p $JETSON_KERNEL_SOURCE
mv hardware/ kernel/ $JETSON_KERNEL_SOURCE


# Patch instructions #
cd $HOME
git clone https://github.com/RidgeRun/NVIDIA-Jetson-IMX477-RPIV3.git
KERNEL_PATCH=$HOME/NVIDIA-Jetson-IMX477-RPIV3
cp -r $KERNEL_PATCH/patches_nx/ $JETSON_KERNEL_SOURCE
mv $JETSON_KERNEL_SOURCE/patches_nx/ $JETSON_KERNEL_SOURCE/patches/
cd $JETSON_KERNEL_SOURCE
quilt push


# Kernel build instructions #
mkdir -p $HOME/l4t-gcc
cd $HOME/l4t-gcc
wget http://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
tar xf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz

cd $JETSON_KERNEL_SOURCE/../
mkdir -p modules/
mkdir -p packages/
mkdir -p dtb/

CROSS_COMPILE=$HOME/l4t-gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
KERNEL_OUT=$JETSON_KERNEL_SOURCE/../build
KERNEL_MODULES_OUT=$JETSON_KERNEL_SOURCE/../modules

cd $JETSON_KERNEL_SOURCE
make -C kernel/kernel-4.9/ ARCH=arm64 O=$KERNEL_OUT tegra_defconfig
sudo apt-get install -y libncurses5-dev libncursesw5-dev
make -C kernel/kernel-4.9/ ARCH=arm64 O=$KERNEL_OUT menuconfig

echo "restart"
make -C kernel/kernel-4.9/ ARCH=arm64 O=$KERNEL_OUT CROSS_COMPILE=${CROSS_COMPILE} -j4 Image
make -C kernel/kernel-4.9/ ARCH=arm64 O=$KERNEL_OUT CROSS_COMPILE=${CROSS_COMPILE} -j4 dtbs
make -C kernel/kernel-4.9/ ARCH=arm64 O=$KERNEL_OUT CROSS_COMPILE=${CROSS_COMPILE} -j4 modules
make -C kernel/kernel-4.9/ ARCH=arm64 O=$KERNEL_OUT modules_install INSTALL_MOD_PATH=$KERNEL_MODULES_OUT

cd $JETSON_KERNEL_SOURCE/../
cp build/arch/arm64/boot/dts/tegra194-p3668-all-p3509-0000.dtb ./kernel/dtb
cp build/arch/arm64/boot/Image ./kernel


# Flash the Jetson #
echo "Make sure the board is in Recovery mode and connect Host with USB cable"
sudo ./flash.sh -r -k kernel-dtb -d kernel/dtb/tegra194-p3668-all-p3509-0000.dtb jetson-xavier-nx-devkit mmcblk0p1
echo "flashing finished!"


# finish #
echo ""
echo "####################################################################"
echo "After flashing, you should move following files to your jetson board"
echo "[P]: host PC   [N]: Nvidia Jetson board.(Xavier NX)"
echo "--------------------------------------------------------------------"
echo ""

echo "1) move kernel Image"
echo "[P]: $ scp ./kernel/Image <nvidia-nx-user>@<nvidia-nx-ip>:/tmp/"
echo "[N]: $ sudo mv /tmp/Image /boot/"
echo "--------------------------------------------------------------------"
echo ""

echo "2) move kernel modules"
echo "[P]: $ cd .../JetPack_4.4_Linux_JETSON_XAVIER_NX_DEVKIT/Linux_for_Tegra/modules/lib/modules/4.9.140"
echo "[P]: $ unlink build && unlink source"
echo "[P]: $ scp -r ../4.9.140/ <nvidia-nx-user>@<nvidia-nx-ip>:/tmp/"
echo "[N]: $ sudo mv /tmp/4.9.140/ /lib/modules/"
echo "[N]: $ sudo reboot"
echo "--------------------------------------------------------------------"
echo ""

echo "3) move camera ISP file"
echo "[P]: $ cd ~/NVIDIA-Jetson-IMX477-RPIV3/"
echo "[P]: $ scp ./li-camera-calibration-files/camera_overrides.isp <nvidia-nx-user>@<nvidia-nx-ip>:~/"
echo "[N]: $ cp ~/camera_overrides.isp /var/nvidia/nvcam/settings"
echo "[N]: $ sudo chmod 664 /var/nvidia/nvcam/settings/camera_overrides.isp"
echo "[N]: $ sudo chown root:root /var/nvidia/nvcam/settings/camera_overrides.isp"
echo "--------------------------------------------------------------------"
echo ""

echo "< IMX477 usage at jetson board >"
echo "refer 'Example pipelines' in this link: "
echo "https://github.com/RidgeRun/NVIDIA-Jetson-IMX477-RPIV3"
echo "####################################################################"

