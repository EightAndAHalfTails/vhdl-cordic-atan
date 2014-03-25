library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use ieee.math_real.all;

package types is
  constant precision: integer := 32;
  constant log2_prec: integer := integer(ceil(log2(real(precision))));
  
  subtype t_length is sfixed(6 downto (6-precision+1));
  subtype t_angle is sfixed(2 downto (2-precision+1));
  subtype t_uangle is ufixed(1 downto (1-precision+1));
  
  subtype t_datain is ufixed(8 downto 8-precision+1);
  subtype t_dataout is t_angle;
  
  type rom is array(0 to precision-1) of t_uangle;
  
  function generate_rom return rom;
end package types;

package body types is
  function generate_rom return rom is
    variable v_rom: rom := (others => to_ufixed(0, t_uangle'left, t_uangle'right));
  begin
    for i in rom'range loop
      v_rom(i) := to_ufixed(arctan(2.0**(-i)), t_uangle'left, t_uangle'right);
    end loop;
    return v_rom;
  end function generate_rom;
end package body types;