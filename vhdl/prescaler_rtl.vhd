----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : prescaler_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: RTL ARCHITECTURE Prescaler to generate 25MHz signal
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

architecture rtl of prescaler is

  -- 25Mhz = 1/4 100Mhz = 2 clk high 2 clk low
  constant C_enctrval : std_logic := '1';

  signal   s_enctr : std_logic;				-- counter
  signal   s_25mhz : std_logic;				-- enable signal

begin

  P_prescaler: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_25mhz <= '0';
      s_enctr <= '0';

    elsif clk_i'event and clk_i = '1' then

      s_enctr <= '1';

      if s_enctr = C_enctrval then

        s_25mhz <= not (s_25mhz);
        s_enctr <= '0';

      end if;

    end if;

  end process P_prescaler;

  pixenable_o <= s_25mhz;					-- set outgoing signal

end rtl;
