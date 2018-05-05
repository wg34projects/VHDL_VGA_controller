----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : tb_sourcemultiplexer_sim.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: TESTBENCH SIM Sourcemultiplexer to switch the inputs
----------------------------------------------------------------------------
-- Revisions : 0
-- Date       Version Author  Description
-- 2018.02.18 0.1     Resch   Projectstart
-- 2018.05.01 0.2     Resch   final code style check and comments
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture sim of tb_sourcemultiplexer is

component sourcemultiplexer

port 
(
  clk_i : in std_logic;
  reset_i : in std_logic;
  sel_i : in std_logic_vector(5 downto 0);              -- used switches
  pbsync_i : in std_logic_vector(3 downto 0);           -- 4 buttons
  memory1_r_i : in std_logic_vector(3 downto 0);        -- mux input memory1
  memory1_g_i : in std_logic_vector(3 downto 0);
  memory1_b_i : in std_logic_vector(3 downto 0);
  memory2_r_i : in std_logic_vector(3 downto 0);        -- mux input memory2
  memory2_g_i : in std_logic_vector(3 downto 0);
  memory2_b_i : in std_logic_vector(3 downto 0);
  pattern1_r_i : in std_logic_vector(3 downto 0);       -- mux input pattern1
  pattern1_g_i : in std_logic_vector(3 downto 0);
  pattern1_b_i : in std_logic_vector(3 downto 0);
  pattern2_r_i : in std_logic_vector(3 downto 0);       -- mux input pattern2
  pattern2_g_i : in std_logic_vector(3 downto 0);
  pattern2_b_i : in std_logic_vector(3 downto 0);
  red_mux_o : out std_logic_vector(3 downto 0);         -- mux output vgacontroller
  green_mux_o : out std_logic_vector(3 downto 0);
  blue_mux_o : out std_logic_vector(3 downto 0);
  pixelhorizontal_i : in std_logic_vector(9 downto 0);  -- counter horizontal
  pixelvertical_i : in std_logic_vector(9 downto 0);    -- counter vertical
  countstart_o : out std_logic;                         -- enable counting for memory2
  switch_o : out std_logic                              -- enable pattern switch "hypno mode"
);

end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal sel_i : std_logic_vector(5 downto 0);
signal pbsync_i : std_logic_vector(3 downto 0);
signal memory1_r_i : std_logic_vector(3 downto 0);
signal memory1_g_i : std_logic_vector(3 downto 0);
signal memory1_b_i : std_logic_vector(3 downto 0);
signal memory2_r_i : std_logic_vector(3 downto 0);
signal memory2_g_i : std_logic_vector(3 downto 0);
signal memory2_b_i : std_logic_vector(3 downto 0);
signal pattern1_r_i : std_logic_vector(3 downto 0);
signal pattern1_g_i : std_logic_vector(3 downto 0);
signal pattern1_b_i : std_logic_vector(3 downto 0);
signal pattern2_r_i : std_logic_vector(3 downto 0);
signal pattern2_g_i : std_logic_vector(3 downto 0);
signal pattern2_b_i : std_logic_vector(3 downto 0);
signal red_mux_o : std_logic_vector(3 downto 0);
signal green_mux_o : std_logic_vector(3 downto 0);
signal blue_mux_o : std_logic_vector(3 downto 0);
signal pixelhorizontal_i : std_logic_vector(9 downto 0);
signal pixelvertical_i : std_logic_vector(9 downto 0);
signal countstart_o : std_logic;
signal switch_o : std_logic;

begin

  i_sourcemultiplexer : sourcemultiplexer

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sel_i => sel_i,
    pbsync_i => pbsync_i,
    memory1_r_i => memory1_r_i,
    memory1_g_i => memory1_g_i,
    memory1_b_i => memory1_b_i,
    memory2_r_i => memory2_r_i,
    memory2_g_i => memory2_g_i,
    memory2_b_i => memory2_b_i,
    pattern1_r_i => pattern1_r_i,
    pattern1_g_i => pattern1_g_i,
    pattern1_b_i => pattern1_b_i,
    pattern2_r_i => pattern2_r_i,
    pattern2_g_i => pattern2_g_i,
    pattern2_b_i => pattern2_b_i,
    red_mux_o => red_mux_o,
    green_mux_o => green_mux_o,
    blue_mux_o => blue_mux_o,
    pixelhorizontal_i => pixelhorizontal_i,
    pixelvertical_i => pixelvertical_i,
    countstart_o => countstart_o,
    switch_o => switch_o
  );

  P_clk : process

  begin

    clk_i <= '0';
    wait for 5 ns;
    clk_i <= '1';
    wait for 5 ns;

  end process P_clk;

  P_run : process

  begin

    reset_i <= '1';
    sel_i <= "000000";
    pbsync_i <= "0000";
    memory1_r_i <= "0000";
    memory1_g_i <= "0000";
    memory1_b_i <= "0000";
    memory2_r_i <= "0000";
    memory2_g_i <= "0000";
    memory2_b_i <= "0000";
    pattern1_r_i <= "0000";
    pattern1_g_i <= "0000";
    pattern1_b_i <= "0000";
    pattern2_r_i <= "0000";
    pattern2_g_i <= "0000";
    pattern2_b_i <= "0000";
    pixelhorizontal_i <= "0000000000";
    pixelvertical_i <= "0000000000";
      
    wait for 10 ns;

    reset_i <= '0';
    wait for 10 ns;

    -- pattern 1

    sel_i <= "000000";
    pattern1_r_i <= "0001";
    pattern1_g_i <= "0010";
    pattern1_b_i <= "0100";
    wait for 1 ms;

    -- pattern 2

    sel_i <= "000010";
    pattern2_r_i <= "0001";
    pattern2_g_i <= "0010";
    pattern2_b_i <= "0100";
    wait for 1 ms;

    -- memory 1

    sel_i <= "000001";
    memory1_r_i <= "1000";
    memory1_g_i <= "0100";
    memory1_b_i <= "0010";
    wait for 1 ms;

    -- overlay with move

    sel_i <= "100010";
    memory2_r_i <= "1000";
    memory2_g_i <= "0100";
    memory2_b_i <= "0010";
 
    wait for 1 ms;

  end process P_run;

end sim;