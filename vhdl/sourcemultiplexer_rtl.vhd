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
use IEEE.std_logic_arith.all;

architecture rtl of sourcemultiplexer is

begin

  p_sourcemultiplexer: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      red_mux_o <= (others => '0');
      green_mux_o <= (others => '0');
      blue_mux_o <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

      if sel_i = "00" then

          red_mux_o <= pattern1_r_i;
          green_mux_o <= pattern1_g_i;
          blue_mux_o <= pattern1_b_i;

      elsif sel_i = "10" then

          red_mux_o <= pattern2_r_i;
          green_mux_o <= pattern2_g_i;
          blue_mux_o <= pattern2_b_i;


      elsif sel_i = "01" or sel_i = "11" then

          red_mux_o <= memory1_r_i;
          green_mux_o <= memory1_g_i;
          blue_mux_o <= memory1_b_i;

      else

          red_mux_o <= memory2_r_i;
          green_mux_o <= memory2_g_i;
          blue_mux_o <= memory2_b_i;

      end if;

	end if;

  end process p_sourcemultiplexer;

end rtl;
