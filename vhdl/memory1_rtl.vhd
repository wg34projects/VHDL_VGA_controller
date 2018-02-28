----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : memory1_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Memory 1
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

architecture rtl of memory1 is

  constant C_hpicture1 : std_logic_vector(9 downto 0) := "0100111111"; -- 319
  constant C_vpicture1 : std_logic_vector(9 downto 0) := "0011101111"; -- 239
  constant C_hpicture2 : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicture2 : std_logic_vector(9 downto 0) := "0111011111"; -- 479
  constant C_hcounter : std_logic_vector(9 downto 0) := "0101000000"; -- 320
  constant C_vcounter : std_logic_vector(9 downto 0) := "0011110000"; -- 240
  constant C_maxadress : std_logic_vector(16 downto 0) := "10010101111111111";
  signal pixelcount_1_s : std_logic_vector(16 downto 0);
  signal pixelcount_2_s : std_logic_vector(16 downto 0);
  signal pixelcountstore_s : std_logic;

begin

  P_color: process (clk_i, pixelhorizontal_i, pixelvertical_i, reset_i, data_rom1_i)

  variable v_tempaddr : std_logic_vector(19 downto 0) := (others => '0');	

  begin

    if reset_i = '1' then

      memory1_r_o <= (others => '0');
      memory1_g_o <= (others => '0');
      memory1_b_o <= (others => '0');
      addr_rom1_o <= (others => '0');
      pixelcount_1_s <= (others => '0');
      pixelcount_2_s <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

      memory1_r_o <= (others => '0');
      memory1_g_o <= (others => '0');
      memory1_b_o <= (others => '0');

      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) then

        if (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

          addr_rom1_o <= pixelcount_1_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_1_s) < unsigned(C_maxadress)) then

              pixelcount_1_s <= unsigned(pixelcount_1_s) + 1;

            else 
 
              pixelcount_1_s <= (others => '0');

            end if;

          end if;

        elsif ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
		       (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then

          addr_rom1_o <= pixelcount_2_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_2_s) < unsigned(C_maxadress)) then

              pixelcount_2_s <= unsigned(pixelcount_2_s) + 1;

            else 
 
              pixelcount_2_s <= (others => '0');

            end if;

          end if;

        end if;

      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
      (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) then

        if (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

          addr_rom1_o <= pixelcount_1_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_1_s) < unsigned(C_maxadress)) then

              pixelcount_1_s <= unsigned(pixelcount_1_s) + 1;

            else 
 
              pixelcount_1_s <= (others => '0');

            end if;

          end if;

        elsif ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
        (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then

          addr_rom1_o <= pixelcount_2_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_2_s) < unsigned(C_maxadress)) then

              pixelcount_2_s <= unsigned(pixelcount_2_s) + 1;

            else 
 
              pixelcount_2_s <= (others => '0');

            end if;

          end if;

        end if;

      end if;

    pixelcountstore_s <= pixelhorizontal_i(0);

    end if;

  end process P_color;

end rtl;
