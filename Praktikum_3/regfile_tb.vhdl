library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGFILE_TB is
end entity;

architecture RTL of REGFILE_TB is
    component REGFILE is
        port (
            clk: in std_logic;
            out0_data: out std_logic_vector (15 downto 0); -- Datenausgang 0
            out0_sel: in std_logic_vector (2 downto 0); -- Register-Nr. 0
            out1_data: out std_logic_vector (15 downto 0); -- Datenausgang 1
            out1_sel: in std_logic_vector (2 downto 0); -- Register-Nr. 1
            in_data: in std_logic_vector (15 downto 0); -- Dateneingang
            in_sel: in std_logic_vector (2 downto 0); -- Register-Wahl
            load_lo, load_hi: in std_logic -- Register laden
        );
    end component;

    signal clk, load_lo, load_hi: std_logic;
    signal in_sel, out0_sel, out1_sel: std_logic_vector(2 downto 0);
    signal in_data, out0_data, out1_data: std_logic_vector(15 downto 0);

    for I_REGFILE: REGFILE use entity WORK.REGFILE(RTL);
begin
    I_REGFILE: REGFILE port map(
        clk => clk, 
        load_lo => load_lo, 
        load_hi => load_hi, 
        in_sel => in_sel, 
        out0_sel => out0_sel, 
        out1_sel => out1_sel, 
        in_data => in_data, 
        out0_data => out0_data, 
        out1_data => out1_data 
    );

    -- Main process...
  process
    variable period : time := 10 ns;
  begin
    load_lo <= '1'; load_hi <= '1';
    in_sel <= "000"; in_data <= "0000000000000000";
    out0_sel <= "000"; out1_sel <= "000";
    wait for period / 2;
    for i in 0 to 7 loop
        load_lo <= '1'; load_hi <= '1';
        in_sel <= std_logic_vector(unsigned(in_sel) - unsigned(in_sel) + i); 
        in_data <= "0000000000000000";
        out0_sel <= std_logic_vector(unsigned(out0_sel) - unsigned(out0_sel) + i);
        out1_sel <= std_logic_vector(unsigned(out1_sel) - unsigned(out1_sel) + i);
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert out0_data = "0000000000000000" and out1_data = "0000000000000000"
            report "Specification and implementation differ! (out0_data = 0000000000000000 and out1_data = 0000000000000000)";
    end loop;

    for i in 0 to 7 loop
        load_lo <= '1'; load_hi <= '0';
        in_sel <= std_logic_vector(unsigned(in_sel) - unsigned(in_sel) + i); 
        in_data <= "1111111111111111";
        out0_sel <= std_logic_vector(unsigned(out0_sel) - unsigned(out0_sel) + i); 
        out1_sel <= std_logic_vector(unsigned(out1_sel) - unsigned(out1_sel) + i);
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert out0_data = "0000000011111111" and out1_data = "0000000011111111"
            report "Specification and implementation differ! (out0_data = 1111111100000000 and out1_data = 1111111100000000)";
    end loop;

    for i in 0 to 7 loop
        load_lo <= '0'; load_hi <= '1';
        in_sel <= std_logic_vector(unsigned(in_sel) - unsigned(in_sel) + i); 
        in_data <= "1111111111111111";
        out0_sel <= std_logic_vector(unsigned(out0_sel) - unsigned(out0_sel) + i); 
        out1_sel <= std_logic_vector(unsigned(out1_sel) - unsigned(out1_sel) + i);
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert out0_data = "1111111111111111" and out1_data = "1111111111111111"
            report "Specification and implementation differ! (out0_data = 1111111111111111 and out1_data = 1111111111111111)";
    end loop;

    for i in 0 to 6 loop
        load_lo <= '1'; load_hi <= '1';
        in_sel <= std_logic_vector(unsigned(in_sel) - unsigned(in_sel) + i); 
        in_data <= "1010101010101010";
        out0_sel <= std_logic_vector(unsigned(out0_sel) - unsigned(out0_sel) + i); 
        out1_sel <= std_logic_vector(unsigned(out1_sel) - unsigned(out1_sel) + i + 1);
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert out0_data = "1010101010101010" and out1_data = "1111111111111111"
            report "Specification and implementation differ! (out0_data = 1010101010101010 and out1_data = 1111111111111111)";
    end loop;

    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation
  end process;
end architecture;