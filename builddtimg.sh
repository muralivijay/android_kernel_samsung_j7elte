#!/bin/bash

KERNELDIR=/home/muralivijay/samsung/nougat
MYOUT=$KERNELDIR/arch/arm64/boot
ABDIR=$KERNELDIR/dtmaker
MYTOOLS=$ABDIR/mkdtbhbootimg/bin

# copy a temp ramdisk to make a temp boot image
cp $ABDIR/ramdisk/boot.img-ramdisk.gz $MYOUT/

cd $MYOUT
mkdir $MYOUT/j7elte

# Compile the dt for J7elte
cp dts/exynos7580-j7elte_rev00.dtb j7elte/
cp dts/exynos7580-j7elte_rev04.dtb j7elte/
cp dts/exynos7580-j7elte_rev06.dtb j7elte/

# a workaround to get the dt.img for j7elte
$MYTOOLS/mkbootimg --kernel Image --ramdisk boot.img-ramdisk.gz --dt_dir j7elte -o boot-new.img
mkdir $MYOUT/tmp
$MYTOOLS/unpackbootimg -i boot-new.img -o tmp
mkdir -p $ABDIR/zipsrc/devices/j7elte/
cp $MYOUT/tmp/boot-new.img-dt $ABDIR/zipsrc/devices/j7elte/dt.img
rm -rf $MYOUT/tmp
rm $MYOUT/boot-new.img

# copy the kernel
cp Image $ABDIR/zipsrc/kernel/zImage

# cleanup
rm -rf $MYOUT/j7elte/
rm $MYOUT/boot.img-ramdisk.gz

# make the flashable zip new ramdisk
#cd $ABDIR/zipsrc
#cp ramdisk/ramdisk-new.zip kernel/ramdisk.zip
#zip -r smj700f-stock.zip kernel/ bootimgtools/ add-ons/ META-INF/ devices/
#rm $ABDIR/zipsrc/devices/j7elte/dt.img
#rm $ABDIR/zipsrc/kernel/zImage
#rm $ABDIR/zipsrc/kernel/ramdisk.zip
