library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use work.atan;
use work.types.all;

entity atan_tb is
end atan_tb;

architecture tb of atan_tb is
  signal clk, reset, start, done: std_logic;
  signal xin : t_length;
  signal aout: t_angle;
  
  constant test_value: real := 20.0;
begin
  
  at: entity atan(unrolled) port map(
    clk => clk,
    reset => reset,
    xin => xin,
    aout => aout
  );
  
  clkgen: process
  begin
    clk <= '0';
    wait for 50 ns;
    clk <= '1';
    wait for 50 ns;
  end process clkgen;
  
  test: process
  begin
    reset <= '1';
    xin <= to_sfixed(0, t_length'left, t_length'right);
    wait until clk'event and clk = '1';
    reset <= '0';
    xin <= to_sfixed(test_value, t_length'left, t_length'right);
    wait until clk'event and clk = '1';
    start <= '1';
    wait until clk'event and clk = '1';
    start <= '0';
    for i in 0 to precision loop
      wait until clk'event and clk = '1';
    end loop; -- wait for output
    wait until clk'event and clk = '1'; --wait one more cycle to see the results
    report "atan(" & real'image(test_value) & ") is " & real'image(to_real(aout)) severity failure;
  end process test;
end tb;