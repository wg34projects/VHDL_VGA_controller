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

architecture sim of tb_iologic is

component iologic

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

signal clk_i : std_logic;
signal reset_i : std_logic;
signal sw_i : std_logic_vector(15 downto 0);
signal pb_i : std_logic_vector(3 downto 0);
signal swsync_o : std_logic_vector(15 downto 0);
signal pbsync_o : std_logic_vector(3 downto 0);

begin

  i_iologic : iologic

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    sw_i => sw_i,
    pb_i => pb_i,
    swsync_o => swsync_o,
    pbsync_o => pbsync_o
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
    sw_i <= "0000000000000000";
    pb_i <= "0000";
    wait for 1 ms;

    reset_i <= '0';
    wait for 1 ms;

    sw_i <= "0000000000000001";
    pb_i <= "0000";
    wait for 2 ms;

    sw_i <= "0000000000000010";
    pb_i <= "1001";
    wait for 2 ms;

    sw_i <= "0000111000000010";
    pb_i <= "0101";
    wait for 2 ms;

    sw_i <= "0000000001110010";
    pb_i <= "0011";
    wait for 2 ms;

    sw_i <= "0111100000000010";
    pb_i <= "1111";
    wait for 2 ms;

  end process run;

end sim;
