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

entity pattern1 is

  port
  (
	pixelhorizontal_i : in std_logic_vector(9 downto 0);
	pixelvertical_i : in std_logic_vector(9 downto 0);
    pattern1_r_o : out std_logic_vector(3 downto 0);
	pattern1_g_o : out std_logic_vector(3 downto 0);
	pattern1_b_o : out std_logic_vector(3 downto 0)
  );

end pattern1;
