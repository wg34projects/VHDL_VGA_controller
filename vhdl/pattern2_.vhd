----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : pattern2_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY Pattern Generator 2
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

entity pattern2 is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pixelvertical_i : in std_logic_vector(9 downto 0);
    pattern2_r_o : out std_logic_vector(3 downto 0);    -- signals to sourcemultiplexer
    pattern2_g_o : out std_logic_vector(3 downto 0);
    pattern2_b_o : out std_logic_vector(3 downto 0)
  );

end pattern2;