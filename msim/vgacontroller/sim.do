vsim -t ns -novopt -lib work work.tb_vgacontroller
view *
do wave.do
run 20 ms
