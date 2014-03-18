library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;

entity cordic is
  port(
    i : in std_logic_vector(4 downto 0);
    
    xin : in std_logic_vector(31 downto 0);
    yin : in std_logic_vector(31 downto 0);
    zin : in std_logic_vector(31 downto 0);
    
    xout : out std_logic_vector(31 downto 0);
    yout : out std_logic_vector(31 downto 0);
    zout : out std_logic_vector(31 downto 0)
    );
  end cordic;
    
architecture arch of cordic is
  signal d : std_logic;
  signal e : sfixed(-1 downto -24);
  
  type rom is array(0 to 23) of sfixed(-1 downto -24);
  constant angle_lookup : rom := (
    to_sfixed(0.785398163397, -1, -24),
    to_sfixed(0.463647609001, -1, -24),
    to_sfixed(0.244978663127, -1, -24),
    to_sfixed(0.124354994547, -1, -24),
    to_sfixed(0.062418809996, -1, -24),
    to_sfixed(0.0312398334303, -1, -24),
    to_sfixed(0.0156237286205, -1, -24),
    to_sfixed(0.0078123410601, -1, -24),
    to_sfixed(0.00390623013197, -1, -24),
    to_sfixed(0.00195312251648, -1, -24),
    to_sfixed(0.000976562189559, -1, -24),
    to_sfixed(0.000488281211195, -1, -24),
    to_sfixed(0.000244140620149, -1, -24),
    to_sfixed(0.000122070311894, -1, -24),
    to_sfixed(6.10351561742e-05, -1, -24),
    to_sfixed(3.05175781155e-05, -1, -24),
    to_sfixed(1.52587890613e-05, -1, -24),
    to_sfixed(7.6293945311e-06, -1, -24),
    to_sfixed(3.81469726561e-06, -1, -24),
    to_sfixed(1.90734863281e-06, -1, -24),
    to_sfixed(9.53674316406e-07, -1, -24),
    to_sfixed(4.76837158203e-07, -1, -24),
    to_sfixed(2.38418579102e-07, -1, -24),
    to_sfixed(1.19209289551e-07, -1, -24)
  );
  begin
    
    e <= angle_lookup(to_integer(unsigned(i)));
    
    calculate : process(xin, yin, zin, e)
    begin
      if yin(31) = '1' then
        xout <= std_logic_vector(signed(xin) - shift_right(signed(yin), to_integer(unsigned(i))));
        yout <= std_logic_vector(signed(yin) + shift_right(signed(xin), to_integer(unsigned(i))));
        zout <= std_logic_vector(to_sfixed(zin, 7, -24) - e);
      else
        xout <= std_logic_vector(signed(xin) + shift_right(signed(yin), to_integer(unsigned(i))));
        yout <= std_logic_vector(signed(yin) - shift_right(signed(xin), to_integer(unsigned(i))));
        zout <= std_logic_vector(to_sfixed(zin, 7, -24) + e);
      end if;
    end process calculate;
end arch;
