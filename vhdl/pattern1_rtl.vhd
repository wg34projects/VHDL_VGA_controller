----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : pattern1_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Pattern Generator 1
----------------------------------------------------------------------------
-- Revisions : 1
-- Date 		Version	Author 	Description
-- 2018.02.19	0.1		Resch	Projectstart VGA Controller, first Timings
-- 2018.02.21	0.2		Resch	Added Pattern Generators and TOP Design
-- 2018.02.22	0.3		Resch	Update TOP Design and first output via
--                              the nice vga app from FHTW to disk
-- 2018.03.27	0.4		Resch	Update signal routing sourcemultiplexer to
--								VGA controller
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture rtl of pattern1 is

  -- maximum picture setting
  constant C_hpicture : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicture : std_logic_vector(9 downto 0) := "0111011111"; -- 479

begin

  -- generates stripe pattern
  P_color: process (pixelhorizontal_i, pixelvertical_i, reset_i)

  begin

    if reset_i = '0' then

	  -- only active if in valid picture range
      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture)) and 
         (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture)) then

	    -- zones with red color
        if ((pixelhorizontal_i >= "0000000000") and			-- 0
            (pixelhorizontal_i <  "0000101000")) or 		-- 40
           ((pixelhorizontal_i >= "0010100000") and 		-- 160
            (pixelhorizontal_i <  "0011001000")) or 		-- 200
           ((pixelhorizontal_i >= "0101000000") and 		-- 320
            (pixelhorizontal_i <  "0101101000")) or 		-- 360
           ((pixelhorizontal_i >= "0111100000") and 		-- 480
            (pixelhorizontal_i <  "1000001000")) then       -- 520

          pattern1_r_o <= (others => '1');
          pattern1_g_o <= (others => '0');
          pattern1_b_o <= (others => '0');

	    -- zones with green color
        elsif ((pixelhorizontal_i >= "0000101000") and 		-- 40
               (pixelhorizontal_i <  "0001010000")) or 		-- 80
              ((pixelhorizontal_i >= "0011001000") and 		-- 200
               (pixelhorizontal_i <  "0011110000")) or 		-- 240
              ((pixelhorizontal_i >= "0101101000") and 		-- 360
               (pixelhorizontal_i <  "0110010000")) or 		-- 400
              ((pixelhorizontal_i >= "1000001000") and 		-- 520
               (pixelhorizontal_i <  "1000110000")) then	-- 560

          pattern1_r_o <= (others => '0');
          pattern1_g_o <= (others => '1');
          pattern1_b_o <= (others => '0');

	    -- zones with blue color
        elsif ((pixelhorizontal_i >= "0001010000") and 		-- 80
               (pixelhorizontal_i <  "0001111000")) or 		-- 120
              ((pixelhorizontal_i >= "0011110000") and 		-- 240
               (pixelhorizontal_i <  "0100011000")) or 		-- 280
              ((pixelhorizontal_i >= "0110010000") and 		-- 400
               (pixelhorizontal_i <  "0110111000")) or 		-- 440
              ((pixelhorizontal_i >= "1000110000") and 		-- 560
               (pixelhorizontal_i <  "1001011000")) then	-- 600

          pattern1_r_o <= (others => '0');
          pattern1_g_o <= (others => '0');
          pattern1_b_o <= (others => '1');

	    -- no color outside ranges
        else

          pattern1_r_o <= (others => '0');
          pattern1_g_o <= (others => '0');
          pattern1_b_o <= (others => '0');

        end if;

      else

        pattern1_r_o <= (others => '0');
        pattern1_g_o <= (others => '0');
        pattern1_b_o <= (others => '0');

      end if;

	-- no signal reset mode
    else

      pattern1_r_o <= (others => '0');
      pattern1_g_o <= (others => '0');
      pattern1_b_o <= (others => '0');

    end if;

  end process P_color;

end rtl;
