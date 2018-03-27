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

          if unsigned(position_horizontal1) > 0 then
  
            position_horizontal1 <= unsigned(position_horizontal1) - unsigned(C_movepixel);
            position_horizontal2 <= unsigned(position_horizontal2) - unsigned(C_movepixel);

		  else

            position_horizontal1 <= "1000011011"; -- 539
            position_horizontal2 <= "1001111111"; -- 639

          end if;
      
        elsif movestate_s = "010" then 

        buttonstate_s <= "00";

          if unsigned(position_horizontal2) < 640 then        

            position_horizontal1 <= unsigned(position_horizontal1) + unsigned(C_movepixel);
            position_horizontal2 <= unsigned(position_horizontal2) + unsigned(C_movepixel);

		  else

            position_horizontal1 <= "0000000000"; -- 0
            position_horizontal2 <= "0001100100"; -- 100

          end if;
       
        elsif movestate_s = "011"  then

        buttonstate_s <= "00"; 

          if unsigned(position_vertical1) > 10 then    

            position_vertical1 <= unsigned(position_vertical1) - unsigned(C_movepixel);
            position_vertical2 <= unsigned(position_vertical2) - unsigned(C_movepixel);

		  else

            position_vertical1 <= "0101110001"; -- 369
            position_vertical2 <= "0111010101"; -- 469

          end if;

        elsif movestate_s = "100"  then 

        buttonstate_s <= "00";

          if unsigned(position_vertical2) < 470 then    

            position_vertical1 <= unsigned(position_vertical1) + unsigned(C_movepixel);
            position_vertical2 <= unsigned(position_vertical2) + unsigned(C_movepixel);

		  else

            position_vertical1 <= "0000001010";
            position_vertical2 <= "0001101110";

          end if;

         else

            buttonstate_s <= "00";

         end if;

      end if;

      if sel_i(2 downto 0) = "000" then

        red_mux_o <= pattern1_r_i;
        green_mux_o <= pattern1_g_i;
        blue_mux_o <= pattern1_b_i;

      elsif sel_i(2 downto 0) = "001" or sel_i(2 downto 0) = "011" then

        red_mux_o <= memory1_r_i;
        green_mux_o <= memory1_g_i;
        blue_mux_o <= memory1_b_i;

      elsif sel_i(2 downto 0) = "010" then

        red_mux_o <= pattern2_r_i;
        green_mux_o <= pattern2_g_i;
        blue_mux_o <= pattern2_b_i;

      elsif sel_i(2 downto 0) = "100" then

        if (unsigned(pixelhorizontal_i) >= unsigned(position_horizontal1) and 
            unsigned(pixelhorizontal_i) < unsigned(position_horizontal2)) and
           (unsigned(pixelvertical_i) >= unsigned(position_vertical1) and 
            unsigned(pixelvertical_i) < unsigned(position_vertical2)) then

          countstart_o <= '1';

		  if sel_i(3) = '0' then

		    if ((unsigned(memory2_r_i) = 0) and
		       (unsigned(memory2_g_i) = 0) and
		       (unsigned(memory2_b_i) = 0)) or

		       ((unsigned(memory2_r_i) = 15) and
		       (unsigned(memory2_g_i) = 15) and
		       (unsigned(memory2_b_i) = 15)) then

               red_mux_o <= pattern1_r_i;
               green_mux_o <= pattern1_g_i;
               blue_mux_o <= pattern1_b_i;

		    else

              red_mux_o <= memory2_r_i;
              green_mux_o <= memory2_g_i;
              blue_mux_o <= memory2_b_i;

		    end if;
		
		  else

	  	    if ((unsigned(memory2_r_i) = 15) and
			   (unsigned(memory2_g_i) = 8) and
			   (unsigned(memory2_b_i) = 0)) then

		       red_mux_o <= memory2_r_i;
		       green_mux_o <= memory2_g_i;
		       blue_mux_o <= memory2_b_i;

			  else

		        red_mux_o <= pattern1_r_i;
		        green_mux_o <= pattern1_g_i;
		        blue_mux_o <= pattern1_b_i;

			  end if;

          end if;

        else

		  countstart_o <= '0';
          red_mux_o <= pattern1_r_i;
          green_mux_o <= pattern1_g_i;
          blue_mux_o <= pattern1_b_i;
          
        end if;

      elsif sel_i(2 downto 0) = "110" then

        if (unsigned(pixelhorizontal_i) >= unsigned(position_horizontal1) and 
            unsigned(pixelhorizontal_i) < unsigned(position_horizontal2)) and
           (unsigned(pixelvertical_i) >= unsigned(position_vertical1) and 
            unsigned(pixelvertical_i) < unsigned(position_vertical2)) then

          countstart_o <= '1';

		  if sel_i(3) = '0' then

		    if ((unsigned(memory2_r_i) = 0) and
		       (unsigned(memory2_g_i) = 0) and
		       (unsigned(memory2_b_i) = 0)) or

		       ((unsigned(memory2_r_i) = 15) and
		       (unsigned(memory2_g_i) = 15) and
		       (unsigned(memory2_b_i) = 15)) then

               red_mux_o <= pattern2_r_i;
               green_mux_o <= pattern2_g_i;
               blue_mux_o <= pattern2_b_i;

		    else

              red_mux_o <= memory2_r_i;
              green_mux_o <= memory2_g_i;
              blue_mux_o <= memory2_b_i;

		    end if;
		
		  else

	  	    if ((unsigned(memory2_r_i) = 15) and
			   (unsigned(memory2_g_i) = 8) and
			   (unsigned(memory2_b_i) = 0)) then

		       red_mux_o <= memory2_r_i;
		       green_mux_o <= memory2_g_i;
		       blue_mux_o <= memory2_b_i;

			  else

		        red_mux_o <= pattern2_r_i;
		        green_mux_o <= pattern2_g_i;
		        blue_mux_o <= pattern2_b_i;

			  end if;

          end if;

        else

          countstart_o <= '0';
          red_mux_o <= pattern2_r_i;
          green_mux_o <= pattern2_g_i;
          blue_mux_o <= pattern2_b_i;

        end if;

      elsif sel_i(2) = '1' and sel_i(0) = '1' then

        if (unsigned(pixelhorizontal_i) >= unsigned(position_horizontal1) and 
            unsigned(pixelhorizontal_i) < unsigned(position_horizontal2)) and
           (unsigned(pixelvertical_i) >= unsigned(position_vertical1) and 
            unsigned(pixelvertical_i) < unsigned(position_vertical2)) then

          countstart_o <= '1';

		  if sel_i(3) = '0' then

		    if ((unsigned(memory2_r_i) = 0) and
		       (unsigned(memory2_g_i) = 0) and
		       (unsigned(memory2_b_i) = 0)) or

		       ((unsigned(memory2_r_i) = 15) and
		       (unsigned(memory2_g_i) = 15) and
		       (unsigned(memory2_b_i) = 15)) then

               red_mux_o <= memory1_r_i;
               green_mux_o <= memory1_g_i;
               blue_mux_o <= memory1_b_i;

		    else

              red_mux_o <= memory2_r_i;
              green_mux_o <= memory2_g_i;
              blue_mux_o <= memory2_b_i;

		    end if;
		
		  else

	  	    if ((unsigned(memory2_r_i) = 15) and
			   (unsigned(memory2_g_i) = 8) and
			   (unsigned(memory2_b_i) = 0)) then

		       red_mux_o <= memory2_r_i;
		       green_mux_o <= memory2_g_i;
		       blue_mux_o <= memory2_b_i;

			  else

		        red_mux_o <= memory1_r_i;
		        green_mux_o <= memory1_g_i;
		        blue_mux_o <= memory1_b_i;

			  end if;

          end if;

        else

          countstart_o <= '0';
          red_mux_o <= memory1_r_i;
          green_mux_o <= memory1_g_i;
          blue_mux_o <= memory1_b_i;

        end if;

      end if;

	end if;

  end process p_sourcemultiplexer;

end rtl;
