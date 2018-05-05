vsim -t ns -novopt -lib work work.tb_pattern1
view *
do wave.do
run 250 ns
