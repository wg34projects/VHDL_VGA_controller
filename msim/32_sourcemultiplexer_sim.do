vsim -t ns -novopt -lib work work.tb_sourcemultiplexer
view *
do sourcemultiplexer_wave.do
run 1200 ns
