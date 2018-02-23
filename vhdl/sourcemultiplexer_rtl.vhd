----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : sourcemultplexer_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Sourcemultiplexer to switch the inputs
----------------------------------------------------------------------------
-- Revisions : 0
-- Date 		Version	Author 	Description
-- 2018.02.18	0.1		Resch	Projectstart
-- 2018.02.20	0.2		Resch	Update to include signal-mix feature
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

      if sel_i = "000" then

          red_mux_o <= pattern1_r_i;
          green_mux_o <= pattern1_g_i;
          blue_mux_o <= pattern1_b_i;

      elsif sel_i = "001" or sel_i = "011" then

          red_mux_o <= memory1_r_i;
          green_mux_o <= memory1_g_i;
          blue_mux_o <= memory1_b_i;

      elsif sel_i = "010" then

          red_mux_o <= pattern2_r_i;
          green_mux_o <= pattern2_g_i;
          blue_mux_o <= pattern2_b_i;

      elsif sel_i = "100" then

-- overlay pattern1

      elsif sel_i = "110" then

-- overlay pattern2

      else

-- overlay memory1

      end if;

	end if;

  end process p_sourcemultiplexer;

end rtl;
