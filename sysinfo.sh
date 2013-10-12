#!/bin/bash
BB2=/bin/busybox
echo "Mount & system info search"
echo $1 > /dev/ttyprintk

if [ x$1 == "x12" ]; then
	$BB2 mount -o bind /.secondrom/media/0/multirom/roms/2nd/system /system
elif [ x$1 == "x13" ]; then
	$BB2 mount -o bind /.secondrom/media/0/multirom/roms/3rd/system /system
	echo "3rd Boot Scripts"
else
	$BB2 mount -t ext4 /dev/mmcblk0p$1 /system
fi

[ "`$BB2 grep -i ro.build.version.release=4.3 /system/build.prop`" ] && echo "1" > /system/etc/JB43
[ "`$BB2 grep -i ro.build.version.release=4.2 /system/build.prop`" ] && echo "1" > /system/etc/JB42
[ "`$BB2 grep -i ro.miui /system/build.prop`" ] && echo "1" > /system/etc/MIUI
if [ -f /system/etc/JB43 ]; then
	$BB2 mv -f /res/misc/jb43/* /
	$BB2 rm /system/etc/JB43
elif [ -f /system/etc/JB42 ]; then
	if [ -f /system/etc/MIUI ]; then
		$BB2 cp -a /res/misc/miui/* /
		$BB2 rm /system/etc/JB42
		$BB2 rm /system/etc/MIUI
	else
		$BB2 mv -f /res/misc/jb42/* /
		$BB2 rm /system/etc/JB42
	fi

fi
$BB2 umount -l /system
$BB2 umount -l /.secondrom


