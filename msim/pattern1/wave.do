onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_pattern1/clk_i
add wave -noupdate -height 30 -format Logic /tb_pattern1/reset_i

add wave -divider -height 30 "INPUT"
add wave -noupdate -height 30 -radix Unsigned /tb_pattern1/pixelhorizontal_i
add wave -noupdate -height 30 -format Logic /tb_pattern1/switch_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_pattern1/pattern1_r_o
add wave -noupdate -height 30 -format Logic /tb_pattern1/pattern1_g_o
add wave -noupdate -height 30 -format Logic /tb_pattern1/pattern1_b_o

add wave -divider -height 30 "INTERNALS"
add wave -noupdate -height 30 -radix Unsigned /tb_pattern1/i_pattern1/P_color/v_count

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left
