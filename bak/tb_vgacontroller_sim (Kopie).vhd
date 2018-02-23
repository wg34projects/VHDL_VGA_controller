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
	pixenable_o : in std_logic;
    red_o : out std_logic_vector(3 downto 0);
	green_o : out std_logic_vector(3 downto 0);
	blue_o : out std_logic_vector(3 downto 0);
	hsync_o : out std_logic;
	vsync_o : out std_logic
  );
end component;

component vga_monitor
  port(
    s_reset_i     : in std_logic;
    s_vga_red_i   : in std_logic_vector(3 downto 0);
    s_vga_green_i : in std_logic_vector(3 downto 0);
    s_vga_blue_i  : in std_logic_vector(3 downto 0);
    s_vga_hsync_i : in std_logic;
    s_vga_vsync_i : in std_logic
    ); 
end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal pixenable_o : std_logic;
signal red_o : std_logic_vector(3 downto 0);
signal green_o : std_logic_vector(3 downto 0);
signal blue_o : std_logic_vector(3 downto 0);
signal hsync_o : std_logic;
signal vsync_o : std_logic;

begin

  i_vgacontroller : vgacontroller

  port map (
            clk_i => clk_i,
            reset_i => reset_i,
            pixenable_o => pixenable_o,
            red_o => red_o,
            green_o => green_o,
            blue_o => blue_o,
            hsync_o => hsync_o,
            vsync_o => vsync_o
           );

  i_vga_monitor : vga_monitor

  port map (
            s_reset_i => reset_i,
            s_vga_red_i => red_o,
            s_vga_green_i => green_o,
            s_vga_blue_i => blue_o,
            s_vga_hsync_i => hsync_o,
            s_vga_vsync_i => vsync_o
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

    pixenable_o <= '1';
    wait for 20 ns;
    pixenable_o <= '0';
    wait for 20 ns;

  end process p_enable;

  reset : process

  begin

    reset_i <= '1';
    wait for 35 ns;

    reset_i <= '0';
    wait for 10000 ms;

  end process reset;

  run : process

  begin

    wait for 10000 ms;

  end process run;

end sim;
