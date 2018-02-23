vsim -t ns -novopt -lib work work.tb_vgacontroller
view *
do vgacontroller_wave.do
run 20 ms
