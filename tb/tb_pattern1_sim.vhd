----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : tb_pattern1_sim.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: TESTBENCH ARCHITECTURE Pattern1
----------------------------------------------------------------------------
-- Revisions : 1
-- Date       Version Author  Description
-- 2018.02.18 0.1     Resch   Projectstart
-- 2018.05.01 0.2     Resch   final code style check and comments
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture sim of tb_pattern1 is

component pattern1
    port
    (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pattern1_r_o : out std_logic_vector(3 downto 0);      -- signals to sourcemultiplexer
    pattern1_g_o : out std_logic_vector(3 downto 0);
    pattern1_b_o : out std_logic_vector(3 downto 0);
    switch_i : in std_logic
    );
end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal pixelhorizontal_i : std_logic_vector(9 downto 0);
signal pattern1_r_o : std_logic_vector(3 downto 0);
signal pattern1_g_o : std_logic_vector(3 downto 0);
signal pattern1_b_o : std_logic_vector(3 downto 0);
signal switch_i : std_logic;

begin

  i_pattern1 : pattern1

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => pixelhorizontal_i,
    pattern1_r_o => pattern1_r_o,
    pattern1_g_o => pattern1_g_o,
    pattern1_b_o => pattern1_b_o,
    switch_i => switch_i
   );

  P_clk : process

  begin

    clk_i <= '1';
    wait for 5 ns;
    clk_i <= '0';
    wait for 5 ns;

  end process P_clk;

  P_run : process

  begin

    reset_i <= '1';
    pixelhorizontal_i <= "0000000000";
    switch_i <= '0';
    wait for 5 ns;

    reset_i <= '0';

    switch_i <= '1';
    pixelhorizontal_i <= "0000000000";
    wait for 10 ns;
    switch_i <= '0';
    wait for 40 ns;

    switch_i <= '1';
    pixelhorizontal_i <= "0000100000";
    wait for 10 ns;
    switch_i <= '0';
    wait for 40 ns;

    switch_i <= '1';
    pixelhorizontal_i <= "0000100010";
    wait for 10 ns;
    switch_i <= '0';
    wait for 40 ns;

    switch_i <= '1';
    pixelhorizontal_i <= "0100100010";
    wait for 10 ns;
    switch_i <= '0';
    wait for 40 ns;

    wait;
    
  end process P_run;


end sim;