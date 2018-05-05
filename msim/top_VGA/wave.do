onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_top_VGA/clk_i
add wave -noupdate -height 30 -format Logic /tb_top_VGA/reset_i

add wave -divider -height 30 "INPUT"
add wave -noupdate -height 30 -format Logic /tb_top_VGA/sw_i
add wave -noupdate -height 30 -format Logic /tb_top_VGA/pb_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/red_o
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/green_o
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/blue_o
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/hsync_o
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/vsync_o

add wave -divider -height 30 "INTERNALS"
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/s_swsync
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/s_pbsync
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/s_pixenable
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/s_countstart
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/s_switch
add wave -noupdate -height 30 -radix Unsigned /tb_top_vga/i_top_VGA/s_pixelhorizontal
add wave -noupdate -height 30 -radix Unsigned /tb_top_vga/i_top_VGA/s_pixelvertical

add wave -divider -height 30 "MEMORY1"
add wave -noupdate -height 30 -radix Unsigned /tb_top_vga/i_top_VGA/i_memory1/addr_rom1_o
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_memory1/data_rom1_i

add wave -divider -height 30 "MEMORY2"
add wave -noupdate -height 30 -radix Unsigned /tb_top_vga/i_top_VGA/i_memory2/addr_rom2_o
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_memory2/data_rom2_i

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left