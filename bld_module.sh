#!/bin/bash

# Description: This script is used to build the kernel module.
# Primarily meant for cross compiling the kernel module in fpga setup.
# To be made part of the bigger build script or put in the top level folder.


export TOP_FOLDER=`pwd`
cd $TOP_FOLDER
echo "Current working dir (TOP_FOLDER): $TOP_FOLDER"
export PATH=/proj/local/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin:$PATH
export ARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-
export ARM_GCC_TOOLCHAIN=/proj/local/gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-gcc
set -e

if [ -e linux-socfpga ]
    then
    echo "linux-socfpga exists"
    cd linux-socfpga
    export KERNEL_SRC=`pwd`
    echo "KERNEL_SRC: $KERNEL_SRC"
    cd $TOP_FOLDER
else
    echo "linux-socfpga does not exist"
    echo "cloning linux-socfpga.."
    git clone -b socfpga-6.6.22-lts git@github.com:tsisw/linux-socfpga.git --depth=1;
    cd linux-socfpga/
    echo "building linux-socfpga.."
    make clean && make mrproper
    make defconfig
    #make -j $(nproc) Image dtbs
    #make -j $(nproc) Image.lzma dtbs
    make modules
    export KERNEL_SRC=`pwd`
    echo "KERNEL_SRC: $KERNEL_SRC"
    cd $TOP_FOLDER
fi


if [ -e contig_mem ]
    then
    cd contig_mem
    if [ -e udmabuf ]
        then
        cd udmabuf
        make clean
        make all
        if [ -e udmabuf.ko ]
            then
            echo "module built successfully"
        else
            echo "module build failed"
        fi
        if [ -e usage_example ]
            then
            cd usage_example
            make clean
            make all
        else
            echo "usage_example directory does not exist"
        fi
    else
        echo "udambuf directory does not exist"
    fi
else
    echo "contig_mem does not exist"
    mkdir contig_mem
    cd contig_mem
    git clone git@github.com:tsisw/udmabuf.git
    cd udmabuf
    make clean
    make all
    if [ -e udmabuf.ko ]
        then
        echo "module built successfully"
    else
        echo "module build failed"
    fi
    if [ -e usage_example ]
        then
        cd usage_example
        make clean
        make all
    else
        echo "usage_example directory does not exist"
    fi
fi