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

entity top_VGA is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sw_i : in std_logic_vector(15 downto 0);
    pb_i : in std_logic_vector(3 downto 0);
	red_o : out std_logic_vector(3 downto 0);
	green_o : out std_logic_vector(3 downto 0);
	blue_o : out std_logic_vector(3 downto 0);
	h_sync : out std_logic;
	v_sync : out std_logic
  );

end top_VGA;
