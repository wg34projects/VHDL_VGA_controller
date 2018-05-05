vsim -t ns -novopt -lib work work.tb_prescaler
view *
do wave.do
run 750 ns
