# CHD - BEL4 - VGA Controller

## misc. status reports

### the goal

| Description |
|--------------------|
| ![alt text](doku/goal.png "goal VGA") |

### wordcount / linecount

#### Status 23.02.2018 23:00 Output is working

	~/WorkDir/VHDL_VGA_controller/vhdl helmutresch > wc *.vhd -l
	  116 iologic_rtl.vhd
	   34 iologic_.vhd
	  109 pattern1_rtl.vhd
	   37 pattern1_.vhd
	  145 pattern2_rtl.vhd
	   37 pattern2_.vhd
	   56 prescaler_rtl.vhd
	   31 prescaler_.vhd
	   75 sourcemultiplexer_rtl.vhd
	   47 sourcemultiplexer_.vhd
	  267 top_VGA_rtl.vhd
	   40 top_VGA_.vhd
	  121 vgacontroller_rtl.vhd
	   38 vgacontroller_.vhd
	 1153 insgesamt

	~/WorkDir/VHDL_VGA_controller/tb helmutresch > wc *.vhd -l
	  104 tb_iologic_sim.vhd
	   24 tb_iologic_.vhd
	   73 tb_prescaler_sim.vhd
	   24 tb_prescaler_.vhd
	  275 tb_sourcemultiplexer_sim.vhd
	   25 tb_sourcemultiplexer_.vhd
	   94 tb_top_VGA_sim.vhd
	   27 tb_top_VGA_.vhd
	  105 tb_vgacontroller_sim.vhd
	   27 tb_vgacontroller_.vhd
	  778 insgesamt
	~/WorkDir/VHDL_VGA_controller/tb helmutresch > 

#### Status 27.02.2018 21:00 Full feature synthesized

	~/WorkDir/VHDL_VGA_controller helmutresch > wc ./vhdl/*.vhd -l
	  119 ./vhdl/iologic_rtl.vhd
	   37 ./vhdl/iologic_.vhd
	  102 ./vhdl/memory1_rtl.vhd
	   40 ./vhdl/memory1_.vhd
	   83 ./vhdl/memory2_rtl.vhd
	   41 ./vhdl/memory2_.vhd
	  109 ./vhdl/pattern1_rtl.vhd
	   37 ./vhdl/pattern1_.vhd
	  145 ./vhdl/pattern2_rtl.vhd
	   37 ./vhdl/pattern2_.vhd
	   59 ./vhdl/prescaler_rtl.vhd
	   34 ./vhdl/prescaler_.vhd
	  246 ./vhdl/sourcemultiplexer_rtl.vhd
	   53 ./vhdl/sourcemultiplexer_.vhd
	  385 ./vhdl/top_VGA_rtl.vhd
	   40 ./vhdl/top_VGA_.vhd
	  121 ./vhdl/vgacontroller_rtl.vhd
	   38 ./vhdl/vgacontroller_.vhd
	  476 ./vhdl/vga_monitor_sim.vhd
	   60 ./vhdl/vga_monitor_.vhd
	 2262 insgesamt
	~/WorkDir/VHDL_VGA_controller helmutresch > 

	~/WorkDir/VHDL_VGA_controller helmutresch > wc ./tb/*.vhd -l
	  104 ./tb/tb_iologic_sim.vhd
	   24 ./tb/tb_iologic_.vhd
	   73 ./tb/tb_prescaler_sim.vhd
	   24 ./tb/tb_prescaler_.vhd
	  279 ./tb/tb_sourcemultiplexer_sim.vhd
	   25 ./tb/tb_sourcemultiplexer_.vhd
	  105 ./tb/tb_top_VGA_sim.vhd
	   27 ./tb/tb_top_VGA_.vhd
	  105 ./tb/tb_vgacontroller_sim.vhd
	   27 ./tb/tb_vgacontroller_.vhd
	  793 insgesamt
	~/WorkDir/VHDL_VGA_controller helmutresch > 

#### Status 28.02.2018 23:00 Timing problems solved, 99% finished

	~/WorkDir/VHDL_VGA_controller helmutresch > wc ./vhdl/*.vhd -l
	  119 ./vhdl/iologic_rtl.vhd
	   37 ./vhdl/iologic_.vhd
	  165 ./vhdl/memory1_rtl.vhd
	   41 ./vhdl/memory1_.vhd
	   83 ./vhdl/memory2_rtl.vhd
	   42 ./vhdl/memory2_.vhd
	  109 ./vhdl/pattern1_rtl.vhd
	   37 ./vhdl/pattern1_.vhd
	  145 ./vhdl/pattern2_rtl.vhd
	   37 ./vhdl/pattern2_.vhd
	   59 ./vhdl/prescaler_rtl.vhd
	   34 ./vhdl/prescaler_.vhd
	  246 ./vhdl/sourcemultiplexer_rtl.vhd
	   53 ./vhdl/sourcemultiplexer_.vhd
	  385 ./vhdl/top_VGA_rtl.vhd
	   40 ./vhdl/top_VGA_.vhd
	  121 ./vhdl/vgacontroller_rtl.vhd
	   38 ./vhdl/vgacontroller_.vhd
	  476 ./vhdl/vga_monitor_sim.vhd
	   60 ./vhdl/vga_monitor_.vhd
	 2327 insgesamt
	~/WorkDir/VHDL_VGA_controller helmutresch > 

	~/WorkDir/VHDL_VGA_controller helmutresch > wc ./tb/*.vhd -l
	  104 ./tb/tb_iologic_sim.vhd
	   24 ./tb/tb_iologic_.vhd
	   73 ./tb/tb_prescaler_sim.vhd
	   24 ./tb/tb_prescaler_.vhd
	  279 ./tb/tb_sourcemultiplexer_sim.vhd
	   25 ./tb/tb_sourcemultiplexer_.vhd
	  105 ./tb/tb_top_VGA_sim.vhd
	   27 ./tb/tb_top_VGA_.vhd
	  105 ./tb/tb_vgacontroller_sim.vhd
	   27 ./tb/tb_vgacontroller_.vhd
	  793 insgesamt
	~/WorkDir/VHDL_VGA_controller helmutresch > 

### schematic

[PDF Download VIVADO 28.02](doku/28.02.2018_schematic.pdf)
[PDF Download VIVADO 22.02](doku/22.02.2018_schematic.pdf)

### comments timing and error

[PNG Download VIVADO 28.02](doku/28.02.2018_errors.png)
[PNG Download VIVADO 22.02](doku/22.02.2018_errors.png)

### code parts and latest revision

- 1% for documentation (code style check, comments, header)
- R = revision in header = used to divide project into units
- U = unit = steps in the project

| R | U | entity | v | date | % entity | architecture | % code | remark |
| -------- | ---- | ------ | ------- | ---- | -------- | ------------ | ------ | ------ |
| 0 | I/O | prescaler_ | 0.4 | 27.02 | 99% | prescaler_rtl | 99% | - |
| 0 | I/O | iologic_ | 0.4 | 27.02 | 99% | iologic_rtl | 99% | - |
| 0 | I/O | sourcemultiplexer_ | 0.4 | 27.02 | 99% | sourcemultiplexer_rtl | 99% | - |
| 1 | VGA | vgacontroller_ | 0.3 | 22.02 | 99% | vgacontroller_rtl | 99% | - |
| 1 | VGA | pattern1_ | 0.3 | 22.02 | 99% | pattern1_rtl | 94% | timing-check |
| 1 | VGA | pattern2_ | 0.3 | 22.02 | 99% | pattern2_rtl | 94% | timing-check |
| 1 | VGA | top_VGA_ | 0.3 | 22.02 | 99% | top_VGA_rtl | 99% | synthesized |
| 2 | MEM | memory1_ | 0.3 | 28.2 | 99% | memory1_rtl | 99% | timing-check |
| 2 | MEM | memory2_ | 0.3 | 28.2 | 99% | memory2_rtl | 99% | timing-check |

### output monitor FHTW

| pattern | 640x480 |
|-------- | ------- |
| pattern 1 	| ![alt text](doku/frame01.png "pattern 1") |
| pattern 1+2 |  ![alt text](doku/frame02.png "pattern 1+2") |
| pattern 2 |  ![alt text](doku/frame03.png "pattern 2") |

### output VGA real monitor Samsung Vienna

https://www.youtube.com/watch?v=7fyMXrCMvPQ&feature=youtu.be

### output VGA real monitor Samsung Styria

| pattern | 640x480 |
|-------- | ------- |
| pattern 1 | ![alt text](doku/fotopattern01.jpg "pattern 1") |
| pattern 2 | ![alt text](doku/fotopattern02.jpg "pattern 2") |

### output monitor FHTW with testpicture from ROM

| pattern | 640x480 |
|-------- | ------- |
| pattern 2+3 | ![alt text](doku/frame04.png "pattern 1") |
| pattern 3 |  ![alt text](doku/frame05.png "pattern 1+2") |

### output VGA real monitor Samsung Vienna with testpicture from ROM

https://www.youtube.com/watch?v=oO-Cmue0pPw

### output VGA real monitor Samsung Vienna with all features

https://www.youtube.com/watch?v=A3abx1It04A
