onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -divider -height 30 "CLK, RESET"
add wave -noupdate -height 30 -format Logic /tb_prescaler/clk_i
add wave -noupdate -height 30 -format Logic /tb_prescaler/reset_i

add wave -divider -height 30 "OUTPUT"
add wave -noupdate -height 30 -format Logic /tb_prescaler/pixenable_o

add wave -divider -height 30 "INTERNALS"
add wave -noupdate -height 30 -format Logic /tb_prescaler/i_prescaler/s_25mhz
add wave -noupdate -height 30 -radix Unsigned /tb_prescaler/i_prescaler/s_enctr

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -signalnamewidth 0
configure wave -justifyvalue left