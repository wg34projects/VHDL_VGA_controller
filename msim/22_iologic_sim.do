vsim -t ns -novopt -lib work work.tb_iologic
view *
do iologic_wave.do
run 15ms
