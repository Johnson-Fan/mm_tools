#
# Author: Minux
# Author: Xiangfu Liu <xiangfu@openmobilefree.net>
# Author: Mikeqin <Fengling.Qin@gmail.com>
#
# This is free and unencumbered software released into the public domain.
# For details see the UNLICENSE file at the root of the source tree.
#
# ----- Customer ----------------------------------------------------------
BATCHFILE	:= $(shell mktemp)
HARDWARE_NAME	= mm

isedir  ?= /home/Xilinx/14.6/ISE_DS
xil_env ?= . $(isedir)/settings$(shell getconf LONG_BIT).sh &>/dev/null

.PHONY: download reflash load

download:
	wget http://downloads.canaan-creative.com/software/avalon4/mm/latest/mm.mcs -O ./mm.mcs
	wget http://downloads.canaan-creative.com/software/avalon4/mm/latest/mm.bit -O ./mm.bit

# Bitstream rules
# TODO: how to setCable -baud 12000000
reflash: $(HARDWARE_NAME).mcs
	echo setmode -bs	>> $(BATCHFILE)
	echo setcable -p auto	>> $(BATCHFILE)
	echo identify		>> $(BATCHFILE)
	echo attachFlash -p 1 -spi W25Q80BV		>> $(BATCHFILE)
	echo assignfiletoattachedflash -p 1 -file $<	>> $(BATCHFILE)
	echo program -p 1 -dataWidth 4 -spionly -erase -loadfpga >> $(BATCHFILE)
	echo exit		>> $(BATCHFILE)
	/bin/bash -c '$(xil_env) && impact -batch $(BATCHFILE)'
	@rm -f $(BATCHFILE)

load: $(HARDWARE_NAME).bit
	echo setmode -bs	>> $(BATCHFILE)
	echo setcable -p auto	>> $(BATCHFILE)
	echo identify		>> $(BATCHFILE)
	echo assignfile -p 1 -file $^ >> $(BATCHFILE)
	echo program -p 1	>> $(BATCHFILE)
	echo exit		>> $(BATCHFILE)
	/bin/bash -c '$(xil_env) && impact -batch $(BATCHFILE)'
	@rm -f $(BATCHFILE)

