library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        a : in std_logic_vector (15 downto 0); -- Eingang A
        b : in std_logic_vector (15 downto 0); -- Eingang B
        sel : in std_logic_vector (2 downto 0); -- Operation
        y : out std_logic_vector (15 downto 0); -- Ausgang
        zero: out std_logic -- gesetzt, falls Eingang B = 0
    );
end ALU;

architecture RTL of ALU is
begin
    process (a, b, sel)
    begin
        case sel is 
            when "000" => y <= std_logic_vector(unsigned(a) + unsigned(b));
            when "001" => y <= std_logic_vector(unsigned(a) - unsigned(b));
            when "010" => y <= a(14 downto 0) & '0';
            when "011" => y <= a(15) & a(15 downto 1);
            when "100" => y <= a and b;
            when "101" => y <= a or b;
            when "110" => y <= a xor b;
            when "111" => y <= not a;
            when others => null;
        end case;
    end process;

    process (b)
    begin
        if b <= "0000000000000000" then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;
end architecture;