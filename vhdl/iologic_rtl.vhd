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

architecture rtl of iologic is

  constant C_debounce : std_logic_vector(16 downto 0) := "11000011010100000";
  signal s_enctr : std_logic_vector(16 downto 0);
  signal s_1khzen : std_logic;
  signal s_swsync : std_logic_vector(15 downto 0);
  signal s_pbsync : std_logic_vector(3 downto 0);
  signal s_debcnt : std_logic_vector(1 downto 0);
  signal s_button : std_logic;

begin

  p_slowen: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_1khzen <= '0';
      s_debcnt <= "00";
      s_enctr <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

      s_enctr <= unsigned(s_enctr) + 1;

      if s_enctr = C_debounce then

        s_1khzen <= not (s_1khzen);
        s_enctr <= (others => '0');

        if s_1khzen = '1' then

          if s_button = '1' then

            s_debcnt <= unsigned(s_debcnt) + 1;
 
          end if;

          if s_debcnt = "11" then

            s_debcnt <= "00";

         end if;

        end if;

      end if;

    end if;

  end process p_slowen;

  p_debounce: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_swsync <= (others => '0');
      s_pbsync <= (others => '0');
      s_button <= '0';

    elsif clk_i'event and clk_i = '1' then

      if s_1khzen = '1' then

        if s_swsync /= sw_i or s_pbsync /= pb_i then

          s_button <= '1';

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
