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
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/swsync
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/pbsync
add wave -noupdate -height 30 -format Logic /tb_top_VGA/i_top_VGA/countstart
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_memory2/pixelhorizontal_i
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_memory2/pixelvertical_i
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_memory2/pixelcount_s
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_memory1/addr_rom1_o
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_sourcemultiplexer/position_horizontal1
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_sourcemultiplexer/position_horizontal2
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_sourcemultiplexer/position_vertical1
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_sourcemultiplexer/position_vertical2
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_sourcemultiplexer/position_horizontal_counter
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_sourcemultiplexer/position_vertical_counter
add wave -noupdate -height 30 -format Logic /tb_top_vga/i_top_VGA/i_sourcemultiplexer/buttonstate_s

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left
