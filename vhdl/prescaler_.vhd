----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : prescaler_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY Prescaler to generate 25MHz signal
----------------------------------------------------------------------------
-- Revisions : 0
-- Date       Version Author  Description
-- 2018.02.18 0.1     Resch   Projectstart
-- 2018.02.20 0.2     Resch   Update to include signal-mix feature
-- 2018.02.25 0.3     Resch   Update to include overlay feature
-- 2018.02.27 0.4     Resch   Update to include moving overlay feature
-- 2018.03.27 0.5     Resch   Transparency modes, left-right edge
--                            and top-bottom edge handling, automatic
--                            move with variable speed settings
-- 2018.04.13 0.6     Resch   Update enable signal instead enable clock and
--                            timing for for memory2 overlay
-- 2018.05.01 0.7     Resch   final code style check and comments
----------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity prescaler is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixenable_o : out std_logic   -- 25Mhz enable signal for VGA output
  );

end prescaler;