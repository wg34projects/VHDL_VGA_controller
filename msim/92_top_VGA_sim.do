vsim -t ns -novopt -lib work work.tb_top_VGA
view *
do top_VGA_wave.do
run 1000 ms
