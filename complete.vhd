library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.fixed_pkg.all;
use work.atan;
use work.types.all;

entity complete is port(
  clk, reset, clk_en : in std_logic;
  din: in std_logic_vector(precision-1 downto 0);
  dout: out std_logic_vector(precision-1 downto 0)
  );
end complete;

architecture arch of complete is
  signal s_din: t_datain;
  signal s_dout: t_dataout;
  signal clk_in: std_logic;
  signal xin: t_length;
begin
  at: entity atan port map(
    clk => clk_in,
    reset => reset,
    xin => xin,
    aout => s_dout
  );
  
  s_din <= t_datain(din);
  dout <= to_slv(s_dout);
  
  clk_in <= clk and clk_en;
  
  preproc: process(din)
    variable shifted: ufixed(s_din'left-2 downto s_din'right);
    variable floored: ufixed(shifted'left downto xin'right);
  begin
    shifted := resize(shift_right(s_din,2), shifted'left, shifted'right);
    floored(floored'left downto 0) := shifted(shifted'left downto 0);
    floored(-1 downto floored'right) := (others => '0');
    xin <= resize(to_sfixed(floored) - to_sfixed(32, din'left-1, 0), xin'left, xin'right);
  end process preproc;
end architecture arch;    