----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : top_VGA.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY TOP Design VGA
----------------------------------------------------------------------------
-- Revisions : 1
-- Date       Version Author  Description
-- 2018.02.19 0.1     Resch   Projectstart VGA Controller, first Timings
-- 2018.02.21 0.2     Resch   Added Pattern Generators and TOP Design
-- 2018.02.22 0.3     Resch   Update TOP Design and first output via
--                            the nice vga app from FHTW to disk
-- 2018.03.27 0.4     Resch   Update signal routing sourcemultiplexer to
--                            VGA controller
-- 2018.05.01 0.5     Resch   final code style check and comments
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity top_VGA is

  port
  (
    clk_i : in std_logic;                       -- main clock 100MHz
    reset_i : in std_logic;                     -- reset signal button
    sw_i : in std_logic_vector(15 downto 0);    -- 16 switches
    pb_i : in std_logic_vector(3 downto 0);     -- 4 buttons
    red_o : out std_logic_vector(3 downto 0);   -- 4 bit red to VGA
    green_o : out std_logic_vector(3 downto 0); -- 4 bit green to VGA
    blue_o : out std_logic_vector(3 downto 0);  -- 4 bit blue to VGA
    hsync_o : out std_logic;                    -- hsync to VGA
    vsync_o : out std_logic                     -- vsync to VGA
  );

end top_VGA;