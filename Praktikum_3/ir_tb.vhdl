library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity IR_TB is
end entity;

architecture RTL of IR_TB is
    component IR is
        port (
            clk: in std_logic;
            load: in std_logic; -- Steuersignal
            ir_in: in std_logic_vector (15 downto 0); -- Dateneingang
            ir_out: out std_logic_vector (15 downto 0) -- Datenausgang
        );
    end component;

    signal clk, load : std_logic;
    signal ir_in, ir_out : std_logic_vector(15 downto 0);

    -- Only used for testing
    signal zeros: std_logic_vector(15 downto 0);

    for I_IR: IR use entity WORK.IR(RTL);
begin
    I_IR: IR port map (
        clk => clk,
        load => load,
        ir_in => ir_in,
        ir_out => ir_out
    );

    process
        variable period: time := 10 ns;
    begin
        zeros <= "0000000000000000";
        load <= '1';
        ir_in <= "0000000000000000";
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert ir_out = "0000000000000000"
            report "Specification and implementation differ! (ir_out = 0000000000000000)";

        for i in 0 to 20 loop
            load <= '0';
            ir_in <= std_logic_vector(unsigned(ir_in) + i * i);
            clk <= '0';
            wait for period / 2;
            clk <= '1';
            wait for period / 2;
            assert ir_out = "0000000000000000"
                report "Specification and implementation differ! (ir_out = 0000000000000000, load=false)";
        end loop;

        for i in 0 to 20 loop
            load <= '1';
            ir_in <= std_logic_vector(unsigned(zeros) + i * i);
            clk <= '0';
            wait for period / 2;
            clk <= '1';
            wait for period / 2;
            assert ir_out = std_logic_vector(unsigned(zeros) + i * i)
                report "Specification and implementation differ! (ir_out = ir_in)";
        end loop;
        
        assert false report "Simulation finished" severity note;
        wait;
    end process;
end architecture;