#!/bin/bash

UBOOT=`find ../../cache/sources/u-boot/ -name u-boot.bin -type f -print -quit`
IMAGE=`find ../../output/images -name '*.img' -type f -print -quit`

./convert.sh ${IMAGE} d1 armbian ${UBOOT}
