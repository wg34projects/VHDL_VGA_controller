vsim -t ns -novopt -lib work work.tb_top_VGA
view *
do wave.do
run 1000 ms
