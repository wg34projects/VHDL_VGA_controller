onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_pattern2/clk_i
add wave -noupdate -height 30 -format Logic /tb_pattern2/reset_i

add wave -divider -height 30 "INPUT"
add wave -noupdate -height 30 -radix Unsigned /tb_pattern2/pixelhorizontal_i
add wave -noupdate -height 30 -radix Unsigned /tb_pattern2/pixelvertical_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_pattern2/pattern2_r_o
add wave -noupdate -height 30 -format Logic /tb_pattern2/pattern2_g_o
add wave -noupdate -height 30 -format Logic /tb_pattern2/pattern2_b_o

add wave -divider -height 30 "INTERNAL"
add wave -noupdate -height 30 -format Logic /tb_pattern2/i_pattern2/s_chessboardcolor

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left
