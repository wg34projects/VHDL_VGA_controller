----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : iologic_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY IOLogic for buttons and switches
----------------------------------------------------------------------------
-- Revisions : 0
-- Date 		Version	Author 	Description
-- 2018.02.18	0.1		Resch	Projectstart
-- 2018.02.20	0.2		Resch	Update to include signal-mix feature
-- 2018.02.25	0.3		Resch	Update to include overlay feature
-- 2018.02.27	0.4		Resch	Update to include moving overlay feature
-- 2018.03.27	0.5		Resch	Transparency modes, left-right edge
--	                            and top-bottom edge handling, automatic
--                              x move with variable speed settings
-- 2018.04.13	0.6		Resch	Update enable signal instead enable clock
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity iologic is

  port
  (
    clk_i : in std_logic;							-- main clk
    reset_i : in std_logic;							-- main reset	
    sw_i : in std_logic_vector(15 downto 0);		-- 16 switches
    pb_i : in std_logic_vector(3 downto 0);			-- 4 buttons
    swsync_o : out std_logic_vector(15 downto 0);	-- synchro 16 switches
    pbsync_o : out std_logic_vector(3 downto 0)		-- synchro 4 buttons
  );

end iologic;
