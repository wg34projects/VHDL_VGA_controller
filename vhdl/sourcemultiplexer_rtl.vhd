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

architecture rtl of sourcemultiplexer is

  signal s_rgb : std_logic_vector(11 downto 0);

begin

  p_sourcemultiplexer : process (clk_i, reset_i)

  begin

    if reset_i = '1' then

      s_rgb <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

      if sel_i = "00" then
          s_rgb <= memory1_i;
      end if;

      if sel_i = "01" then
          s_rgb <= memory2_i;
      end if;

      if sel_i = "10" then
          s_rgb <= pattern1_i;
      end if;

      if sel_i = "11" then
          s_rgb <= pattern1_i;
      end if;

	end if;

  end process p_sourcemultiplexer;

  rgb_o <= s_rgb;

end rtl;
