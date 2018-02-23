----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : tb_prescaler_sim.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE SIM Prescaler to generate 25MHz signal
----------------------------------------------------------------------------
-- Revisions : 0
-- Date 		Version	Author 	Description
-- 2018.02.18	0.1		Resch	Projectstart
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture sim of tb_prescaler is

component prescaler

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixenable_o : out std_logic
  );

end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal pixenable_o : std_logic;

begin

  i_prescaler : prescaler

  port map
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixenable_o => pixenable_o
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
    wait for 2 ns;

    reset_i <= '0';
    wait for 1 ms;

  end process run;

end sim;
