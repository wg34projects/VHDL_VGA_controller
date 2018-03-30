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
-- 2018.03.27	0.5		Resch	Transparency modes, left-right edge
--	                            and top-bottom edge handling, automatic
--                              x move with variable speed settings
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture rtl of sourcemultiplexer is

  -- initial position values
  constant C_middle_horizontal1 : std_logic_vector(9 downto 0) := "0100001101"; 	-- 269
  constant C_middle_horizontal2 : std_logic_vector(9 downto 0) := "0101110001";		-- 369
  constant C_middle_vertical1 : std_logic_vector(9 downto 0)   := "0010111101";		-- 189
  constant C_middle_vertical2 : std_logic_vector(9 downto 0)   := "0100100001";		-- 289
  -- maxvalues resolution
  constant C_hpicturemax : std_logic_vector(9 downto 0)        := "1001111111";		-- 639
  constant C_vpicturemax : std_logic_vector(9 downto 0)        := "0111011111";		-- 479
  -- pixels for moving
  constant C_movepixelvertical : std_logic_vector(9 downto 0)  := "0000011110";		-- 30
  constant C_movepixelhorizontal : std_logic_vector(9 downto 0) := "0000011101"; 	-- 29
  -- speed settings
  constant C_slow : std_logic_vector(20 downto 0)    	:= "011110100001001000000"; -- 1000000
  constant C_slowmin : std_logic_vector(20 downto 0) 	:= "111101000010010000000"; -- 2000000
  constant C_slowmax : std_logic_vector(20 downto 0) 	:= "000001100001101010000"; -- 50000
  constant C_speedstep : std_logic_vector(20 downto 0) 	:= "000001100001101010000"; -- 50000
  -- position of overlay memory2
  signal position_horizontal1 : std_logic_vector(9 downto 0);
  signal position_horizontal2 : std_logic_vector(9 downto 0);
  signal position_vertical1 : std_logic_vector(9 downto 0);
  signal position_vertical2 : std_logic_vector(9 downto 0);
  -- read the buttons  
  signal buttonstate_s : std_logic_vector(1 downto 0);		-- state of pushbuttons
  signal movestate_s : std_logic_vector(2 downto 0);		-- resulting move state x, y
  -- auto mode signals to calulate postions
  signal x_s : std_logic_vector(9 downto 0);				-- counting variable automatic move
  signal y_s : std_logic_vector(9 downto 0);
  signal updown_s : std_logic;								-- tick-tock automatic move
  signal slow_s : std_logic_vector(20 downto 0);			-- counter speed
  signal special_s : std_logic;								-- setting special mode (moving)
  signal speed_s : std_logic_vector(20 downto 0);			-- resulting speed

begin

  -- slow down from 10 to 2000Hz for overlay moe
  p_slowmove: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

	  slow_s <= (others => '0');
	  x_s <= "1001001101"; -- 589 right
	  y_s <= "0000110011"; -- 51  top
	  updown_s <= '0';

    elsif clk_i'event and clk_i = '1' then

	  -- calcualte only when automatic move chosen
      if sel_i(5) = '1' then

        slow_s <= unsigned(slow_s) + 1;		-- tick counter

        if slow_s = speed_s then

          slow_s <= (others => '0');		-- invert signal

          if updown_s = '0' then

            x_s <= unsigned(x_s) - 1;		-- count up

          else

            x_s <= unsigned(x_s) + 1;		-- count down

          end if;

		  if unsigned(x_s) = 51 then		-- lowest x value - see README.md

 		    updown_s <= '1';				-- border to count up
			y_s <= unsigned(y_s) + 10;

			-- keep going to left until maximum bottom
            if unsigned(position_vertical2) >= 469 then  	  -- bottom border, see README.md

              y_s <= "0000110011"; -- 51 

            end if;
 
		  end if;

		  if unsigned(x_s) = 589 then		-- highest x value - see README.md

 		    updown_s <= '0';				-- border to count down
			y_s <= unsigned(y_s) + 10;

			-- keep going to left until maximum bottom
            if unsigned(position_vertical2) >= 469 then  	  -- bottom border, see README.md

              y_s <= "0000110011"; -- 51 

            end if;
 
		  end if;

        end if;

	  end if;

    end if;

  end process p_slowmove;

  -- reads the button in various modes
  -- buttons only active when overlay is chosen
  p_buttons: process (clk_i, reset_i)

  variable tempspeed_v : std_logic_vector(20 downto 0) := (others => '0');

  begin

    if reset_i = '1' then

      movestate_s <= "000";
      buttonstate_s <= "00";
      position_horizontal1 <= C_middle_horizontal1;
      position_horizontal2 <= C_middle_horizontal2;
      position_vertical1 <= C_middle_vertical1;
      position_vertical2 <= C_middle_vertical2;
	  special_s <= '0';
      speed_s <= C_slow;

    elsif clk_i'event and clk_i = '1' then

	  -- read buttons only when overlay is on
      if sel_i(2) = '1' then

        -- check for possible button press actions and shift buttonstate
	    -- save movestate left right up down for later usage

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

        -- if button is relased shift buttonstate

        if pbsync_i = "0000" and buttonstate_s = "01" then

          buttonstate_s(1) <= buttonstate_s(0);
          buttonstate_s(0) <= '1';

        end if;

      end if;

      -- hand mode which allows settings for x and y, no automatic mode/move

      if sel_i(5) = '0' then

		-- reset to the middle when coming from automatic mode
        if special_s = '1' then

		  position_horizontal1 <= C_middle_horizontal1;
		  position_horizontal2 <= C_middle_horizontal2;
		  position_vertical1 <= C_middle_vertical1;
		  position_vertical2 <= C_middle_vertical2;

		end if;

	    special_s <= '0';	-- reset mode

		-- continue if button was pressed and released

        if buttonstate_s = "11" then

		  -- calculations to move x to the left

          if movestate_s = "001" then

           buttonstate_s <= "00";

			-- keep going to left until minimum left

            if unsigned(position_horizontal1) > 8 then		-- left border, see README.md
  
              position_horizontal1 <= unsigned(position_horizontal1) - unsigned(C_movepixelhorizontal);
              position_horizontal2 <= unsigned(position_horizontal2) - unsigned(C_movepixelhorizontal);

		    -- if minimum is reached start from maximum right, see README.md

		    else

              position_horizontal1 <= "1000010010"; -- 530
              position_horizontal2 <= "1001110110"; -- 630

            end if;

	      -- calculations to move x to the right
      
          elsif movestate_s = "010" then 

          buttonstate_s <= "00";

			-- keep going to left until maximum right

            if unsigned(position_horizontal2) < 630 then	-- right border, see README.md       

              position_horizontal1 <= unsigned(position_horizontal1) + unsigned(C_movepixelhorizontal);
              position_horizontal2 <= unsigned(position_horizontal2) + unsigned(C_movepixelhorizontal);

            -- im maximum is reached start from minimum left, see README.md

		    else

              position_horizontal1 <= "0000001000"; -- 8
              position_horizontal2 <= "0001101100"; -- 108

            end if;

	      -- calculations to move y to up
       
          elsif movestate_s = "011"  then

          buttonstate_s <= "00"; 

			-- keep going to left until minimum top

            if unsigned(position_vertical1) > 9 then    	-- top border, see README.md

              position_vertical1 <= unsigned(position_vertical1) - unsigned(C_movepixelvertical);
              position_vertical2 <= unsigned(position_vertical2) - unsigned(C_movepixelvertical);

		    -- if minimum is reached start from maximum bottom, see README.md

		    else

              position_vertical1 <= "0101110001"; -- 369
              position_vertical2 <= "0111010101"; -- 469

            end if;

	      -- calculations to move y to down

          elsif movestate_s = "100"  then 
 
          buttonstate_s <= "00";

			-- keep going to left until maximum bottom

            if unsigned(position_vertical2) < 469 then  	  -- bottom border, see README.md

              position_vertical1 <= unsigned(position_vertical1) + unsigned(C_movepixelvertical);
              position_vertical2 <= unsigned(position_vertical2) + unsigned(C_movepixelvertical);

		    -- if maximum is reached start from minimum top, see README.md

	  	    else

              position_vertical1 <= "0000001001"; -- 9
              position_vertical2 <= "0001101101"; -- 109

            end if;

          else

            buttonstate_s <= "00";

          end if;

        end if;

	  -- automatic mode/move

      else

   	    special_s <= '1';								-- set special mode
        position_horizontal1 <= unsigned(x_s) - 50;		-- calculate new position with offset horizontal
		position_horizontal2 <= unsigned(x_s) + 50;
        position_vertical1 <= unsigned(y_s) - 50;		-- calculate new position with offset vetical
		position_vertical2 <= unsigned(y_s) + 50;

		-- button handling for automatic mode
	
		if buttonstate_s = "11" then

		  -- button right, increase speed

          if movestate_s = "001" then 

            buttonstate_s <= "00";

		    -- increase only if in valid range

	  	    tempspeed_v := unsigned(speed_s) + unsigned(C_speedstep);

            if unsigned(tempspeed_v) >= unsigned(C_slowmin) then

			  tempspeed_v := C_slowmin;

			end if;

          -- button left, decrease speed
      
          elsif movestate_s = "010" then 

          buttonstate_s <= "00";

            -- decrase only in valid range

            tempspeed_v := unsigned(speed_s) - unsigned(C_speedstep);

            if unsigned(tempspeed_v) <= unsigned(C_slowmax) then

		      tempspeed_v := C_slowmax;

            end if;

         else

            buttonstate_s <= "00";

         end if;

	    speed_s <= tempspeed_v;	-- set sigal

		end if;

      end if;

    end if;

  end process p_buttons;

  -- switches signals accoding input
  p_sourcemultiplexer: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      red_mux_o <= (others => '0');
      green_mux_o <= (others => '0');
      blue_mux_o <= (others => '0');
      countstart_o <= '0';

    elsif clk_i'event and clk_i = '1' then

	  -- combination for pattern1
      if sel_i(2 downto 0) = "000" then

        red_mux_o <= pattern1_r_i;
        green_mux_o <= pattern1_g_i;
        blue_mux_o <= pattern1_b_i;

	  -- combinations for memory1
      elsif sel_i(2 downto 0) = "001" or sel_i(2 downto 0) = "011" then

        red_mux_o <= memory1_r_i;
        green_mux_o <= memory1_g_i;
        blue_mux_o <= memory1_b_i;

	  -- combination for pattern2
      elsif sel_i(2 downto 0) = "010" then

        red_mux_o <= pattern2_r_i;
        green_mux_o <= pattern2_g_i;
        blue_mux_o <= pattern2_b_i;

	  -- combination for overlay mode pattern1
      elsif sel_i(2 downto 0) = "100" then

		-- if in range of overlay 100x100

        if (unsigned(pixelhorizontal_i) >= unsigned(position_horizontal1) and 
            unsigned(pixelhorizontal_i) < unsigned(position_horizontal2)) and
           (unsigned(pixelvertical_i) >= unsigned(position_vertical1) and 
            unsigned(pixelvertical_i) < unsigned(position_vertical2)) then

          countstart_o <= '1';	-- memory2 can start upcounting

		  -- mode overlay

          if sel_i(3) = '1' then

		    -- mode black white transparency

            if sel_i(4) = '0' then

			  -- filter white = 0 and black = 2^4-1	

              if ((unsigned(memory2_r_i) = 0) and
				  (unsigned(memory2_g_i) = 0) and
				  (unsigned(memory2_b_i) = 0)) or

				 ((unsigned(memory2_r_i) = 15) and
				  (unsigned(memory2_g_i) = 15) and
				  (unsigned(memory2_b_i) = 15)) then

				-- output pattern if transparent

                red_mux_o <= pattern1_r_i;
                green_mux_o <= pattern1_g_i;
                blue_mux_o <= pattern1_b_i;

              -- or output overlay

              else

                red_mux_o <= memory2_r_i;
                green_mux_o <= memory2_g_i;
                blue_mux_o <= memory2_b_i;

              end if;

		    -- special space invador color mode
			
            else

			  -- the main orange in the coe file

              if ((unsigned(memory2_r_i) = 15) and
                  (unsigned(memory2_g_i) = 8) and
				  (unsigned(memory2_b_i) = 0)) then

			    -- output from memory2

                red_mux_o <= memory2_r_i;
                green_mux_o <= memory2_g_i;
                blue_mux_o <= memory2_b_i;

			  -- or output pattern 1

              else

                red_mux_o <= pattern1_r_i;
                green_mux_o <= pattern1_g_i;
                blue_mux_o <= pattern1_b_i;

              end if;

            end if;

		  -- no transparency at all mode, direkt from memory2

          else

                red_mux_o <= memory2_r_i;
                green_mux_o <= memory2_g_i;
                blue_mux_o <= memory2_b_i;         

	      end if;

        else

		  -- output outside overlay

		  countstart_o <= '0';
          red_mux_o <= pattern1_r_i;
          green_mux_o <= pattern1_g_i;
          blue_mux_o <= pattern1_b_i;
          
        end if;

	  -- combination for overlay mode pattern2
	  -- same combinatoric as pattern1
      elsif sel_i(2 downto 0) = "110" then

        if (unsigned(pixelhorizontal_i) >= unsigned(position_horizontal1) and 
            unsigned(pixelhorizontal_i) < unsigned(position_horizontal2)) and
           (unsigned(pixelvertical_i) >= unsigned(position_vertical1) and 
            unsigned(pixelvertical_i) < unsigned(position_vertical2)) then

          countstart_o <= '1';

          if sel_i(3) = '1' then

            if sel_i(4) = '0' then

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

                red_mux_o <= memory2_r_i;
                green_mux_o <= memory2_g_i;
                blue_mux_o <= memory2_b_i;         

	      end if;

        else

          countstart_o <= '0';
          red_mux_o <= pattern2_r_i;
          green_mux_o <= pattern2_g_i;
          blue_mux_o <= pattern2_b_i;

        end if;

	  -- combination for overlay mode memory1
	  -- same combinatoric as pattern1
      elsif sel_i(2) = '1' and sel_i(0) = '1' then

        if (unsigned(pixelhorizontal_i) >= unsigned(position_horizontal1) and 
            unsigned(pixelhorizontal_i) < unsigned(position_horizontal2)) and
           (unsigned(pixelvertical_i) >= unsigned(position_vertical1) and 
            unsigned(pixelvertical_i) < unsigned(position_vertical2)) then

          countstart_o <= '1';

          if sel_i(3) = '1' then

            if sel_i(4) = '0' then

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

            red_mux_o <= memory2_r_i;
            green_mux_o <= memory2_g_i;
            blue_mux_o <= memory2_b_i;         

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
