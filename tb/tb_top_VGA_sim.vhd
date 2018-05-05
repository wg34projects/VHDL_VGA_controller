----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : tb_top_VGA_sim.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: TESTBENCH ARCHITECTURE SIM TOP Design VGA
----------------------------------------------------------------------------
-- Revisions : 1
-- Date       Version Author  Description
-- 2018.02.18 0.1     Resch   Projectstart
-- 2018.05.01 0.2     Resch   final code style check and comments
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture sim of tb_top_VGA is

component top_VGA

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sw_i : in std_logic_vector(15 downto 0);
    pb_i : in std_logic_vector(3 downto 0)
  );

end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal sw_i : std_logic_vector(15 downto 0);
signal pb_i : std_logic_vector(3 downto 0);

begin

  i_top_VGA : top_VGA

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sw_i => sw_i,
    pb_i => pb_i
  );

  p_clk : process

  begin

    clk_i <= '0';
    wait for 5 ns;
    clk_i <= '1';
    wait for 5 ns;

  end process p_clk;

  run : process

  begin

    sw_i <= "0000000000000000";
    pb_i <= "0000";
    reset_i <= '1';
    wait for 50 ns;

    -- all possible combination without move
    -- pattern1, pattern2, memory1
    -- overlay normal pattern1, pattern2, memory1
    -- overlay transparent pattern1, pattern2, memory1
    -- overlay spaceinvadorspecial pattern1, pattern2, memory1
    reset_i <= '0';
    wait for 50 ns;

    sw_i <= "0000000000000000";
    wait for 35 ms;

    sw_i <= "0000000000000010";
    wait for 35 ms;

    sw_i <= "0000000000000011";
    wait for 35 ms;

    sw_i <= "0000000000000100";
    wait for 35 ms;

    sw_i <= "0000000000000110";
    wait for 35 ms;

    sw_i <= "0000000000000111";
    wait for 35 ms;

    sw_i <= "0000000000001100";
    wait for 35 ms;

    sw_i <= "0000000000001110";
    wait for 35 ms;

    sw_i <= "0000000000001111";
    wait for 35 ms;

    sw_i <= "0000000000011100";
    wait for 35 ms;

    sw_i <= "0000000000011110";
    wait for 35 ms;

    sw_i <= "0000000000011111";
    wait for 35 ms;

  end process run;

end sim;