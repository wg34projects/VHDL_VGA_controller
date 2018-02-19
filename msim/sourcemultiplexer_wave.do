onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/clk_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/reset_i

add wave -divider -height 30 "INPUT"
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/sel_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory1_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory2_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern1_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern2_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/rgb_o

add wave -divider -height 30 "INTERNALS"
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/i_sourcemultiplexer/s_rgb

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left

