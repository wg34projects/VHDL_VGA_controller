library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture rtl of memory1 is

  constant C_hpicture1 : std_logic_vector(9 downto 0) := "0100111111"; -- 319
  constant C_vpicture1 : std_logic_vector(9 downto 0) := "0011101111"; -- 239
  constant C_hpicture2 : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicture2 : std_logic_vector(9 downto 0) := "0111011111"; -- 479
  constant C_hcounter : std_logic_vector(9 downto 0) := "0101000000"; -- 320
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

      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
         (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_1_s) < unsigned(C_maxadress)) then

              pixelcount_1_s <= unsigned(pixelcount_1_s) + 1;

            else 
 
              pixelcount_1_s <= (others => '0');

            end if;

          end if;

          addr_rom1_o <= pixelcount_1_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

      elsif  (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then  

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_2_s) < unsigned(C_maxadress)) then

              pixelcount_2_s <= unsigned(pixelcount_2_s) + 1;

            else 
 
              pixelcount_2_s <= (others => '0');

            end if;

          end if;

          addr_rom1_o <= pixelcount_2_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_1_s) < unsigned(C_maxadress)) then

              pixelcount_1_s <= unsigned(pixelcount_1_s) + 1;

            else 
 
              pixelcount_1_s <= (others => '0');

            end if;

          end if;

          addr_rom1_o <= pixelcount_1_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then 

          if (pixelhorizontal_i(0) /= pixelcountstore_s) then

            if (unsigned(pixelcount_2_s) < unsigned(C_maxadress)) then

              pixelcount_2_s <= unsigned(pixelcount_2_s) + 1;

            else 
 
              pixelcount_2_s <= (others => '0');

            end if;

          end if;

          addr_rom1_o <= pixelcount_2_s;
          memory1_r_o <= data_rom1_i(11 downto 8);
          memory1_g_o <= data_rom1_i(7 downto 4);
          memory1_b_o <= data_rom1_i(3 downto 0);

      else

        memory1_r_o <= (others => '0');
        memory1_g_o <= (others => '0');
        memory1_b_o <= (others => '0');

      end if;

    pixelcountstore_s <= pixelhorizontal_i(0);

    end if;

  end process P_color;

end rtl;
