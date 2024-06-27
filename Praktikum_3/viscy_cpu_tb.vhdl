library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity VISCY_CPU_TB is
end entity;

architecture RTL of VISCY_CPU_TB is
    component VISCY_CPU is
        port (
            clk: in std_logic;
            reset: in std_logic;
            adr: out std_logic_vector (15 downto 0);
            rdata: in std_logic_vector (15 downto 0);
            wdata: out std_logic_vector (15 downto 0);
            rd: out std_logic;
            wr: out std_logic;
            ready: in std_logic
        );
    end component;

    signal clk, reset, rd, wr, ready : std_logic;
    signal adr, rdata, wdata: std_logic_vector(15 downto 0);
    for I_VISCY_CPU: VISCY_CPU use entity WORK.VISCY_CPU(RTL);
begin
    I_VISCY_CPU: VISCY_CPU port map(
        clk => clk,
        reset => reset,
        rd => rd,
        wr => wr,
        ready => ready,
        adr => adr,
        rdata => rdata,
        wdata => wdata
    );

    process
        variable period : time := 10 ns;
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;

        assert false report "Simulation finished!" severity note;
        wait;
    end process;
end architecture;