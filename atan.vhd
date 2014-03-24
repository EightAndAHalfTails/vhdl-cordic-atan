library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use work.cordic;

entity atan is
  port(
    clk, reset, start : in std_logic;
    done : out std_logic;
    
    xin : in sfixed(6 downto -25);
    aout : out sfixed(1 downto -30)
    );
  end atan;
  
architecture arch of atan is
  signal c_i : unsigned(4 downto 0);
  signal c_xin, c_yin, c_xout, c_yout : sfixed(6 downto -25);
  signal c_zin, c_zout : sfixed(1 downto -30);
  
begin
  cor : entity cordic port map(
    i => c_i,
    xin => c_xin,
    yin => c_yin,
    zin => c_zin,
    xout => c_xout,
    yout => c_yout,
    zout => c_zout
  );
  
  aout <= c_zout;

  next_step : process
    variable step : integer := 31;
  begin
    wait until clk'event and clk='1';
    if reset = '1' then
      step := 31;
    elsif step = 31 and start = '1' then
      step := 0;
    elsif step = 31 then
      step := 31;
    elsif step < 31 then
      step := step + 1;
    end if;
    
    c_i <= to_unsigned(step, 5);
  end process next_step;     

  input_registers : process
  begin
    wait until clk'event and clk = '1';
    if to_integer(unsigned(c_i)) = 31 or reset = '1' then
      c_xin <= to_sfixed(1, 6, -25);
      c_yin <= xin;
      c_zin <= to_sfixed(0, 1, -30);
    else
      c_xin <= c_xout;
      c_yin <= c_yout;
      c_zin <= c_zout;
    end if;
  end process input_registers;

  if_done : process(c_i)
  begin
    if to_integer(unsigned(c_i)) = 31 then
      done <= '1';
    else
      done <= '0';
    end if;
  end process if_done;
end arch;