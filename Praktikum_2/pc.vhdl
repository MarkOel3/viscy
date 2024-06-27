library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
    clk: in std_logic;
    reset, inc, load: in std_logic; -- Steuersignale
    pc_in: in std_logic_vector (15 downto 0); -- Dateneingang
    pc_out: out std_logic_vector (15 downto 0) -- Ausgabe Zaehlerstand
    );
end PC;

architecture RTL of PC is
    signal current_pc: std_logic_vector(15 downto 0);
begin
    process (clk, reset, inc, load, pc_in, current_pc)
    begin
        current_pc <= current_pc;
        if reset = '1' or (current_pc < "0000000000000000") then
            current_pc <= "0000000000000000"; 
        elsif rising_edge(clk) then
            if load = '1' then
                current_pc <= pc_in;
            elsif inc = '1' then
                current_pc <= std_logic_vector(unsigned(current_pc) + 1);
            end if;    
        end if;
    end process;

    pc_out <= current_pc;
end architecture;