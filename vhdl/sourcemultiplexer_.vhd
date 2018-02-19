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

entity sourcemultiplexer is
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
end sourcemultiplexer;
