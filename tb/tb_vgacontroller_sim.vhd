----------------------------------------------------------------------------
-- Title : VGA Controller
-- Project : Chip Design BEL4
----------------------------------------------------------------------------
-- File : tb_vgacontroller_sim.vhd
-- Author : Resch
-- Company : FHTW
-- Last update: 01.05.2018
-- Platform : VHDL, Modelsim 10.5b, Xilinx Vivado 2016.1
----------------------------------------------------------------------------
-- Description: TESTBENCH ARCHITECTURE SIM VGA Controller
----------------------------------------------------------------------------
-- Revisions : 1
-- Date       Version Author  Description
-- 2018.02.18 0.1     Resch   Projectstart
-- 2018.05.01 0.2     Resch   final code style check and comments
---------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

architecture sim of tb_vgacontroller is

component vgacontroller
  port
  (
    clk_i : in std_logic;
    reset_i : in std_logic;
    pixenable_i : in std_logic;                           -- 25MHz enable
    hsync_o : out std_logic;                              -- generated hsync VGA
    vsync_o : out std_logic;                              -- generated vsync VGA
    pixelhorizontal_o : out std_logic_vector(9 downto 0); -- counter horizontal
    pixelvertical_o : out std_logic_vector(9 downto 0);   -- counter vertical (lines)
    red_i : in std_logic_vector(3 downto 0);              -- data from sourcemultiplexer
    green_i : in std_logic_vector(3 downto 0);
    blue_i : in std_logic_vector(3 downto 0);
    red_o : out std_logic_vector(3 downto 0);             -- data to VGA
    green_o : out std_logic_vector(3 downto 0);
    blue_o : out std_logic_vector(3 downto 0)
  );
end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal pixenable_i : std_logic;
signal hsync_o : std_logic;
signal vsync_o : std_logic;
signal pixelhorizontal_o : std_logic_vector(9 downto 0);
signal pixelvertical_o : std_logic_vector(9 downto 0);
signal red_i : std_logic_vector(3 downto 0);
signal green_i : std_logic_vector(3 downto 0);
signal blue_i : std_logic_vector(3 downto 0);
signal red_o : std_logic_vector(3 downto 0);
signal green_o : std_logic_vector(3 downto 0);
signal blue_o : std_logic_vector(3 downto 0);

begin

  i_vgacontroller : vgacontroller

  port map 
  (
    clk_i => clk_i,
    reset_i => reset_i,
    pixenable_i => pixenable_i,
    hsync_o => hsync_o,
    vsync_o => vsync_o,
    pixelhorizontal_o => pixelhorizontal_o,
    pixelvertical_o => pixelvertical_o,
    red_i => red_i,
    green_i => green_i,
    blue_i => blue_i,
    red_o => red_o,
    green_o => green_o,
    blue_o => blue_o
   );

  P_clk : process

  begin

    clk_i <= '1';
    wait for 5 ns;
    clk_i <= '0';
    wait for 5 ns;

  end process P_clk;

  P_enable : process

  begin

    pixenable_i <= '1';
    wait for 20 ns;
    pixenable_i <= '0';
    wait for 20 ns;

  end process P_enable;

  P_reset : process

  begin

    reset_i <= '1';
    red_i <= "0000";
    green_i <= "0000";
    blue_i <= "0000";
    wait for 35 ns;

    reset_i <= '0';
    red_i <= "0100";
    green_i <= "0010";
    blue_i <= "0001";
    wait for 100 ms;

  end process P_reset;

  P_run : process

  begin

    wait for 200 ms;

  end process P_run;

end sim;