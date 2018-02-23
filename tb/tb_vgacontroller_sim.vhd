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

library IEEE;
use IEEE.std_logic_1164.all;

architecture sim of tb_vgacontroller is

component vgacontroller
  port (
    clk_i : in std_logic;
    reset_i : in std_logic;
	pixenable_i : in std_logic;
	hsync_o : out std_logic;
	vsync_o : out std_logic;
	pixelhorizontal_o : out std_logic_vector(9 downto 0);
	pixelvertical_o : out std_logic_vector(9 downto 0)
  );
end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal pixenable_i : std_logic;
signal hsync_o : std_logic;
signal vsync_o : std_logic;
signal pixelhorizontal_o : std_logic_vector(9 downto 0);
signal pixelvertical_o : std_logic_vector(9 downto 0);

begin

  i_vgacontroller : vgacontroller

  port map (
            clk_i => clk_i,
            reset_i => reset_i,
            pixenable_i => pixenable_i,
            hsync_o => hsync_o,
            vsync_o => vsync_o,
            pixelhorizontal_o => pixelhorizontal_o,
            pixelvertical_o => pixelvertical_o
           );

  p_clk : process

  begin

    clk_i <= '1';
    wait for 5 ns;
    clk_i <= '0';
    wait for 5 ns;

  end process p_clk;

  p_enable : process

  begin

    pixenable_i <= '1';
    wait for 20 ns;
    pixenable_i <= '0';
    wait for 20 ns;

  end process p_enable;

  reset : process

  begin

    reset_i <= '1';
    wait for 35 ns;

    reset_i <= '0';
    wait for 100 ms;

  end process reset;

  run : process

  begin

    wait for 100 ms;

  end process run;

end sim;
