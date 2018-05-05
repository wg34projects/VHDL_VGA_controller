----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : memory2_.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ENTITY Memory 2
----------------------------------------------------------------------------
-- Revisions : 2
-- Date       Version Author  Description
-- 2018.02.25 0.1     Resch   Implementation ROM1, working output
--                            also syntesized with success
-- 2018.02.27 0.2     Resch   Update error in main process memory1
--                            Update error in main process memory2
-- 2018.02.28 0.3     Resch   New version for memory1 to increase timing
-- 2018.05.01 0.4     Resch   final code style check and comments
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity memory2 is

  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixelhorizontal_i : in std_logic_vector(9 downto 0);
    pixelvertical_i : in std_logic_vector(9 downto 0);
    pixenable_i : in std_logic;                       -- 25MHz enable
    memory2_r_o : out std_logic_vector(3 downto 0);   -- signals for multiplexer
    memory2_g_o : out std_logic_vector(3 downto 0);
    memory2_b_o : out std_logic_vector(3 downto 0);
    addr_rom2_o : out std_logic_vector(13 downto 0);  -- rom2 adress
    data_rom2_i : in std_logic_vector(11 downto 0);   -- rom2 data
    countstart_i : in std_logic                       -- counting enable signal
  );

end memory2;