library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use work.cordic;

entity atan is
  port(
    clk, reset, start : in std_logic;
    done : out std_logic;
    
    xin : in std_logic_vector(31 downto 0);
    aout : out std_logic_vector(31 downto 0)
    );
  end atan;
  
architecture arch of atan is
  signal c_i : std_logic_vector(4 downto 0);
  signal c_xin, c_yin, c_zin, c_xout, c_yout, c_zout : std_logic_vector(31 downto 0);
  variable step : integer := 0;

begin
  cor : entity cordic port map(
    i => c_i,
    xin => c_xin,
    yin => c_yin,
    zin => c_zin,
    xout => c_xout,
    yin => c_yout,
    zin => c_zout
  );
  
  aout <= c_zout;
  c_i <= std_logic_vector(to_unsigned(step));

  next_step : process
  begin
    wait until clk'event and clk='1';
    if reset = '1' then
      step := 0;
    elsif step = 0 and start = '0' then
      step := 0;
    elsif step = 23 then
      step := 0;
    else
      c_i := step + 1;
    end if;
  end process next_step;     

  input_registers : process
  begin
    wait until clk'event and clk = '1';
    if step = 0 then
      c_xin <= std_logic_vector(to_unsigned(1));
      c_yin <= xin;
      c_zin <= std_logic_vector(to_unsigned(0));
    else
      c_xin <= c_xout;
      c_yin <= c_yout;
      c_zin <= c_zout;
    end if;
  end process input_registers;

  if_done : process(step)
  begin
    if step = 23 then
      done <= '1';
    else
      done <= '0';
    end if;
  end process if_done;
end arch;
