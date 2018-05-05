onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_iologic/clk_i
add wave -noupdate -height 30 -format Logic /tb_iologic/reset_i

add wave -divider -height 30 "INPUT"
add wave -noupdate -height 30 -format Logic /tb_iologic/sw_i
add wave -noupdate -height 30 -format Logic /tb_iologic/pb_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_iologic/swsync_o
add wave -noupdate -height 30 -format Logic /tb_iologic/pbsync_o

add wave -divider -height 30 "INTERNALS"
add wave -noupdate -height 30 -radix Unsigned /tb_iologic/i_iologic/s_enctr
add wave -noupdate -height 30 -radix Unsigned /tb_iologic/i_iologic/s_10khzen
add wave -noupdate -height 30 -format Logic /tb_iologic/i_iologic/s_swsync
add wave -noupdate -height 30 -format Logic /tb_iologic/i_iologic/s_pbsync
add wave -noupdate -height 30 -radix Unsigned /tb_iologic/i_iologic/s_debcnt
add wave -noupdate -height 30 -format Logic /tb_iologic/i_iologic/s_button

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left
