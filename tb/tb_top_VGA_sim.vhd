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

    reset_i <= '0';
--    wait for 1 ms;

	sw_i <= "0000000000000000";
    wait for 35 ms;

	sw_i <= "0000000000000010";
    wait for 1000 ms;

--	sw_i <= "0100000000000000";
--    wait for 1 ms;

--	sw_i <= "1000000000000000";
--    wait for 1 ms;

--	sw_i <= "1100000000000000";
--    wait for 1 ms;

  end process run;

end sim;
