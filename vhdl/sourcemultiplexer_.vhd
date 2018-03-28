----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : sourcemultplexer_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY Sourcemultiplexer to switch the inputs
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
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity sourcemultiplexer is

  port 
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sel_i : in std_logic_vector(5 downto 0);				-- used switches
    pbsync_i : in std_logic_vector(3 downto 0);				-- 4 buttons
    memory1_r_i : in std_logic_vector(3 downto 0);			-- mux input memory1
    memory1_g_i : in std_logic_vector(3 downto 0);
    memory1_b_i : in std_logic_vector(3 downto 0);
    memory2_r_i : in std_logic_vector(3 downto 0);			-- mux input memory2
    memory2_g_i : in std_logic_vector(3 downto 0);
    memory2_b_i : in std_logic_vector(3 downto 0);
    pattern1_r_i : in std_logic_vector(3 downto 0);			-- mux input pattern1
    pattern1_g_i : in std_logic_vector(3 downto 0);
    pattern1_b_i : in std_logic_vector(3 downto 0);
    pattern2_r_i : in std_logic_vector(3 downto 0);			-- mux input pattern2
    pattern2_g_i : in std_logic_vector(3 downto 0);
    pattern2_b_i : in std_logic_vector(3 downto 0);
    red_mux_o : out std_logic_vector(3 downto 0);			-- mux output
	green_mux_o : out std_logic_vector(3 downto 0);
	blue_mux_o : out std_logic_vector(3 downto 0);
	pixelhorizontal_i : in std_logic_vector(9 downto 0);	-- counter horizontal
	pixelvertical_i : in std_logic_vector(9 downto 0);		-- counter vertical
    countstart_o : out std_logic							-- enable counting for memory2
  );

end sourcemultiplexer;
