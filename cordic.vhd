library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.fixed_pkg.all;
use work.types.all;

entity cordic is
  port(
    i : in unsigned(log2_prec-1 downto 0);
    
    xin : in t_length;
    yin : in t_length;
    zin : in t_angle;
    
    xout : out t_length;
    yout : out t_length;
    zout : out t_angle
    );
  end cordic;
    
architecture arch of cordic is
  signal e : t_uangle;
  constant angle_lookup : rom := generate_rom;
  begin
    
    e <= angle_lookup(to_integer(i));
    
    calculate : process(xin, yin, zin, e, i)
    begin
      if yin(yin'left) = '1' then
        xout <= resize(xin - shift_right(yin, to_integer(i)), xin'left, xin'right);
        yout <= resize(yin + shift_right(xin, to_integer(i)), yin'left, yin'right);
        zout <= resize(zin - to_sfixed(e), zin'left, zin'right);
      else
        xout <= resize(xin + shift_right(yin, to_integer(i)), xin'left, xin'right);
        yout <= resize(yin - shift_right(xin, to_integer(i)), yin'left, yin'right);
        zout <= resize(zin + to_sfixed(e), zin'left, zin'right);
      end if;
    end process calculate;
end arch;