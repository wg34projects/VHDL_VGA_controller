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

architecture rtl of vgacontroller is

  constant C_hmax : std_logic_vector(9 downto 0) := "1100011111"; -- 799
  constant C_vmax : std_logic_vector(9 downto 0) := "1000001100"; -- 524
  constant C_hsyncstart : std_logic_vector(9 downto 0) := "1010001111"; -- 655
  constant C_hsyncend : std_logic_vector(9 downto 0) := "1011101111"; -- 751
  constant C_vsyncstart : std_logic_vector(9 downto 0) := "0111101001"; -- 489
  constant C_vsyncend : std_logic_vector(9 downto 0) := "0111101011"; -- 491
  signal s_pixelhorizontal : std_logic_vector(9 downto 0);
  signal s_pixelvertical : std_logic_vector(9 downto 0);
  signal s_enable : std_logic := '0';

begin

  P_count: process (clk_i, reset_i)

  begin

    if reset_i = '1' then
  
      s_pixelhorizontal <= (others => '0');
      s_pixelvertical <= (others => '0');
      s_enable <= '0';

    elsif clk_i'event and clk_i = '1' then

      if pixenable_i = '1' then

	  s_enable <= '1';

      end if;

        if s_enable = '1' then

          s_pixelhorizontal <= unsigned(s_pixelhorizontal) + 1;
		  s_enable <= '0';

		  if s_pixelhorizontal = C_hmax then

			s_pixelhorizontal <= (others => '0');
			s_pixelvertical <= unsigned(s_pixelvertical) + 1;

    	    if s_pixelvertical = C_vmax then

			  s_pixelvertical <= (others => '0');

            end if;

		  end if;

        end if;

      end if;

  end process P_count;

  pixelhorizontal_o <= s_pixelhorizontal;
  pixelvertical_o <= s_pixelvertical;

  P_sync: process (s_pixelhorizontal, s_pixelvertical)

  begin

    if (unsigned(s_pixelhorizontal) <= unsigned(C_hsyncstart)) or 
       (unsigned(s_pixelhorizontal) > unsigned(C_hsyncend)) then

      hsync_o <= '0';

    else

      hsync_o <= '1';

    end if;

    if (unsigned(s_pixelvertical) <= unsigned(C_vsyncstart)) or 
       (unsigned(s_pixelvertical) > unsigned(C_vsyncend)) then

      vsync_o <= '0';

    else

      vsync_o <= '1';

    end if;

  end process P_sync;

end rtl;
