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

architecture sim of tb_sourcemultiplexer is

component sourcemultiplexer
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

signal clk_i : std_logic;
signal reset_i : std_logic;
signal sel_i : std_logic_vector(1 downto 0);
signal memory1_i : std_logic_vector(11 downto 0);
signal memory2_i : std_logic_vector(11 downto 0);
signal pattern1_i : std_logic_vector(11 downto 0);
signal pattern2_i : std_logic_vector(11 downto 0);
signal rgb_o : std_logic_vector(11 downto 0);

begin

  i_sourcemultiplexer : sourcemultiplexer

  port map (
            clk_i => clk_i,
            reset_i => reset_i,
            sel_i => sel_i,
            memory1_i => memory1_i,
            memory2_i => memory2_i,
            pattern1_i => pattern1_i,
            pattern2_i => pattern2_i,
            rgb_o => rgb_o
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

    reset_i <= '1';
    sel_i <= "00";
    memory1_i <= "000000000000";
    memory2_i <= "000000000000";
    pattern1_i <= "000000000000";
    pattern2_i <= "000000000000";
    wait for 10 ns;

    reset_i <= '0';
    wait for 10 ns;

    sel_i <= "00";
    memory1_i <= "111111111111";
    memory2_i <= "000000000000";
    pattern1_i <= "000000000000";
    pattern2_i <= "000000000000";
    wait for 100 ns;

    sel_i <= "01";
    memory1_i <= "000000000000";
    memory2_i <= "010101010101";
    pattern1_i <= "000000000000";
    pattern2_i <= "000000000000";
    wait for 100 ns;

    sel_i <= "10";
    memory1_i <= "000000000000";
    memory2_i <= "000000000000";
    pattern1_i <= "110011001100";
    pattern2_i <= "000000000000";
    wait for 100 ns;

    sel_i <= "11";
    memory1_i <= "000000000000";
    memory2_i <= "000000000000";
    pattern1_i <= "000000000000";
    pattern2_i <= "001100110011";
    wait for 100 ns;

  end process run;

end sim;
