----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : pattern1_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Pattern Generator 1
----------------------------------------------------------------------------
-- Revisions : 1
-- Date 		Version	Author 	Description
-- 2018.02.19	0.1		Resch	Projectstart VGA Controller, first Timings
-- 2018.02.21	0.2		Resch	Added Pattern Generators and TOP Design
-- 2018.02.22	0.3		Resch	Update TOP Design and first output via
--                              the nice vga app from FHTW to disk
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
  constant C_maxaddrom1 : std_logic_vector(16 downto 0) := "10010101111111111"; -- 76799
  signal addr_rom1_o : std_logic_vector(16 downto 0);
  signal data_rom1_i : std_logic_vector(11 downto 0);

COMPONENT rom1 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );

END COMPONENT;

begin

  i_rom1 : rom1

  port map
  (
    clka => clk_i,
    addra => addr_rom1_o, -- IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    douta => data_rom1_i, -- OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    ena => pixenable_i
  );

  P_color: process (pixelhorizontal_i, pixelvertical_i, reset_i)

  variable v_tempaddr : std_logic_vector(19 downto 0);

  begin

    if reset_i = '0' then

      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
         (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

		v_tempaddr := unsigned(pixelhorizontal_i) + (unsigned(pixelvertical_i) * unsigned(C_hcounter));				
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      elsif  (unsigned(pixelvertical_i) <= unsigned(C_vpicture1)) and 
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then          

		v_tempaddr := (unsigned(pixelhorizontal_i) - unsigned(C_hcounter)) + (unsigned(pixelvertical_i) * unsigned(C_hcounter));				
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture1)) then

		v_tempaddr := unsigned(pixelhorizontal_i) + ((unsigned(pixelvertical_i) - unsigned(C_vcounter)) * unsigned(C_hcounter));				
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      elsif ((unsigned(pixelvertical_i) > unsigned(C_vpicture1)) and
             (unsigned(pixelvertical_i) <= unsigned(C_vpicture2))) and
            ((unsigned(pixelhorizontal_i) > unsigned(C_hpicture1)) and
             (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture2))) then 

		v_tempaddr := (unsigned(pixelhorizontal_i) - unsigned(C_hcounter)) + ((unsigned(pixelvertical_i) - unsigned(C_vcounter)) * unsigned(C_hcounter));							
        addr_rom1_o <= v_tempaddr(16 downto 0);
        memory1_r_o <= data_rom1_i(11 downto 8);
        memory1_g_o <= data_rom1_i(7 downto 4);
        memory1_b_o <= data_rom1_i(3 downto 0);

      else

        memory1_r_o <= (others => '0');
        memory1_g_o <= (others => '0');
        memory1_b_o <= (others => '0');

      end if;

    else

      memory1_r_o <= (others => '0');
      memory1_g_o <= (others => '0');
      memory1_b_o <= (others => '0');

    end if;

  end process P_color;

end rtl;
