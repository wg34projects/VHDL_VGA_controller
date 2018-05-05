vsim -t ns -novopt -lib work work.tb_iologic
view *
do wave.do
run 15ms
