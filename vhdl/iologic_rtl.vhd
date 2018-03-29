----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : iologic_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL IOLogic for buttons and switches
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

architecture rtl of iologic is

  -- 10000 to divide 100khz to 1kHz
  constant C_debounce : std_logic_vector(16 downto 0) := "00010011100010000"; -- 10kHz

  signal s_enctr : std_logic_vector(16 downto 0);	-- counting signal
  signal s_1khzen : std_logic;						-- 1khz enable signal
  signal s_swsync : std_logic_vector(15 downto 0);	-- 16 switches
  signal s_pbsync : std_logic_vector(3 downto 0);	-- 5 buttons
  signal s_debcnt : std_logic_vector(1 downto 0);	-- debouncecount
  signal s_button : std_logic;

begin

  -- generates 10kHz signal for debouncing issues
  p_slowen: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_1khzen <= '0';
      s_debcnt <= "00";
      s_enctr <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

      s_enctr <= unsigned(s_enctr) + 1;				-- count up

      if s_enctr = C_debounce then

        s_1khzen <= not (s_1khzen);					-- invert when counter reached
        s_enctr <= (others => '0');					-- start again from 0

		-- read buttons with debounce "speed"
        if s_1khzen = '1' then

          if s_button = '1' then

            s_debcnt <= unsigned(s_debcnt) + 1;		-- increase debouncecount
 
          end if;

          if s_debcnt = "11" then					-- debouncecount = 3

            s_debcnt <= "00";

         end if;

        end if;

      end if;

    end if;

  end process p_slowen;

  -- reads the buttons
  p_debounce: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_swsync <= (others => '0');
      s_pbsync <= (others => '0');
      s_button <= '0';

    elsif clk_i'event and clk_i = '1' then

	  -- read buttons with debounce "speed"
      if s_1khzen = '1' then

		-- if a switch or button changes its state
        if s_swsync /= sw_i or s_pbsync /= pb_i then

          s_button <= '1';			-- set button enable

		  -- if debouncetime is done select switches and buttons
          if s_debcnt = "11" then 

             s_swsync <= sw_i;
             s_pbsync <= pb_i;
             s_button <= '0';

          else

            s_pbsync <= (others => '0');

          end if;

        end if;              

      end if;

    end if;

  end process p_debounce;

  swsync_o <= s_swsync;	
  pbsync_o <= s_pbsync;

end rtl;
