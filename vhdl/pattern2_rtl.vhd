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

architecture rtl of pattern2 is

  constant C_hpicture : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicture : std_logic_vector(9 downto 0) := "0111011111"; -- 479

begin

  P_color: process (pixelhorizontal_i, pixelvertical_i)

  begin

    if (unsigned(pixelvertical_i) <= unsigned(C_vpicture)) and 
       (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture)) then

      if ((pixelhorizontal_i >= "0000000000") and 
          (pixelhorizontal_i <  "0000101000")) or 

         ((pixelhorizontal_i >= "0010100000") and 
          (pixelhorizontal_i <  "0011001000")) or 

         ((pixelhorizontal_i >= "0101000000") and 
          (pixelhorizontal_i <  "0101101000")) or 

         ((pixelhorizontal_i >= "0111100000") and 
          (pixelhorizontal_i <  "1000001000")) 
      then

        pattern2_r_o <= (others => '1');
        pattern2_g_o <= (others => '0');
        pattern2_b_o <= (others => '0');

      elsif ((pixelhorizontal_i >= "0000101000") and 
             (pixelhorizontal_i <  "0001010000")) or 

            ((pixelhorizontal_i >= "0011001000") and 
             (pixelhorizontal_i <  "0011110000")) or 

            ((pixelhorizontal_i >= "0101101000") and 
             (pixelhorizontal_i <  "0110010000")) or 

            ((pixelhorizontal_i >= "1000001000") and 
             (pixelhorizontal_i <  "1000110000")) 
      then

        pattern2_r_o <= (others => '0');
        pattern2_g_o <= (others => '1');
        pattern2_b_o <= (others => '0');

      elsif ((pixelhorizontal_i >= "0001010000") and 
             (pixelhorizontal_i <  "0001111000")) or 

            ((pixelhorizontal_i >= "0011110000") and 
             (pixelhorizontal_i <  "0100011000")) or 

            ((pixelhorizontal_i >= "0110010000") and 
             (pixelhorizontal_i <  "0110111000")) or 

            ((pixelhorizontal_i >= "1000110000") and 
             (pixelhorizontal_i <  "1001011000")) 
      then

        pattern2_r_o <= (others => '0');
        pattern2_g_o <= (others => '0');
        pattern2_b_o <= (others => '1');

      else

        pattern2_r_o <= (others => '0');
        pattern2_g_o <= (others => '0');
        pattern2_b_o <= (others => '0');

      end if;

    else

      pattern2_r_o <= (others => '0');
      pattern2_g_o <= (others => '0');
      pattern2_b_o <= (others => '0');

    end if;

  end process P_color;

end rtl;
