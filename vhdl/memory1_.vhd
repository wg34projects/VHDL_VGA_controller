----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : memory1_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY Memory 1
----------------------------------------------------------------------------
-- Revisions : 2
-- Date 		Version	Author 	Description
-- 2018.02.25	0.1		Resch	Implementation ROM1, working output
--                              also syntesized with success
-- 2018.02.27   0.2     Resch   Update error in main process memory1
--                              Update error in main process memory2
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity memory1 is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixelhorizontal_i : in std_logic_vector(9 downto 0);
	pixelvertical_i : in std_logic_vector(9 downto 0);
    memory1_r_o : out std_logic_vector(3 downto 0);
	memory1_g_o : out std_logic_vector(3 downto 0);
	memory1_b_o : out std_logic_vector(3 downto 0);
    addr_rom1_o : out std_logic_vector(16 downto 0);
    data_rom1_i : in std_logic_vector(11 downto 0)
  );

end memory1;
