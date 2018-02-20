----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : prescaler_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: Prescaler to generat 25MHz signal
----------------------------------------------------------------------------
-- Revisions : 0
-- Date 		Version	Author 	Description
-- 2018.02.18	0.1		Resch	Projectstart
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

  port (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sel_i : in std_logic_vector(1 downto 0);
    memory1_i : in std_logic_vector(11 downto 0);
    memory2_i : in std_logic_vector(11 downto 0);
    pattern1_i : in std_logic_vector(11 downto 0);
    pattern2_i : in std_logic_vector(11 downto 0);
    rgb_o : out std_logic_vector(11 downto 0)
  );

end component;

signal swsync : std_logic_vector(15 downto 0);
signal pbsync : std_logic_vector(3 downto 0);

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
    pixenable_o => pixenable_o
  );

  i_sourcemultiplexer : sourcemultiplexer

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sel_i => swsync(15 downto 14),
    memory1_i => memory1_i,
    memory2_i => memory2_i,
    pattern1_i => pattern1_i,
    pattern2_i => pattern2_i,
    rgb_o => rgb_o
  );

end struc;
