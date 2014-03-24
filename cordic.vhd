library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;

entity cordic is
  port(
    i : in unsigned(4 downto 0);
    
    xin : in sfixed(6 downto -25);
    yin : in sfixed(6 downto -25);
    zin : in sfixed(1 downto -30);
    
    xout : out sfixed(6 downto -25);
    yout : out sfixed(6 downto -25);
    zout : out sfixed(1 downto -30)
    );
  end cordic;
    
architecture arch of cordic is
  signal e : ufixed(-1 downto -32);
  
  type rom is array(0 to 31) of ufixed(-1 downto -32);
  constant angle_lookup : rom := (
    to_ufixed(0.785398163397, -1, -32),
    to_ufixed(0.463647609001, -1, -32),
    to_ufixed(0.244978663127, -1, -32),
    to_ufixed(0.124354994547, -1, -32),
    to_ufixed(0.062418809996, -1, -32),
    to_ufixed(0.0312398334303, -1, -32),
    to_ufixed(0.0156237286205, -1, -32),
    to_ufixed(0.0078123410601, -1, -32),
    to_ufixed(0.00390623013197, -1, -32),
    to_ufixed(0.00195312251648, -1, -32),
    to_ufixed(0.000976562189559, -1, -32),
    to_ufixed(0.000488281211195, -1, -32),
    to_ufixed(0.000244140620149, -1, -32),
    to_ufixed(0.000122070311894, -1, -32),
    to_ufixed(6.10351561742e-05, -1, -32),
    to_ufixed(3.05175781155e-05, -1, -32),
    to_ufixed(1.52587890613e-05, -1, -32),
    to_ufixed(7.6293945311e-06, -1, -32),
    to_ufixed(3.81469726561e-06, -1, -32),
    to_ufixed(1.90734863281e-06, -1, -32),
    to_ufixed(9.53674316406e-07, -1, -32),
    to_ufixed(4.76837158203e-07, -1, -32),
    to_ufixed(2.38418579102e-07, -1, -32),
    to_ufixed(1.19209289551e-07, -1, -32),
    to_ufixed(5.96046447754e-08, -1, -32),
    to_ufixed(2.98023223877e-08, -1, -32),
    to_ufixed(1.49011611938e-08, -1, -32),
    to_ufixed(7.45058059692e-09, -1, -32),
    to_ufixed(3.72529029846e-09, -1, -32),
    to_ufixed(1.86264514923e-09, -1, -32),
    to_ufixed(9.31322574615e-10, -1, -32),
    to_ufixed(4.65661287308e-10, -1, -32)
  );
  begin
    
    e <= angle_lookup(to_integer(i));
    
    calculate : process(xin, yin, zin, e, i)
    begin
      if yin(yin'left) = '1' then
        xout <= resize(xin - shift_right(yin, to_integer(i)), 6, -25);
        yout <= resize(yin + shift_right(xin, to_integer(i)), 6, -25);
        zout <= resize(zin - to_sfixed(e), 1, -30);
      else
        xout <= resize(xin + shift_right(yin, to_integer(i)), 6, -25);
        yout <= resize(yin - shift_right(xin, to_integer(i)), 6, -25);
        zout <= resize(zin + to_sfixed(e), 1, -30);
      end if;
    end process calculate;
end arch;