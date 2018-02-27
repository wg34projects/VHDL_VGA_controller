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
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- generated IP XILINX

architecture rtl of memory1 is

  constant C_hpicture1 : std_logic_vector(9 downto 0) := "0100111111"; -- 319
  constant C_vpicture1 : std_logic_vector(9 downto 0) := "0011101111"; -- 239
  constant C_hpicture2 : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicture2 : std_logic_vector(9 downto 0) := "0111011111"; -- 479
  constant C_hcounter : std_logic_vector(9 downto 0) := "0101000000"; -- 320
  constant C_vcounter : std_logic_vector(9 downto 0) := "0011110000"; -- 240

begin

  P_color: process (clk_i, pixelhorizontal_i, pixelvertical_i, reset_i, data_rom1_i)

  variable v_tempaddr : std_logic_vector(19 downto 0) := (others => '0');	

  begin

    if reset_i = '1' then

      memory1_r_o <= (others => '0');
      memory1_g_o <= (others => '0');
      memory1_b_o <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

        memory1_r_o <= (others => '0');
        memory1_g_o <= (others => '0');
        memory1_b_o <= (others => '0');

      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
         (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

		v_tempaddr := unsigned(pixelhorizontal_i) + (unsigned(pixelvertical_i) * unsigned(C_hcounter));				
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      elsif  (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) < unsigned(C_hpicture2))) then          

		v_tempaddr := (unsigned(pixelhorizontal_i) - unsigned(C_hcounter)) + (unsigned(pixelvertical_i) * unsigned(C_hcounter));				
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
             (unsigned(pixelhorizontal_i) < unsigned(C_hpicture1)) then

		v_tempaddr := unsigned(pixelhorizontal_i) + ((unsigned(pixelvertical_i) - unsigned(C_vcounter)) * unsigned(C_hcounter));				
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) < unsigned(C_hpicture2))) then 

		v_tempaddr := (unsigned(pixelhorizontal_i) - unsigned(C_hcounter)) + ((unsigned(pixelvertical_i) - unsigned(C_vcounter)) * unsigned(C_hcounter));							
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      end if;

    end if;

  end process P_color;

end rtl;
