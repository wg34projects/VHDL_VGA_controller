vsim -t ns -novopt -lib work work.tb_pattern2
view *
do wave.do
run 250 ns
