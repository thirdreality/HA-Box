#!/bin/sh

reset_zigbee_module()
{
    # pin A113X_RST_ZG: GPIOA_16
    echo 469 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio469/direction

    # reset the 5189 module first
    echo 0 > /sys/class/gpio/gpio469/value
    sleep 0.1
    echo 1 > /sys/class/gpio/gpio469/value

    echo 469 > /sys/class/gpio/unexport
}

zigbee_enter_isp_mode()
{
    echo 468 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio468/direction
    echo 0 > /sys/class/gpio/gpio468/value
    sleep 0.1

    reset_zigbee_module
    sleep 0.1
    echo 1 > /sys/class/gpio/gpio468/value

    echo 468 > /sys/class/gpio/unexport
}

disable_zigbee_isp()
{
    echo 468 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio468/direction
    echo 1 > /sys/class/gpio/gpio468/value
    sleep 0.1
    echo 468 > /sys/class/gpio/unexport
}

flash_zigbee()
{
    zigbee_enter_isp_mode
	/usr/lib/firmware/jn5189/JN5189Programmer -s ttyAML3 -p /usr/lib/firmware/jn5189/ZiGate.bin
	disable_zigbee_isp
}


case "$1" in
    start)
	echo "JN5189: start..."
    disable_zigbee_isp
    reset_zigbee_module
    ;;

    restart)
    echo "JN5189: restart..."
	disable_zigbee_isp
    reset_zigbee_module
    ;;

	flash)
    echo "JN5189: restart..."
	flash_zigbee
    disable_zigbee_isp
    reset_zigbee_module
    ;;

    *)
    echo "Usage: $0 {start|restart|flash}"
    exit 1
    ;;
esac