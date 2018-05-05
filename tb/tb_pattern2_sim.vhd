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

architecture sim of tb_pattern2 is

component pattern2
    port
    (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pixelvertical_i : in std_logic_vector(9 downto 0);
    pattern2_r_o : out std_logic_vector(3 downto 0);    -- signals to sourcemultiplexer
    pattern2_g_o : out std_logic_vector(3 downto 0);
    pattern2_b_o : out std_logic_vector(3 downto 0)
    );
end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal pixelhorizontal_i : std_logic_vector(9 downto 0);
signal pixelvertical_i : std_logic_vector(9 downto 0);
signal pattern2_r_o : std_logic_vector(3 downto 0);
signal pattern2_g_o : std_logic_vector(3 downto 0);
signal pattern2_b_o : std_logic_vector(3 downto 0);

begin

  i_pattern2 : pattern2

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixelhorizontal_i => pixelhorizontal_i,
    pixelvertical_i => pixelvertical_i,
    pattern2_r_o => pattern2_r_o,
    pattern2_g_o => pattern2_g_o,
    pattern2_b_o => pattern2_b_o
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
    pixelvertical_i <= "0000000000";
    wait for 5 ns;

    reset_i <= '0';

    pixelhorizontal_i <= "0000000000";
    pixelvertical_i <= "0000000000";
    wait for 10 ns;

    pixelhorizontal_i <= "0000100000";
    pixelvertical_i <= "0000100000";
    wait for 10 ns;

    pixelhorizontal_i <= "0000100010";
    pixelvertical_i <= "0000100010";
    wait for 10 ns;

    pixelhorizontal_i <= "0100100010";
    pixelvertical_i <= "0100100010";
    wait for 10 ns;

    wait;
    
  end process P_run;

end sim;