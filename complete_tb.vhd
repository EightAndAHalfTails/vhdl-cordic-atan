library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use work.complete;
use work.types.all;
use ieee.math_real.all;

entity complete_tb is
end complete_tb;

architecture tb of complete_tb is
  signal clk, reset, start, done: std_logic;
  signal din : t_datain;
  signal aout: t_dataout;
  
  constant test_value: real := 20.0;
begin
  
  at: entity complete port map(
    clk => clk,
    reset => reset,
    din => din,
    dout => aout,
    clk_en => '1'
  );
  
  clkgen: process
  begin
    clk <= '0';
    wait for 50 ns;
    clk <= '1';
    wait for 50 ns;
  end process clkgen;
  
  test: process
    variable correct, obtained: real;
    constant latency : integer := precision;
  begin
    reset <= '1';
    din <= to_ufixed(0, din'left, din'right);
    wait until clk'event and clk = '1';
    reset <= '0';
    for i in 0 to (255+32) loop
      wait until clk'event and clk = '1';
      if i <= 255 then
        din <= to_ufixed(i, din'left, din'right);
      end if;
      if i >= latency then
        obtained := to_real(aout);
        correct := arctan(floor(real((i-latency)/4))-32.0);
        assert abs(obtained - correct) < 0.000001 report "atan(floor(" & integer'image(i-latency) & "/4) -32) is " & real'image(obtained) & ". Correct answer is " & real'image(correct) severity warning;
      end if;
    end loop;
    assert false severity failure;
  end process test;
end tb;