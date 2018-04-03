----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : vgacontroller_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL VGA Controller
----------------------------------------------------------------------------
-- Revisions : 1
-- Date 		Version	Author 	Description
-- 2018.02.19	0.1		Resch	Projectstart VGA Controller, first Timings
-- 2018.02.21	0.2		Resch	Added Pattern Generators and TOP Design
-- 2018.02.22	0.3		Resch	Update TOP Design and first output via
--                              the nice vga app from FHTW to disk
-- 2018.03.27	0.4		Resch	Update signal routing sourcemultiplexer to
--								VGA controller
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture rtl of vgacontroller is

  -- values 640x480 pictures according specification
  constant C_hmax : std_logic_vector(9 downto 0) 		:= "1100011111"; -- 799
  constant C_vmax : std_logic_vector(9 downto 0) 		:= "1000001100"; -- 524
  constant C_hsyncstart : std_logic_vector(9 downto 0) 	:= "1010001111"; -- 655
  constant C_hsyncend : std_logic_vector(9 downto 0)	:= "1011101111"; -- 751
  constant C_vsyncstart : std_logic_vector(9 downto 0) 	:= "0111101001"; -- 489
  constant C_vsyncend : std_logic_vector(9 downto 0) 	:= "0111101011"; -- 491
  constant C_hpicture2 : std_logic_vector(9 downto 0) 	:= "1001111111"; -- 639
  constant C_vpicture2 : std_logic_vector(9 downto 0) 	:= "0111011111"; -- 479

  signal s_pixelhorizontal : std_logic_vector(9 downto 0);	-- counter horizontal
  signal s_pixelvertical : std_logic_vector(9 downto 0);	-- counter vertical
  signal s_enable : std_logic := '0';						-- enable signal for 1 pixel

begin

  -- forwards signals to VGA only if in valid range, otherwise 0
  P_out: process (clk_i, reset_i, s_pixelhorizontal, s_pixelvertical, red_i, green_i, blue_i)

  begin

    if unsigned(s_pixelhorizontal) > unsigned(C_hpicture2) or
       unsigned(s_pixelvertical) > unsigned(C_vpicture2) then

      red_o <= (others => '0');
      green_o <= (others => '0');
      blue_o <= (others => '0');

    else

	  red_o <= red_i;
	  green_o <= green_i;
      blue_o <= blue_i;

    end if;

  end process P_out;

  -- counts horizontal and vertical pixels
  P_count: process (clk_i, reset_i)

  begin

    if reset_i = '1' then
  
      s_pixelhorizontal <= (others => '0');
      s_pixelvertical <= (others => '0');
      s_enable <= '0';

    elsif clk_i'event and clk_i = '1' then

      -- set enable
      if pixenable_i = '1' then

	    s_enable <= '1';

      end if;

	  -- if enabled count up and reset enable
      if s_enable = '1' then

        s_pixelhorizontal <= unsigned(s_pixelhorizontal) + 1;
		s_enable <= '0';

		-- reset after last horizontal porch
		if s_pixelhorizontal = C_hmax then

		  s_pixelhorizontal <= (others => '0');
	      s_pixelvertical <= unsigned(s_pixelvertical) + 1;

		  -- reset after last vertical porch
    	  if s_pixelvertical = C_vmax then

			s_pixelvertical <= (others => '0');

          end if;

		end if;

      end if;

    end if;

  end process P_count;

  -- connect to output signals
  pixelhorizontal_o <= s_pixelhorizontal;
  pixelvertical_o <= s_pixelvertical;

  -- generates vertical and horizontal sync signal
  P_sync: process (s_pixelhorizontal, s_pixelvertical, reset_i)

  begin

    -- only active after reset
    if reset_i = '0' then

      -- hsync according specification
      if (unsigned(s_pixelhorizontal) <= unsigned(C_hsyncstart)) or 
         (unsigned(s_pixelhorizontal) > unsigned(C_hsyncend)) then

        hsync_o <= '0';

      else

        hsync_o <= '1';

      end if;

      -- vsync according specification
      if (unsigned(s_pixelvertical) <= unsigned(C_vsyncstart)) or 
         (unsigned(s_pixelvertical) > unsigned(C_vsyncend)) then

        vsync_o <= '0';

      else

        vsync_o <= '1';

      end if;

	-- reset both signals
    else
  
      hsync_o <= '0';
      vsync_o <= '0';

    end if;

  end process P_sync;

end rtl;
