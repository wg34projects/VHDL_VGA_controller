onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/clk_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/reset_i

add wave -divider -height 30 "INPUT"
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/sel_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pbsync_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory1_r_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory1_g_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory1_b_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory2_r_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory2_g_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/memory2_b_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern1_r_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern1_g_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern1_b_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern2_r_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern2_g_i
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/pattern2_b_i
add wave -noupdate -height 30 -radix Unsigned /tb_sourcemultiplexer/pixelhorizontal_i
add wave -noupdate -height 30 -radix Unsigned /tb_sourcemultiplexer/pixelvertical_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/red_mux_o
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/green_mux_o
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/blue_mux_o
add wave -noupdate -height 30 -format Logic /tb_sourcemultiplexer/countstart_o

add wave -divider -height 30 "INTERNAL"
add wave -noupdate -height 30 -radix Unsigned tb_sourcemultiplexer/i_sourcemultiplexer/s_x
add wave -noupdate -height 30 -radix Unsigned tb_sourcemultiplexer/i_sourcemultiplexer/s_y
add wave -noupdate -height 30 -format Logic tb_sourcemultiplexer/i_sourcemultiplexer/s_updown
add wave -noupdate -height 30 -radix Unsigned tb_sourcemultiplexer/i_sourcemultiplexer/s_slow
add wave -noupdate -height 30 -format Logic tb_sourcemultiplexer/i_sourcemultiplexer/s_special
add wave -noupdate -height 30 -radix Unsigned tb_sourcemultiplexer/i_sourcemultiplexer/s_speed
add wave -noupdate -height 30 -format Logic tb_sourcemultiplexer/i_sourcemultiplexer/s_countstart

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 400
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left

