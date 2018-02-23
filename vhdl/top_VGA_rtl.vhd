----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : top_VGA_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL TOP Design VGA
----------------------------------------------------------------------------
-- Revisions : 1
-- Date 		Version	Author 	Description
-- 2018.02.19	0.1		Resch	Projectstart VGA Controller, first Timings
-- 2018.02.21	0.2		Resch	Added Pattern Generators and TOP Design
-- 2018.02.22	0.3		Resch	Update TOP Design and first output via
--                              the nice vga app from FHTW to disk
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture struc of top_VGA is

component iologic is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sw_i : in std_logic_vector(15 downto 0);
    pb_i : in std_logic_vector(3 downto 0);
    swsync_o : out std_logic_vector(15 downto 0);
    pbsync_o : out std_logic_vector(3 downto 0)
  );

end component;

component prescaler is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixenable_o : out std_logic
  );

end component;

component sourcemultiplexer is

  port 
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sel_i : in std_logic_vector(2 downto 0);
    memory1_r_i : in std_logic_vector(3 downto 0);
    memory1_g_i : in std_logic_vector(3 downto 0);
    memory1_b_i : in std_logic_vector(3 downto 0);
    memory2_r_i : in std_logic_vector(3 downto 0);
    memory2_g_i : in std_logic_vector(3 downto 0);
    memory2_b_i : in std_logic_vector(3 downto 0);
    pattern1_r_i : in std_logic_vector(3 downto 0);
    pattern1_g_i : in std_logic_vector(3 downto 0);
    pattern1_b_i : in std_logic_vector(3 downto 0);
    pattern2_r_i : in std_logic_vector(3 downto 0);
    pattern2_g_i : in std_logic_vector(3 downto 0);
    pattern2_b_i : in std_logic_vector(3 downto 0);
    red_mux_o : out std_logic_vector(3 downto 0);
	green_mux_o : out std_logic_vector(3 downto 0);
	blue_mux_o : out std_logic_vector(3 downto 0)
  );

end component;

component vgacontroller

  port 
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixenable_i : in std_logic;
	hsync_o : out std_logic;
	vsync_o : out std_logic;
	pixelhorizontal_o : out std_logic_vector(9 downto 0);
	pixelvertical_o : out std_logic_vector(9 downto 0)
  );

end component;

component vga_monitor

  port
  (
    s_reset_i     : in std_logic;
    s_vga_red_i   : in std_logic_vector(3 downto 0);
    s_vga_green_i : in std_logic_vector(3 downto 0);
    s_vga_blue_i  : in std_logic_vector(3 downto 0);
    s_vga_hsync_i : in std_logic;
    s_vga_vsync_i : in std_logic
    ); 

end component;

component pattern1

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixelhorizontal_i : in std_logic_vector(9 downto 0);
	pixelvertical_i : in std_logic_vector(9 downto 0);
    pattern1_r_o : out std_logic_vector(3 downto 0);
	pattern1_g_o : out std_logic_vector(3 downto 0);
	pattern1_b_o : out std_logic_vector(3 downto 0)
  );

end component;

component pattern2

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixelhorizontal_i : in std_logic_vector(9 downto 0);
	pixelvertical_i : in std_logic_vector(9 downto 0);
    pattern2_r_o : out std_logic_vector(3 downto 0);
	pattern2_g_o : out std_logic_vector(3 downto 0);
	pattern2_b_o : out std_logic_vector(3 downto 0)
  );

end component;

signal swsync : std_logic_vector(15 downto 0);
signal pbsync : std_logic_vector(3 downto 0);
signal pixenable : std_logic;

signal memory1_r : std_logic_vector(3 downto 0);
signal memory1_g : std_logic_vector(3 downto 0);
signal memory1_b : std_logic_vector(3 downto 0);

signal memory2_r : std_logic_vector(3 downto 0);
signal memory2_g : std_logic_vector(3 downto 0);
signal memory2_b : std_logic_vector(3 downto 0);

signal pattern1_r : std_logic_vector(3 downto 0);
signal pattern1_g : std_logic_vector(3 downto 0);
signal pattern1_b : std_logic_vector(3 downto 0);

signal pattern2_r : std_logic_vector(3 downto 0);
signal pattern2_g : std_logic_vector(3 downto 0);
signal pattern2_b : std_logic_vector(3 downto 0);

signal red : std_logic_vector(3 downto 0);
signal green : std_logic_vector(3 downto 0);
signal blue : std_logic_vector(3 downto 0);

signal hsync : std_logic;
signal vsync : std_logic;

signal pixelhorizontal : std_logic_vector(9 downto 0);
signal pixelvertical : std_logic_vector(9 downto 0);

begin

  i_iologic : iologic

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sw_i => sw_i,
    pb_i => pb_i,
    swsync_o => swsync,
    pbsync_o => pbsync
  );

  i_prescaler : prescaler

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixenable_o => pixenable
  );

  i_pattern1 : pattern1

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => pixelhorizontal,
    pixelvertical_i => pixelvertical,
    pattern1_r_o => pattern1_r,
    pattern1_g_o => pattern1_g,
    pattern1_b_o => pattern1_b
   );

  i_pattern2 : pattern2

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => pixelhorizontal,
    pixelvertical_i => pixelvertical,
    pattern2_r_o => pattern2_r,
    pattern2_g_o => pattern2_g,
    pattern2_b_o => pattern2_b
   );

  i_sourcemultiplexer : sourcemultiplexer

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sel_i => swsync(2 downto 0),
    memory1_r_i => memory1_r,
    memory1_g_i => memory1_g,
    memory1_b_i => memory1_b,
    memory2_r_i => memory2_r,
    memory2_g_i => memory2_g,
    memory2_b_i => memory2_b,
    pattern1_r_i => pattern1_r,
    pattern1_g_i => pattern1_g,
    pattern1_b_i => pattern1_b,
    pattern2_r_i => pattern2_r,
    pattern2_g_i => pattern2_g,
    pattern2_b_i => pattern2_b,
    red_mux_o => red,
    green_mux_o => green,
    blue_mux_o => blue
  );

  i_vgacontroller : vgacontroller

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixenable_i => pixenable,
    hsync_o => hsync,
    vsync_o => vsync,
    pixelhorizontal_o => pixelhorizontal,
    pixelvertical_o => pixelvertical
   );

  i_vga_monitor : vga_monitor

  port map 
  (
    s_reset_i => reset_i,
    s_vga_red_i => red,
    s_vga_green_i => green,
    s_vga_blue_i => blue,
    s_vga_hsync_i => hsync,
    s_vga_vsync_i => vsync
  );

  red_o <= red;
  green_o <= green;
  blue_o <= blue;
  hsync_o <= hsync;
  vsync_o <= vsync;

end struc;
