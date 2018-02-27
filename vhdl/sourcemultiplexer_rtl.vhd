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
-- 2018.02.25	0.3		Resch	Update to include overlay feature
-- 2018.02.27	0.4		Resch	Update to include moving overlay feature
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture rtl of sourcemultiplexer is

  constant C_middle_horizontal1 : std_logic_vector(9 downto 0) := "0100001110"; -- 270
  constant C_middle_horizontal2 : std_logic_vector(9 downto 0) := "0101110010"; -- 370
  constant C_middle_vertical1 : std_logic_vector(9 downto 0) := "0010111110"; -- 190
  constant C_middle_vertical2 : std_logic_vector(9 downto 0) := "0100100010"; -- 290
  constant C_hpicturemax : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicturemax : std_logic_vector(9 downto 0) := "0111011111"; -- 479
  constant C_middle_horizontal_counter : std_logic_vector(4 downto 0) := "01000"; -- 8
  constant C_middle_vertical_counter : std_logic_vector(3 downto 0) := "0110"; -- 6
  constant C_movepixel : std_logic_vector(9 downto 0) := "0000011110"; -- 30
 
  signal position_horizontal1 : std_logic_vector(9 downto 0);
  signal position_horizontal2 : std_logic_vector(9 downto 0);
  signal position_vertical1 : std_logic_vector(9 downto 0);
  signal position_vertical2 : std_logic_vector(9 downto 0);
  signal buttonstate_s : std_logic_vector(1 downto 0);
  signal movestate_s : std_logic_vector(2 downto 0);

begin

  p_sourcemultiplexer: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      red_mux_o <= (others => '0');
      green_mux_o <= (others => '0');
      blue_mux_o <= (others => '0');
      countstart_o <= '0';
      position_horizontal1 <= C_middle_horizontal1;
      position_horizontal2 <= C_middle_horizontal2;
      position_vertical1 <= C_middle_vertical1;
      position_vertical2 <= C_middle_vertical2;
      buttonstate_s <= "00";
      movestate_s <= "000";

    elsif clk_i'event and clk_i = '1' then

      if pbsync_i = "0001" and buttonstate_s = "00" then

        buttonstate_s(1) <= buttonstate_s(0);
        buttonstate_s(0) <= '1';
        movestate_s <= "001";

      end if;

      if pbsync_i = "0010" and buttonstate_s = "00" then

        buttonstate_s(1) <= buttonstate_s(0);
        buttonstate_s(0) <= '1';
        movestate_s <= "010";

      end if;

      if pbsync_i = "0100" and buttonstate_s = "00" then

        buttonstate_s(1) <= buttonstate_s(0);
        buttonstate_s(0) <= '1';
        movestate_s <= "011";

      end if;


      if pbsync_i = "1000" and buttonstate_s = "00" then

        buttonstate_s(1) <= buttonstate_s(0);
        buttonstate_s(0) <= '1';
        movestate_s <= "100";

      end if;

      if pbsync_i = "0000" and buttonstate_s = "01" then

        buttonstate_s(1) <= buttonstate_s(0);
        buttonstate_s(0) <= '1';

      end if;

      if buttonstate_s = "11" then

        if movestate_s = "001" then 

        buttonstate_s <= "00";

          if position_horizontal1 > "0000000000" then
  
            position_horizontal1 <= unsigned(position_horizontal1) - unsigned(C_movepixel);
            position_horizontal2 <= unsigned(position_horizontal2) - unsigned(C_movepixel);

          end if;
      
        elsif movestate_s = "010" then 

        buttonstate_s <= "00";

          if position_horizontal2 < "1010000000" then        

            position_horizontal1 <= unsigned(position_horizontal1) + unsigned(C_movepixel);
            position_horizontal2 <= unsigned(position_horizontal2) + unsigned(C_movepixel);

          end if;
       
        elsif movestate_s = "011"  then

        buttonstate_s <= "00"; 

          if position_vertical1 > "0000001010" then    

            position_vertical1 <= unsigned(position_vertical1) - unsigned(C_movepixel);
            position_vertical2 <= unsigned(position_vertical2) - unsigned(C_movepixel);

          end if;

        elsif movestate_s = "100"  then 

        buttonstate_s <= "00";

          if position_vertical2 < "0111010110" then    

            position_vertical1 <= unsigned(position_vertical1) + unsigned(C_movepixel);
            position_vertical2 <= unsigned(position_vertical2) + unsigned(C_movepixel);

          end if;

         else

            buttonstate_s <= "00";

         end if;

      end if;

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

        if (pixelhorizontal_i >= position_horizontal1 and 
            pixelhorizontal_i < position_horizontal2) and
           (pixelvertical_i >= position_vertical1 and 
            pixelvertical_i < position_vertical2) then

          red_mux_o <= memory2_r_i;
          green_mux_o <= memory2_g_i;
          blue_mux_o <= memory2_b_i;
          countstart_o <= '1';

        else

          red_mux_o <= pattern1_r_i;
          green_mux_o <= pattern1_g_i;
          blue_mux_o <= pattern1_b_i;
          countstart_o <= '0';

        end if;

      elsif sel_i = "110" then

        if (pixelhorizontal_i >= position_horizontal1 and 
            pixelhorizontal_i < position_horizontal2) and
           (pixelvertical_i >= position_vertical1 and 
            pixelvertical_i < position_vertical2) then

          red_mux_o <= memory2_r_i;
          green_mux_o <= memory2_g_i;
          blue_mux_o <= memory2_b_i;
          countstart_o <= '1';

        else

          red_mux_o <= pattern2_r_i;
          green_mux_o <= pattern2_g_i;
          blue_mux_o <= pattern2_b_i;
          countstart_o <= '0';

        end if;

      else

        if (pixelhorizontal_i >= position_horizontal1 and 
            pixelhorizontal_i < position_horizontal2) and
           (pixelvertical_i >= position_vertical1 and 
            pixelvertical_i < position_vertical2) then

          red_mux_o <= memory2_r_i;
          green_mux_o <= memory2_g_i;
          blue_mux_o <= memory2_b_i;
          countstart_o <= '1';

        else

          red_mux_o <= memory1_r_i;
          green_mux_o <= memory1_g_i;
          blue_mux_o <= memory1_b_i;
          countstart_o <= '0';

        end if;

      end if;

	end if;

  end process p_sourcemultiplexer;

end rtl;
