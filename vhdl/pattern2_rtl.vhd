----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : pattern2_rtl.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 19.02.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: ARCHITECTURE RTL Pattern Generator 2
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

architecture rtl of pattern2 is

  -- maximum picture setting
  constant C_hpicture : std_logic_vector(9 downto 0) := "1001111111"; -- 639
  constant C_vpicture : std_logic_vector(9 downto 0) := "0111011111"; -- 479
  -- pattern width and height
  constant C_blockhorizontal : natural := 64;
  constant C_blockvertical : natural := 48;
  -- create natural array for color settins "chessboard"
  type CHESSBOARD is array (0 to 9, 0 to 9) of natural range 1 to 3;
  -- in the array 1 = red, 2 = green, 3 = blue - pattern according specification
  -- signal s_chessboardcolor reflects then the correct color according array
  signal s_chessboardcolorlist : CHESSBOARD := ((1, 2, 3, 1, 2, 3, 1, 2, 3, 1),
                                                (2, 3, 1, 2, 3, 1, 2, 3, 1, 2),
                                                (3, 1, 2, 3, 1, 2, 3, 1, 2, 3),
                                                (1, 2, 3, 1, 2, 3, 1, 2, 3, 1),
                                                (2, 3, 1, 2, 3, 1, 2, 3, 1, 2),
                                                (3, 1, 2, 3, 1, 2, 3, 1, 2, 3),
                                                (1, 2, 3, 1, 2, 3, 1, 2, 3, 1),
                                                (2, 3, 1, 2, 3, 1, 2, 3, 1, 2),
                                                (3, 1, 2, 3, 1, 2, 3, 1, 2, 3),
                                                (1, 2, 3, 1, 2, 3, 1, 2, 3, 1));
  signal s_chessboardcolor : natural range 0 to 3;

begin

  -- generates chessboardstyle pattern
  P_chessboard: process (clk_i, reset_i) 

  -- inside process variables used for counting
  variable v_i : natural := 0;				-- loop horizontal
  variable v_j : natural := 0;				-- loop vertical
  variable v_horizontal : natural := 0;
  variable v_vertical : natural := 0;
  variable v_horizontalnext : natural := 0;
  variable v_verticalnext : natural := 0;

  begin

    if reset_i = '1' then
  
      s_chessboardcolor <= 0;

    elsif clk_i'event and clk_i = '1' then

    s_chessboardcolor <= 0;

	  -- loops only when inside valid picture values
      if (unsigned(pixelvertical_i) <= unsigned(C_vpicture)) and 
         (unsigned(pixelhorizontal_i) <= unsigned(C_hpicture)) then
    
	    -- horizontal pattern
        for v_i in 0 to 9 loop

		  -- vertical pattern
          for v_j in 0 to 9 loop

		    -- horizontal dividing in 10 parts
            v_horizontal := v_i * C_blockhorizontal;
            v_horizontalnext := v_horizontal + C_blockhorizontal;
            -- vertical dividing in 10 parts
            v_vertical := v_j * C_blockvertical;
            v_verticalnext := v_vertical + C_blockvertical;

		    -- range check horizontal
            if (unsigned(pixelhorizontal_i) >= (v_horizontal)) and
               (unsigned(pixelhorizontal_i) <  (v_horizontalnext)) then

			  -- range check vertical
              if (unsigned(pixelvertical_i) >= (v_vertical)) and
                 (unsigned(pixelvertical_i) <  (v_verticalnext)) then

				-- set correct color according position in matrix
                s_chessboardcolor <= s_chessboardcolorlist(v_j, v_i);

              end if;

            end if;

          end loop;

        end loop;

      else

        s_chessboardcolor <= 0;

      end if;

    end if;

  end process P_chessboard;

  -- output of the pattern
  P_color: process (clk_i, reset_i) 

  begin

    if reset_i = '1' then
  
        pattern2_r_o <= (others => '0');
        pattern2_g_o <= (others => '0');
        pattern2_b_o <= (others => '0');

    elsif clk_i'event and clk_i = '1' then

	  -- red field on chessboard
      if (s_chessboardcolor = 1) then

        pattern2_r_o <= (others => '1');
        pattern2_g_o <= (others => '0');
        pattern2_b_o <= (others => '0');

	  -- green field on chessboard
      elsif (s_chessboardcolor = 2) then

        pattern2_r_o <= (others => '0');
        pattern2_g_o <= (others => '1');
        pattern2_b_o <= (others => '0');

	  -- blue field on chessboard
      elsif (s_chessboardcolor = 3) then

        pattern2_r_o <= (others => '0');
        pattern2_g_o <= (others => '0');
        pattern2_b_o <= (others => '1');

	  -- no signal
      else

	    pattern2_r_o <= (others => '0');
        pattern2_g_o <= (others => '0');
        pattern2_b_o <= (others => '0');

      end if;

    end if;

  end process P_color;

end rtl;
