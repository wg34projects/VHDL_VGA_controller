vsim -t ns -novopt -lib work work.tb_prescaler
view *
do prescaler_wave.do
run 500 ns
