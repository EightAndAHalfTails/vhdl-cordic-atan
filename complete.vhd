library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use work.atan;
use work.types.all;

entity complete is port(
  clk, reset, clk_en : in std_logic;
  din: in t_datain;
  dout: out t_dataout
);
end complete;

architecture arch of complete is
  signal clk_in: std_logic;
  signal xin: t_length;
begin
  at: entity atan port map(
    clk => clk_in,
    reset => reset,
    xin => xin,
    aout => dout
  );
  
  clk_in <= clk and clk_en;
  
  preproc: process(din)
    variable shifted: ufixed(din'left-2 downto din'right);
    variable floored: ufixed(shifted'left downto xin'right);
  begin
    shifted := resize(shift_right(din,2), shifted'left, shifted'right);
    floored(floored'left downto 0) := shifted(shifted'left downto 0);
    floored(-1 downto floored'right) := (others => '0');
    xin <= resize(to_sfixed(floored) - to_sfixed(32, din'left-1, 0), xin'left, xin'right);
  end process preproc;
end architecture arch;    