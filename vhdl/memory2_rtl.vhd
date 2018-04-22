----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : memory2_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Memory 2
----------------------------------------------------------------------------
-- Revisions : 2
-- Date 		Version	Author 	Description
-- 2018.02.25	0.1		Resch	Implementation ROM1, working output
--                              also syntesized with success
-- 2018.02.27   0.2     Resch   Update error in main process memory1
--                              Update error in main process memory2
-- 2018.02.28   0.3     Resch   New version for memory1 to increase timing
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture rtl of memory2 is

  -- size of overlay
  constant C_hpicture : std_logic_vector(9 downto 0) := "0001100011"; -- 99
  constant C_vpicture : std_logic_vector(9 downto 0) := "0001100011"; -- 99
  -- max adress overlay
  constant C_maxadress : std_logic_vector(13 downto 0) := "10011100001111"; -- 9999

  -- pixelcounter and trigger
  signal pixelcount_s : std_logic_vector(13 downto 0);

begin

  -- calculates rom2 adress and reads data
  P_color: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

        pixelcount_s <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

      -- trigger for new pixel
      if (pixenable_i = '1') then

	    -- start only if inside valid range
        if countstart_i = '1' then

    	  -- increase only if smaller maxadress
          if unsigned(pixelcount_s) < unsigned(C_maxadress) then

            pixelcount_s <= unsigned(pixelcount_s) + 1;

          end if;

        end if;

    	  -- reset internal pixelcount only after a frame is done
          if unsigned(pixelhorizontal_i) = 0 and unsigned(pixelvertical_i) = 0 then

            pixelcount_s <= (others => '0');

          end if;

      end if;

	  -- adress to rom2 and data from rom2
      addr_rom2_o <= pixelcount_s(13 downto 0);
      memory2_r_o <= data_rom2_i(11 downto 8);
      memory2_g_o <= data_rom2_i(7 downto 4);
      memory2_b_o <= data_rom2_i(3 downto 0);

    end if;

  end process P_color;

end rtl;
