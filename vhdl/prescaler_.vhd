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
-- Description: ENTITY Prescaler to generate 25MHz signal
----------------------------------------------------------------------------
-- Revisions : 0
-- Date 		Version	Author 	Description
-- 2018.02.18	0.1		Resch	Projectstart
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity prescaler is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixenable_o : out std_logic
  );

end prescaler;
