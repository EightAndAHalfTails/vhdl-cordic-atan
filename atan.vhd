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
  
end arch;
