----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : sourcemultplexer_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Sourcemultiplexer to switch the inputs
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

architecture rtl of sourcemultiplexer is

  -- initial position values
  constant C_middle_horizontal1 : std_logic_vector(9 downto 0) := "0100001101"; -- 269
  constant C_middle_horizontal2 : std_logic_vector(9 downto 0) := "0101110001"; -- 369
  constant C_middle_vertical1 : std_logic_vector(9 downto 0)   := "0010111101"; -- 189
  constant C_middle_vertical2 : std_logic_vector(9 downto 0)   := "0100100001"; -- 289
  -- maxvalues resolution
  constant C_hpicturemax : std_logic_vector(9 downto 0) := "1001111111";  -- 639
  constant C_vpicturemax : std_logic_vector(9 downto 0) := "0111011111";  -- 479
  -- pixels for moving
  constant C_movepixelvertical : std_logic_vector(9 downto 0)   := "0000011110";  -- 30
  constant C_movepixelhorizontal : std_logic_vector(9 downto 0) := "0000011101";  -- 29
  -- speed settings
  constant C_slow : std_logic_vector(20 downto 0)       := "011110100001001000000"; -- 1000000
  constant C_slowmin : std_logic_vector(20 downto 0)    := "111101000010010000000"; -- 2000000
  constant C_slowmax : std_logic_vector(20 downto 0)    := "000001100001101010000"; -- 50000
  constant C_speedstep : std_logic_vector(20 downto 0)  := "000001100001101010000"; -- 50000
  -- position of overlay memory2
  signal s_position_horizontal1 : std_logic_vector(9 downto 0);
  signal s_position_horizontal2 : std_logic_vector(9 downto 0);
  signal s_position_vertical1 : std_logic_vector(9 downto 0);
  signal s_position_vertical2 : std_logic_vector(9 downto 0);
  -- read the buttons  
  signal s_buttonstate : std_logic_vector(1 downto 0);  -- state of pushbuttons
  signal s_movestate : std_logic_vector(2 downto 0);    -- resulting move state x, y
  -- auto mode signals to calulate postions
  signal s_x : std_logic_vector(9 downto 0);  -- counting variable automatic move
  signal s_y : std_logic_vector(9 downto 0);
  signal s_updown : std_logic;                    -- tick-tock automatic move
  signal s_slow : std_logic_vector(20 downto 0);  -- counter speed
  signal s_special : std_logic;                   -- enable special mode (moving)
  signal s_speed : std_logic_vector(20 downto 0); -- resulting speed
  signal s_countstart : std_logic;                -- trigger overlay adress counter
  signal s_switch : std_logic;                    -- trigger "hypno mode"

begin

  -- slow down from 10Hz to 2000Hz for overlay move
  P_slowmove: process (clk_i, reset_i)

    begin

    if reset_i = '1' then

      s_slow <= (others => '0');
      -- start position for auto move
      s_x <= "0011001000"; -- 200 right
      s_y <= "0000110011"; -- 51 top
      s_updown <= '0';
      s_switch <= '0';

    elsif clk_i'event and clk_i = '1' then

      -- calcualte only when automatic move chosen
      if sel_i(5) = '1' then

        s_slow <= unsigned(s_slow) + 1; -- counter

        if s_slow = s_speed then  -- speed reached

          s_slow <= (others => '0');

          -- toggle left right with count up and count down
          if s_updown = '0' then

            s_x <= unsigned(s_x) - 1; -- count down

          else

            s_x <= unsigned(s_x) + 1; -- count up

          end if;

          -- check if right border is hit
          if unsigned(s_x) = 51 then  -- lowest x value

            s_updown <= '1';            -- border to count up
            s_y <= unsigned(s_y) + 10;  -- move down 10 pixel

            -- "hypno mode" only in case of moving space invador
            if sel_i(1) = '0' and sel_i(2) = '1' then

              s_switch <= '1';

            end if;

            -- maximum bottom reset
            if unsigned(s_position_vertical2) >= 469 then     -- bottom border

              s_y <= "0000110011"; -- 51 

            end if;

          -- check if left border is his
          elsif unsigned(s_x) = 589 then  -- highest x value

            s_updown <= '0';            -- border to count down
            s_y <= unsigned(s_y) + 10;  -- move down 10 pixel

            -- "hypno mode" only in case of moving space invador
            if sel_i(1) = '0' and sel_i(2) = '1' then

              s_switch <= '1';  

            end if;

            -- maximum bottom reset
            if unsigned(s_position_vertical2) >= 469 then   -- bottom border, see README.md

              s_y <= "0000110011"; -- 51 

            end if;
            
          else

            s_switch <= '0';

          end if;

        end if;

      else

        s_switch <= '0';

      end if;

    end if;

  end process P_slowmove;  

  switch_o <= s_switch;
  
  -- reads the button in various modes
  -- buttons only active when overlay is chosen
  P_buttons: process (clk_i, reset_i)

  variable v_tempspeed : std_logic_vector(20 downto 0) := (others => '0');

  begin

    if reset_i = '1' then

      s_movestate <= "000";
      s_buttonstate <= "00";
      s_position_horizontal1 <= C_middle_horizontal1;
      s_position_horizontal2 <= C_middle_horizontal2;
      s_position_vertical1 <= C_middle_vertical1;
      s_position_vertical2 <= C_middle_vertical2;
      s_special <= '0';
      s_speed <= C_slow;

    elsif clk_i'event and clk_i = '1' then

      -- read buttons only when overlay is on
      if sel_i(2) = '1' then

        -- check for possible button press actions and shift buttonstate
        -- save movestate left right up down for later usage
        if pbsync_i = "0001" and s_buttonstate = "00" then

          s_buttonstate(1) <= s_buttonstate(0);
          s_buttonstate(0) <= '1';
          s_movestate <= "001";

        end if;

        if pbsync_i = "0010" and s_buttonstate = "00" then

          s_buttonstate(1) <= s_buttonstate(0);
          s_buttonstate(0) <= '1';
          s_movestate <= "010";

        end if;

        if pbsync_i = "0100" and s_buttonstate = "00" then

          s_buttonstate(1) <= s_buttonstate(0);
          s_buttonstate(0) <= '1';
          s_movestate <= "011";

        end if;

        if pbsync_i = "1000" and s_buttonstate = "00" then

          s_buttonstate(1) <= s_buttonstate(0);
          s_buttonstate(0) <= '1';
          s_movestate <= "100";

        end if;

        -- if button is relased shift buttonstate
        if pbsync_i = "0000" and s_buttonstate = "01" then

          s_buttonstate(1) <= s_buttonstate(0);
          s_buttonstate(0) <= '1';

        end if;

      end if;

      -- hand mode which allows settings for x and y, no automatic mode/move
      if sel_i(5) = '0' then

        -- reset to the middle when coming from automatic mode
        if s_special = '1' then

          s_position_horizontal1 <= C_middle_horizontal1;
          s_position_horizontal2 <= C_middle_horizontal2;
          s_position_vertical1 <= C_middle_vertical1;
          s_position_vertical2 <= C_middle_vertical2;

        end if;

        s_special <= '0'; -- reset mode

        -- continue if button was pressed and released
        if s_buttonstate = "11" then

          -- calculations to move x to the left
          if s_movestate = "001" then

            s_buttonstate <= "00";

            -- keep going to left until minimum left
            if unsigned(s_position_horizontal1) > 8 then  -- left border

              s_position_horizontal1 <= unsigned(s_position_horizontal1) - unsigned(C_movepixelhorizontal);
              s_position_horizontal2 <= unsigned(s_position_horizontal2) - unsigned(C_movepixelhorizontal);

            -- if minimum is reached start from maximum right
            else

              s_position_horizontal1 <= "1000010010"; -- 530
              s_position_horizontal2 <= "1001110110"; -- 630

            end if;

          -- calculations to move x to the right
          elsif s_movestate = "010" then 

            s_buttonstate <= "00";

            -- keep going to left until maximum right
            if unsigned(s_position_horizontal2) < 630 then  -- right border

              s_position_horizontal1 <= unsigned(s_position_horizontal1) + unsigned(C_movepixelhorizontal);
              s_position_horizontal2 <= unsigned(s_position_horizontal2) + unsigned(C_movepixelhorizontal);

            -- im maximum is reached start from minimum left
            else

              s_position_horizontal1 <= "0000001000"; -- 8
              s_position_horizontal2 <= "0001101100"; -- 108

            end if;

          -- calculations to move y to up
          elsif s_movestate = "011"  then

            s_buttonstate <= "00"; 

            -- keep going to left until minimum top
            if unsigned(s_position_vertical1) > 9 then  -- top border

              s_position_vertical1 <= unsigned(s_position_vertical1) - unsigned(C_movepixelvertical);
              s_position_vertical2 <= unsigned(s_position_vertical2) - unsigned(C_movepixelvertical);

            -- if minimum is reached start from maximum bottom
            else

              s_position_vertical1 <= "0101110001"; -- 369
              s_position_vertical2 <= "0111010101"; -- 469

            end if;

	        -- calculations to move y to down
          elsif s_movestate = "100"  then 
 
            s_buttonstate <= "00";

            -- keep going to left until maximum bottom
            if unsigned(s_position_vertical2) < 469 then  -- bottom border

              s_position_vertical1 <= unsigned(s_position_vertical1) + unsigned(C_movepixelvertical);
              s_position_vertical2 <= unsigned(s_position_vertical2) + unsigned(C_movepixelvertical);

            -- if maximum is reached start from minimum top, see README.md
            else

              s_position_vertical1 <= "0000001001"; -- 9
              s_position_vertical2 <= "0001101101"; -- 109

            end if;

          else

            s_buttonstate <= "00";

          end if;

        end if;

      -- automatic mode/move
      else

        s_special <= '1';                               -- set special mode
        s_position_horizontal1 <= unsigned(s_x) - 50;   -- calculate new position with offset horizontal
        s_position_horizontal2 <= unsigned(s_x) + 50;
        s_position_vertical1 <= unsigned(s_y) - 50;     -- calculate new position with offset vetical
        s_position_vertical2 <= unsigned(s_y) + 50;
                
        -- button handling for automatic mode increase decrease speed of overlay
        if s_buttonstate = "11" then

          -- button right, increase speed
          if s_movestate = "001" then 

            s_buttonstate <= "00";

            -- increase only if in valid range
            v_tempspeed := unsigned(s_speed) + unsigned(C_speedstep);

            if unsigned(v_tempspeed) >= unsigned(C_slowmin) then

              v_tempspeed := C_slowmin;

            end if;

          -- button left, decrease speed
          elsif s_movestate = "010" then 

            s_buttonstate <= "00";

            -- decrase only in valid range
            v_tempspeed := unsigned(s_speed) - unsigned(C_speedstep);

            if unsigned(v_tempspeed) <= unsigned(C_slowmax) then

              v_tempspeed := C_slowmax;

            end if;

          else

            s_buttonstate <= "00";

          end if;

          s_speed <= v_tempspeed; -- set signal

        end if;

      end if;

    end if;

  end process P_buttons;

  -- enables the countstart signal for overlay adress
  P_countstart: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_countstart <= '0';

    elsif clk_i'event and clk_i = '1' then

      -- count only when overlay is chosen
      if sel_i(2 downto 0) = "100" or
         sel_i(2 downto 0) = "110" or
         (sel_i(2) = '1' and sel_i(0) = '1') then

        if (unsigned(pixelhorizontal_i) >= (unsigned(s_position_horizontal1)) and 
            unsigned(pixelhorizontal_i) < (unsigned(s_position_horizontal2))) and
          (unsigned(pixelvertical_i) >= unsigned(s_position_vertical1) and 
            unsigned(pixelvertical_i) < unsigned(s_position_vertical2)) then

          s_countstart <= '1';	-- memory2 can start upcounting

        else

          s_countstart <= '0';

        end if;

      end if;

    end if;

  end process P_countstart;

  countstart_o <= s_countstart;

  -- switches signals accoding input
  P_sourcemultiplexer: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      red_mux_o <= (others => '0');
      green_mux_o <= (others => '0');
      blue_mux_o <= (others => '0');

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

      -- combination for overlay mode
      elsif sel_i(2) = '1' then

        -- if in range of overlay 100x100
        if s_countstart = '1' then

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

                -- output patterns or memory1
                if sel_i(1 downto 0) = "00" then
            
                  red_mux_o <= pattern1_r_i;
                  green_mux_o <= pattern1_g_i;
                  blue_mux_o <= pattern1_b_i;
      
                elsif sel_i(1 downto 0) = "10" then
      
                  red_mux_o <= pattern2_r_i;
                  green_mux_o <= pattern2_g_i;
                  blue_mux_o <= pattern2_b_i;
      
                elsif sel_i(1 downto 0) = "01" or
                      sel_i(1 downto 0) = "11" then
      
                  red_mux_o <= memory1_r_i;
                  green_mux_o <= memory1_g_i;
                  blue_mux_o <= memory1_b_i;
      
                end if;

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

              -- or output patterns or memory1
              else

                if sel_i(1 downto 0) = "00" then
              
                  red_mux_o <= pattern1_r_i;
                  green_mux_o <= pattern1_g_i;
                  blue_mux_o <= pattern1_b_i;
      
                elsif sel_i(1 downto 0) = "10" then
      
                  red_mux_o <= pattern2_r_i;
                  green_mux_o <= pattern2_g_i;
                  blue_mux_o <= pattern2_b_i;
      
                elsif sel_i(1 downto 0) = "01" or
                        sel_i(1 downto 0) = "11" then
      
                  red_mux_o <= memory1_r_i;
                  green_mux_o <= memory1_g_i;
                  blue_mux_o <= memory1_b_i;
      
                end if;

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
          if sel_i(1 downto 0) = "00" then
            
            red_mux_o <= pattern1_r_i;
            green_mux_o <= pattern1_g_i;
            blue_mux_o <= pattern1_b_i;

          elsif sel_i(1 downto 0) = "10" then

            red_mux_o <= pattern2_r_i;
            green_mux_o <= pattern2_g_i;
            blue_mux_o <= pattern2_b_i;

          elsif sel_i(1 downto 0) = "01" or
                  sel_i(1 downto 0) = "11" then

            red_mux_o <= memory1_r_i;
            green_mux_o <= memory1_g_i;
            blue_mux_o <= memory1_b_i;

          end if;
          
        end if;

      else
        
        red_mux_o <= (others => '0');
        green_mux_o <= (others => '0');
        blue_mux_o <= (others => '0');

      end if;

  end if;

  end process P_sourcemultiplexer;

end rtl;