----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : vgacontroller_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY VGA Controller
----------------------------------------------------------------------------
-- Revisions : 1
-- Date 		Version	Author 	Description
-- 2018.02.19	0.1		Resch	Projectstart VGA Controller, first Timings
-- 2018.02.21	0.2		Resch	Added Pattern Generators and TOP Design
-- 2018.02.22	0.3		Resch	Update TOP Design and first output via
--                              the nice vga app from FHTW to disk
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity vgacontroller is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixenable_i : in std_logic;								-- 25MHz enable
	hsync_o : out std_logic;								-- generated hsync VGA
	vsync_o : out std_logic;								-- generated vsync VGA
	pixelhorizontal_o : out std_logic_vector(9 downto 0);	-- counter horizontal
	pixelvertical_o : out std_logic_vector(9 downto 0);		-- counter vertical (lines)
    red_i : in std_logic_vector(3 downto 0);
    green_i : in std_logic_vector(3 downto 0);
    blue_i : in std_logic_vector(3 downto 0);
    red_o : out std_logic_vector(3 downto 0);
    green_o : out std_logic_vector(3 downto 0);
    blue_o : out std_logic_vector(3 downto 0)
  );

end vgacontroller;
