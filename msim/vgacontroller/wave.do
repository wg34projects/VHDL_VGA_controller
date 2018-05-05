onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/clk_i
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/reset_i

add wave -divider -height 30 "INPUT"
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/pixenable_i
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/red_i
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/green_i
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/blue_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/hsync_o
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/vsync_o
add wave -noupdate -height 30 -radix Unsigned /tb_vgacontroller/pixelhorizontal_o
add wave -noupdate -height 30 -radix Unsigned /tb_vgacontroller/pixelvertical_o
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/red_o
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/green_o
add wave -noupdate -height 30 -format Logic /tb_vgacontroller/blue_o

add wave -divider -height 30 "INTERNALS"
add wave -noupdate -height 30 -radix Unsigned /tb_vgacontroller/i_vgacontroller/s_pixelhorizontal
add wave -noupdate -height 30 -radix Unsigned /tb_vgacontroller/i_vgacontroller/s_pixelvertical

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left
