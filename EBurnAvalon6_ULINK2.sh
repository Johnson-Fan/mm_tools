#!/bin/bash
cd ~/software/mm_tools
while true; do
	make isedir=/opt/Xilinx/14.6/ISE_DS erase && \
	make reflash_ulink2 && \
	sleep 2 && \
	make isedir=/opt/Xilinx/14.6/ISE_DS reflash;
echo;
read -p "Press any key to burn next"
done
