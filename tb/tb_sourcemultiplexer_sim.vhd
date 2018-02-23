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

architecture sim of tb_sourcemultiplexer is

component sourcemultiplexer
  port (
    clk_i : in std_logic;
    reset_i : in std_logic;
    sel_i : in std_logic_vector(1 downto 0);
    memory1_r_i : in std_logic_vector(3 downto 0);
    memory1_g_i : in std_logic_vector(3 downto 0);
    memory1_b_i : in std_logic_vector(3 downto 0);
    memory2_r_i : in std_logic_vector(3 downto 0);
    memory2_g_i : in std_logic_vector(3 downto 0);
    memory2_b_i : in std_logic_vector(3 downto 0);
    pattern1_r_i : in std_logic_vector(3 downto 0);
    pattern1_g_i : in std_logic_vector(3 downto 0);
    pattern1_b_i : in std_logic_vector(3 downto 0);
    pattern2_r_i : in std_logic_vector(3 downto 0);
    pattern2_g_i : in std_logic_vector(3 downto 0);
    pattern2_b_i : in std_logic_vector(3 downto 0);
    red_mux_o : out std_logic_vector(3 downto 0);
	green_mux_o : out std_logic_vector(3 downto 0);
	blue_mux_o : out std_logic_vector(3 downto 0)
  );
end component;

signal clk_i : std_logic;
signal reset_i : std_logic;
signal sel_i : std_logic_vector(1 downto 0);
signal memory1_r_i : std_logic_vector(3 downto 0);
signal memory1_g_i : std_logic_vector(3 downto 0);
signal memory1_b_i : std_logic_vector(3 downto 0);
signal memory2_r_i : std_logic_vector(3 downto 0);
signal memory2_g_i : std_logic_vector(3 downto 0);
signal memory2_b_i : std_logic_vector(3 downto 0);
signal pattern1_r_i : std_logic_vector(3 downto 0);
signal pattern1_g_i : std_logic_vector(3 downto 0);
signal pattern1_b_i : std_logic_vector(3 downto 0);
signal pattern2_r_i : std_logic_vector(3 downto 0);
signal pattern2_g_i : std_logic_vector(3 downto 0);
signal pattern2_b_i : std_logic_vector(3 downto 0);
signal red_mux_o : std_logic_vector(3 downto 0);
signal green_mux_o : std_logic_vector(3 downto 0);
signal blue_mux_o : std_logic_vector(3 downto 0);

begin

  i_sourcemultiplexer : sourcemultiplexer

  port map (
            clk_i => clk_i,
            reset_i => reset_i,
            sel_i => sel_i,
            memory1_r_i => memory1_r_i,
            memory1_g_i => memory1_g_i,
            memory1_b_i => memory1_b_i,
            memory2_r_i => memory2_r_i,
            memory2_g_i => memory2_g_i,
            memory2_b_i => memory2_b_i,
            pattern1_r_i => pattern1_r_i,
            pattern1_g_i => pattern1_g_i,
            pattern1_b_i => pattern1_b_i,
            pattern2_r_i => pattern2_r_i,
            pattern2_g_i => pattern2_g_i,
            pattern2_b_i => pattern2_b_i,
            red_mux_o => red_mux_o,
            green_mux_o => green_mux_o,
            blue_mux_o => blue_mux_o
           );

  p_clk : process

  begin

    clk_i <= '0';
    wait for 5 ns;
    clk_i <= '1';
    wait for 5 ns;

  end process p_clk;

  run : process

  begin

    reset_i <= '1';
    sel_i <= "00";
    memory1_r_i <= "0000";
    memory1_g_i <= "0000";
    memory1_b_i <= "0000";
    memory2_r_i <= "0000";
    memory2_g_i <= "0000";
    memory2_b_i <= "0000";
    pattern1_r_i <= "0000";
    pattern1_g_i <= "0000";
    pattern1_b_i <= "0000";
    pattern2_r_i <= "0000";
    pattern2_g_i <= "0000";
    pattern2_b_i <= "0000";
    wait for 10 ns;

    reset_i <= '0';
    wait for 10 ns;

    sel_i <= "00";
    memory1_r_i <= "1111";
    memory1_g_i <= "0000";
    memory1_b_i <= "0000";
    memory2_r_i <= "0000";
    memory2_g_i <= "0000";
    memory2_b_i <= "0000";
    pattern1_r_i <= "0000";
    pattern1_g_i <= "0000";
    pattern1_b_i <= "0000";
    pattern2_r_i <= "0000";
    pattern2_g_i <= "0000";
    pattern2_b_i <= "0000";
    wait for 100 ns;

    sel_i <= "01";
    memory1_r_i <= "0000";
    memory1_g_i <= "0000";
    memory1_b_i <= "0000";
    memory2_r_i <= "0000";
    memory2_g_i <= "1111";
    memory2_b_i <= "0000";
    pattern1_r_i <= "0000";
    pattern1_g_i <= "0000";
    pattern1_b_i <= "0000";
    pattern2_r_i <= "0000";
    pattern2_g_i <= "0000";
    pattern2_b_i <= "0000";
    wait for 100 ns;

    sel_i <= "10";
    memory1_r_i <= "0000";
    memory1_g_i <= "0000";
    memory1_b_i <= "0000";
    memory2_r_i <= "0000";
    memory2_g_i <= "0000";
    memory2_b_i <= "0000";
    pattern1_r_i <= "0000";
    pattern1_g_i <= "0000";
    pattern1_b_i <= "1111";
    pattern2_r_i <= "0000";
    pattern2_g_i <= "0000";
    pattern2_b_i <= "0000";
    wait for 100 ns;

    sel_i <= "11";
    memory1_r_i <= "0000";
    memory1_g_i <= "0000";
    memory1_b_i <= "0000";
    memory2_r_i <= "0000";
    memory2_g_i <= "0000";
    memory2_b_i <= "0000";
    pattern1_r_i <= "0000";
    pattern1_g_i <= "0000";
    pattern1_b_i <= "0000";
    pattern2_r_i <= "1111";
    pattern2_g_i <= "1111";
    pattern2_b_i <= "1111";
    wait for 100 ns;

  end process run;

end sim;
