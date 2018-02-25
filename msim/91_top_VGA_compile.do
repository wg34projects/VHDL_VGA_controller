# copy .mif file (which holds content of 1k ROM) into ModelSim simulation directory
file copy -force ../generate/rom1/rom1/rom1.mif ./

# compile simulation model of generated 1k ROM
vlog ../generate/rom1/rom1/blk_mem_gen_v8_3_2/simulation/blk_mem_gen_v8_3.v
vcom ../generate/rom1/rom1/synth/rom1.vhd

# compile Xilinx GLBL module (required for proper initialization
# of all generated  Xilinx macros during simulation)
vlog ../generate/glbl.v

vcom ../vhdl/memory1_.vhd
vcom ../vhdl/memory1_rtl.vhd

vcom ../vhdl/pattern1_.vhd
vcom ../vhdl/pattern1_rtl.vhd

vcom ../vhdl/pattern2_.vhd
vcom ../vhdl/pattern2_rtl.vhd

vcom ../vhdl/sourcemultiplexer_.vhd
vcom ../vhdl/sourcemultiplexer_rtl.vhd

vcom ../vhdl/iologic_.vhd
vcom ../vhdl/iologic_rtl.vhd

vcom ../vhdl/prescaler_.vhd
vcom ../vhdl/prescaler_rtl.vhd

vcom ../vhdl/vga_monitor_.vhd
vcom ../vhdl/vga_monitor_sim.vhd

vcom ../vhdl/vgacontroller_.vhd
vcom ../vhdl/vgacontroller_rtl.vhd

vcom ../vhdl/top_VGA_.vhd
vcom ../vhdl/top_VGA_rtl.vhd

vcom ../tb/tb_top_VGA_.vhd
vcom ../tb/tb_top_VGA_sim.vhd

