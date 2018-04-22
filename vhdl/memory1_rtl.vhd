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
  signal pixelcount_1_s : std_logic_vector(16 downto 0);	-- counter for left top and bottom
  signal pixelcount_2_s : std_logic_vector(16 downto 0);	-- counter for right top and bottom

begin

  -- access to memory1 
  P_color: process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      pixelcount_1_s <= (others => '0');
      pixelcount_2_s <= (others => '0');
--      pixelcountstore_s <= '0';

    elsif clk_i'event and clk_i = '1' then

	  -- top left part
      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
         (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

	      -- trigger for new pixel
          if (pixenable_i = '1') then

			-- increase only if smaller maxadress or set to 0
            if (unsigned(pixelcount_1_s) < unsigned(C_maxadress)) then

              pixelcount_1_s <= unsigned(pixelcount_1_s) + 1;

            else 
 
              pixelcount_1_s <= (others => '0');

            end if;

          end if;

		  -- adress to rom1 and data from rom1
          addr_rom1_o <= pixelcount_1_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

	  -- top right part
      elsif  (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then  

          addr_rom1_o <= pixelcount_2_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

          if (pixenable_i = '1') then

            if (unsigned(pixelcount_2_s) < unsigned(C_maxadress)) then

              pixelcount_2_s <= unsigned(pixelcount_2_s) + 1;

            else 
 
              pixelcount_2_s <= (others => '0');

            end if;

          end if;

	  -- bottom left part
      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

          addr_rom1_o <= pixelcount_1_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

          if (pixenable_i = '1') then

            if (unsigned(pixelcount_1_s) < unsigned(C_maxadress)) then

              pixelcount_1_s <= unsigned(pixelcount_1_s) + 1;

            else 
 
              pixelcount_1_s <= (others => '0');

            end if;

          end if;

	  -- bottom right part
      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then 

          addr_rom1_o <= pixelcount_2_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

          if (pixenable_i = '1') then

            if (unsigned(pixelcount_2_s) < unsigned(C_maxadress)) then

              pixelcount_2_s <= unsigned(pixelcount_2_s) + 1;

            else 
 
              pixelcount_2_s <= (others => '0');

            end if;

         end if;

      end if;

    end if;

  end process P_color;

end rtl;
