library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR is
    port (
        clk: in std_logic;
        load: in std_logic; -- Steuersignal
        ir_in: in std_logic_vector (15 downto 0); -- Dateneingang
        ir_out: out std_logic_vector (15 downto 0) -- Datenausgang
    );
end IR;

architecture RTL of IR is
    signal current_instruction: std_logic_vector(15 downto 0);
begin
    process (clk, load, ir_in, current_instruction)
    begin
        current_instruction <= current_instruction;
        if rising_edge(clk) then
            if load = '1' then
                current_instruction <= ir_in;   
            end if;
        end if;
    end process;

    ir_out <= current_instruction;
end architecture;