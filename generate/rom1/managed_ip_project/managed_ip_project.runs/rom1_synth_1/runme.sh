#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/helmutresch/Xilinx/Vivado/2016.1/ids_lite/ISE/bin/lin64:/home/helmutresch/Xilinx/Vivado/2016.1/bin
else
  PATH=/home/helmutresch/Xilinx/Vivado/2016.1/ids_lite/ISE/bin/lin64:/home/helmutresch/Xilinx/Vivado/2016.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/home/helmutresch/Xilinx/Vivado/2016.1/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/home/helmutresch/Xilinx/Vivado/2016.1/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/helmutresch/WorkDir/VHDL_VGA_controller/generate/rom1/managed_ip_project/managed_ip_project.runs/rom1_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log rom1.vds -m64 -mode batch -messageDb vivado.pb -notrace -source rom1.tcl
