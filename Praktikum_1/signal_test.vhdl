library IEEE;
use IEEE.std_logic_1164.all;


entity TEST is
  port (clk: in std_logic);
end TEST;


architecture BEHAVIOR of TEST is
  signal a, b, c: std_logic := '0';
begin
  process (clk)
    variable temp_a, temp_b, temp_c: std_logic;
  begin
    if rising_edge (clk) then
      temp_a := '1';
      a <= temp_a;
      temp_b := not (temp_a or c);
      b <= temp_b;
      temp_c := not temp_b;
      c <= temp_c;
    end if;
  end process;

end BEHAVIOR;