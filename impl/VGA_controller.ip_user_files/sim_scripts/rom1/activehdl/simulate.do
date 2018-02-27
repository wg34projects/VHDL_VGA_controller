onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+rom1 -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L xpm -O5 xil_defaultlib.rom1 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {rom1.udo}

run -all

endsim

quit -force
