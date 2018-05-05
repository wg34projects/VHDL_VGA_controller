vsim -t ns -novopt -lib work work.tb_sourcemultiplexer
view *
do wave.do
run 5 ms
