----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : top_VGA_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE STRUC TOP Design VGA
----------------------------------------------------------------------------
-- Revisions : 1
-- Date       Version Author  Description
-- 2018.02.19 0.1     Resch   Projectstart VGA Controller, first Timings
-- 2018.02.21 0.2     Resch   Added Pattern Generators and TOP Design
-- 2018.02.22 0.3     Resch   Update TOP Design and first output via
--                            the nice vga app from FHTW to disk
-- 2018.03.27 0.4     Resch   Update signal routing sourcemultiplexer to
--                            VGA controller
-- 2018.05.01 0.5     Resch   final code style check and comments
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture struc of top_VGA is

-- IP core ROM2 (overlay)
COMPONENT rom2 IS

  PORT 
  (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );

END COMPONENT;

-- IP core ROM1 (testpicture)
COMPONENT rom1 IS

  PORT 
  (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );

END COMPONENT;

-- buttons
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

-- 25MHz VGA enable signal
component prescaler is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixenable_o : out std_logic
  );

end component;

-- signal multiplexing, overlay, transparency, automatic mode
component sourcemultiplexer is

  port 
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sel_i : in std_logic_vector(5 downto 0);
    pbsync_i : in std_logic_vector(3 downto 0);
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
    blue_mux_o : out std_logic_vector(3 downto 0);
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pixelvertical_i : in std_logic_vector(9 downto 0);
    countstart_o : out std_logic
  );

end component;

-- counter for hsync and vsync and output control
component vgacontroller

  port 
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixenable_i : in std_logic;
    hsync_o : out std_logic;
    vsync_o : out std_logic;
    pixelhorizontal_o : out std_logic_vector(9 downto 0);
    pixelvertical_o : out std_logic_vector(9 downto 0);
    red_i : in std_logic_vector(3 downto 0);
    green_i : in std_logic_vector(3 downto 0);
    blue_i : in std_logic_vector(3 downto 0);
    red_o : out std_logic_vector(3 downto 0);
    green_o : out std_logic_vector(3 downto 0);
    blue_o : out std_logic_vector(3 downto 0)
  );

end component;

-- vga monitor FHTW for testing purposes
--component vga_monitor

--  port
--  (
--    s_reset_i     : in std_logic;
--    s_vga_red_i   : in std_logic_vector(3 downto 0);
--    s_vga_green_i : in std_logic_vector(3 downto 0);
--    s_vga_blue_i  : in std_logic_vector(3 downto 0);
--    s_vga_hsync_i : in std_logic;
--    s_vga_vsync_i : in std_logic
--  ); 

--end component;

-- pattern1 generator
component pattern1

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pattern1_r_o : out std_logic_vector(3 downto 0);
    pattern1_g_o : out std_logic_vector(3 downto 0);
    pattern1_b_o : out std_logic_vector(3 downto 0)
  );

end component;

-- pattern2 generator
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

-- memory1 module
component memory1

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pixelvertical_i : in std_logic_vector(9 downto 0);
    pixenable_i : in std_logic;
    memory1_r_o : out std_logic_vector(3 downto 0);
    memory1_g_o : out std_logic_vector(3 downto 0);
    memory1_b_o : out std_logic_vector(3 downto 0);
    addr_rom1_o : out std_logic_vector(16 downto 0);
    data_rom1_i : in std_logic_vector(11 downto 0)
  );

end component;	

-- memory2 module
component memory2

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pixelvertical_i : in std_logic_vector(9 downto 0);
    pixenable_i : in std_logic;
    memory2_r_o : out std_logic_vector(3 downto 0);
    memory2_g_o : out std_logic_vector(3 downto 0);
    memory2_b_o : out std_logic_vector(3 downto 0);
    addr_rom2_o : out std_logic_vector(13 downto 0);
    data_rom2_i : in std_logic_vector(11 downto 0);
    countstart_i : in std_logic
  );

end component;

-- connection signals switches, buttons
signal s_swsync : std_logic_vector(15 downto 0);
signal s_pbsync : std_logic_vector(3 downto 0);
-- 25MHz pixel enable
signal s_pixenable : std_logic;
-- memory1 connection
signal s_memory1_r : std_logic_vector(3 downto 0);
signal s_memory1_g : std_logic_vector(3 downto 0);
signal s_memory1_b : std_logic_vector(3 downto 0);
signal s_data_rom1 : std_logic_vector(11 downto 0);
signal s_addr_rom1 : std_logic_vector(16 downto 0);
-- memory2 connection
signal s_memory2_r : std_logic_vector(3 downto 0);
signal s_memory2_g : std_logic_vector(3 downto 0);
signal s_memory2_b : std_logic_vector(3 downto 0);
signal s_data_rom2 : std_logic_vector(11 downto 0);
signal s_addr_rom2 : std_logic_vector(13 downto 0);
-- pattern1 connection
signal s_pattern1_r : std_logic_vector(3 downto 0);
signal s_pattern1_g : std_logic_vector(3 downto 0);
signal s_pattern1_b : std_logic_vector(3 downto 0);
-- pattern2 connection
signal s_pattern2_r : std_logic_vector(3 downto 0);
signal s_pattern2_g : std_logic_vector(3 downto 0);
signal s_pattern2_b : std_logic_vector(3 downto 0);
-- RGB signals to VGA port
signal s_red : std_logic_vector(3 downto 0);
signal s_green : std_logic_vector(3 downto 0);
signal s_blue : std_logic_vector(3 downto 0);
-- RGB signal for internal connection with mux
signal s_redvga : std_logic_vector(3 downto 0);
signal s_greenvga : std_logic_vector(3 downto 0);
signal s_bluevga : std_logic_vector(3 downto 0);
-- sync signals to VGA
signal s_hsync : std_logic;
signal s_vsync : std_logic;
-- connection pixelcounters
signal s_pixelhorizontal : std_logic_vector(9 downto 0);
signal s_pixelvertical : std_logic_vector(9 downto 0);
signal s_countstart : std_logic;

begin

  -- connection memory1
  i_rom1 : rom1

  port map
  (
    clka => clk_i,
    addra => s_addr_rom1,
    douta => s_data_rom1
  );

  -- connection memory2
  i_rom2 : rom2

  port map
  (
    clka => clk_i,
    addra => s_addr_rom2,
    douta => s_data_rom2
  );

  -- connection buttons and switches
  i_iologic : iologic

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sw_i => sw_i,
    pb_i => pb_i,
    swsync_o => s_swsync,
    pbsync_o => s_pbsync
  );

  i_prescaler : prescaler

  -- connection prescaler 25MHz enable signal
  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixenable_o => s_pixenable
  );

  -- connection pattern1 generator
  i_pattern1 : pattern1

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => s_pixelhorizontal,
    pattern1_r_o => s_pattern1_r,
    pattern1_g_o => s_pattern1_g,
    pattern1_b_o => s_pattern1_b
   );

  -- connection pattern2 generator
  i_pattern2 : pattern2

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => s_pixelhorizontal,
    pixelvertical_i => s_pixelvertical,
    pattern2_r_o => s_pattern2_r,
    pattern2_g_o => s_pattern2_g,
    pattern2_b_o => s_pattern2_b
   );

  -- connection memory1 module
  i_memory1 : memory1

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => s_pixelhorizontal,
    pixelvertical_i => s_pixelvertical,
    pixenable_i => s_pixenable,
    memory1_r_o => s_memory1_r,
    memory1_g_o => s_memory1_g,
    memory1_b_o => s_memory1_b,
    addr_rom1_o => s_addr_rom1,
    data_rom1_i => s_data_rom1
  );

  -- connection memory2 module
  i_memory2 : memory2

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => s_pixelhorizontal,
    pixelvertical_i => s_pixelvertical,
    pixenable_i => s_pixenable,
    memory2_r_o => s_memory2_r,
    memory2_g_o => s_memory2_g,
    memory2_b_o => s_memory2_b,
    countstart_i => s_countstart,
    addr_rom2_o => s_addr_rom2,
    data_rom2_i => s_data_rom2
  );

  -- connection multiplexer
  i_sourcemultiplexer : sourcemultiplexer

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sel_i => s_swsync(5 downto 0),	-- first 6 switches used
    pbsync_i => s_pbsync,           -- 4 buttons used
    memory1_r_i => s_memory1_r,
    memory1_g_i => s_memory1_g,
    memory1_b_i => s_memory1_b,
    memory2_r_i => s_memory2_r,
    memory2_g_i => s_memory2_g,
    memory2_b_i => s_memory2_b,
    pattern1_r_i => s_pattern1_r,
    pattern1_g_i => s_pattern1_g,
    pattern1_b_i => s_pattern1_b,
    pattern2_r_i => s_pattern2_r,
    pattern2_g_i => s_pattern2_g,
    pattern2_b_i => s_pattern2_b,
    red_mux_o => s_redvga,
    green_mux_o => s_greenvga,
    blue_mux_o => s_bluevga,
    pixelhorizontal_i => s_pixelhorizontal,
    pixelvertical_i => s_pixelvertical,
    countstart_o => s_countstart
  );

  -- connection vga controller with sync signals and counters
  i_vgacontroller : vgacontroller

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixenable_i => s_pixenable,
    hsync_o => s_hsync,
    vsync_o => s_vsync,
    pixelhorizontal_o => s_pixelhorizontal,
    pixelvertical_o => s_pixelvertical,
    red_i => s_redvga,
    green_i => s_greenvga,
    blue_i => s_bluevga,
    red_o => s_red,
    green_o => s_green,
    blue_o => s_blue
   );

-- connection with vga monitor FHTW
--  i_vga_monitor : vga_monitor

--  port map 
--  (
--    s_reset_i => reset_i,
--    s_vga_red_i => s_red,
--    s_vga_green_i => s_green,
--    s_vga_blue_i => s_blue,
--    s_vga_hsync_i => s_hsync,
--    s_vga_vsync_i => s_vsync
--  );

  -- final connection of 4 bit RGB and sync signals
  red_o <= s_red;
  green_o <= s_green;
  blue_o <= s_blue;
  hsync_o <= s_hsync;
  vsync_o <= s_vsync;

end struc;
