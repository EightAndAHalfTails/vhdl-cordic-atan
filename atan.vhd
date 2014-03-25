library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.fixed_pkg.all;
use work.cordic;
use work.types.all;

entity atan is
  port(
    clk, reset : in std_logic;
    
    xin : in t_length;
    aout : out t_angle
    );
  end atan;
  
architecture unrolled of atan is
  type arrxy is array(1 to precision-1) of t_length;
  type arrz is array(1 to precision-1) of t_angle;
  signal xins, xouts, yins, youts : arrxy;
  signal zins, zouts : arrz;
begin
  gen: for I in 0 to precision-1 generate
    first: if I = 0 generate
      cor0 : entity cordic port map(
        i => to_unsigned(0, log2_prec),
        xin => to_sfixed(1, t_length'left, t_length'right),
        yin => xin,
        zin => to_sfixed(0, t_angle'left, t_angle'right),
        xout => xouts(1),
        yout => youts(1),
        zout => zouts(1)
      );
    end generate first;
    
    middle: if I > 0 and I < precision-1 generate
      corX : entity cordic port map(
        i => to_unsigned(I, log2_prec),
        xin => xins(I),
        yin => yins(I),
        zin => zins(I),
        xout => xouts(I+1),
        yout => youts(I+1),
        zout => zouts(I+1)
      );
    end generate middle;
    
    last: if I = precision-1 generate
      cor31 : entity cordic port map(
        i => to_unsigned(precision-1, log2_prec),
        xin => xins(precision-1),
        yin => yins(precision-1),
        zin => zins(precision-1),
        --xout => ,
        --yout => ,
        zout => aout
      );
    end generate last;
  end generate;
  
  clock: process
  begin
    wait until clk'event and clk ='1';
    for I in 1 to precision-1 loop
      if reset = '1' then
        xins(I) <= to_sfixed(0, t_length'left, t_length'right);
        yins(I) <= to_sfixed(0, t_length'left, t_length'right);
        zins(I) <= to_sfixed(0, t_angle'left, t_angle'right);
      else  
        xins(I) <= xouts(I);
        yins(I) <= youts(I);
        zins(I) <= zouts(I);
      end if;
    end loop;
  end process clock;
end architecture unrolled;