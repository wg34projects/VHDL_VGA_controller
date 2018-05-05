----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : memory1_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Memory 1
----------------------------------------------------------------------------
-- Revisions : 2
-- Date       Version Author  Description
-- 2018.02.25 0.1     Resch   Implementation ROM1, working output
--                            also syntesized with success
-- 2018.02.27 0.2     Resch   Update error in main process memory1
--                            Update error in main process memory2
-- 2018.02.28 0.3     Resch   New version for memory1 to increase timing
-- 2018.05.01 0.4     Resch   final code style check and comments
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture rtl of memory1 is

  -- picture dimensions - 4 areas
  constant C_hpicture1 : std_logic_vector(9 downto 0) := "0100111111"; -- 319
  constant C_vpicture1 : std_logic_vector(9 downto 0) := "0011101111"; -- 239
  constant C_hpicture2 : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicture2 : std_logic_vector(9 downto 0) := "0111011111"; -- 479
  -- maxadress to access memory
  constant C_maxadress : std_logic_vector(16 downto 0) := "10010101111111111"; -- 76799
  -- signals for counters
  signal s_pixelcount_1 : std_logic_vector(16 downto 0);  -- counter for left top and bottom
  signal s_pixelcount_2 : std_logic_vector(16 downto 0);  -- counter for right top and bottom

begin

  -- access to memory1 
  P_color: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_pixelcount_1 <= (others => '0');
      s_pixelcount_2 <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

      -- top left part
      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
         (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

          -- adress to rom1 and data from rom1
        addr_rom1_o <= s_pixelcount_1;
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);          

        -- trigger for new pixel
        if (pixenable_i = '1') then

          -- increase only if smaller maxadress or set to 0
          if (unsigned(s_pixelcount_1) < unsigned(C_maxadress)) then

            s_pixelcount_1 <= unsigned(s_pixelcount_1) + 1;

          else 
 
            s_pixelcount_1 <= (others => '0');

          end if;

        end if;

      -- top right part
      elsif  (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then  

        addr_rom1_o <= s_pixelcount_2;
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

        if (pixenable_i = '1') then

          if (unsigned(s_pixelcount_2) < unsigned(C_maxadress)) then

            s_pixelcount_2 <= unsigned(s_pixelcount_2) + 1;

          else 
 
            s_pixelcount_2 <= (others => '0');

          end if;

        end if;

      -- bottom left part
      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

        addr_rom1_o <= s_pixelcount_1;
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

        if (pixenable_i = '1') then

          if (unsigned(s_pixelcount_1) < unsigned(C_maxadress)) then

            s_pixelcount_1 <= unsigned(s_pixelcount_1) + 1;

          else 
 
            s_pixelcount_1 <= (others => '0');

          end if;

        end if;

      -- bottom right part
      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then 

        addr_rom1_o <= s_pixelcount_2;
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

        if (pixenable_i = '1') then

          if (unsigned(s_pixelcount_2) < unsigned(C_maxadress)) then

            s_pixelcount_2 <= unsigned(s_pixelcount_2) + 1;

          else 
 
            s_pixelcount_2 <= (others => '0');

          end if;

        end if;

      end if;

    end if;

  end process P_color;

end rtl;