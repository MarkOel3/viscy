library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_TB is
end entity;

architecture RTL of PC_TB is
    component PC is
        port (
            clk: in std_logic;
            reset, inc, load: in std_logic; -- Steuersignale
            pc_in: in std_logic_vector (15 downto 0); -- Dateneingang
            pc_out: out std_logic_vector (15 downto 0) -- Ausgabe Zaehlerstand
            );
    end component;

    signal clk: std_logic;
    signal reset, inc, load: std_logic;
    signal pc_in, pc_out: std_logic_vector(15 downto 0);

    for I_PC: PC use entity WORK.PC(RTL);

begin
    I_PC: PC port map (clk => clk, reset => reset, inc => inc, load => load, pc_in => pc_in, pc_out => pc_out);

  process
    variable period: time := 10 ns;
  begin
    for i in 1 to 10 loop
        reset <= '0'; inc <= '1'; load <= '0'; 
        pc_in <= "0000000000000000";
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert pc_out = std_logic_vector(unsigned(pc_in) + i)
            report "Specification and implementation differ! (pc_out = i)";
    end loop;

    for i in 1 to 10 loop
        reset <= '0'; inc <= '0'; load <= '1'; 
        pc_in <= std_logic_vector(unsigned(pc_in) + i);
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert pc_out = pc_in
            report "Specification and implementation differ! (pc_out = pc_in)";
    end loop;

    for i in 1 to 10 loop
        reset <= '1'; inc <= '1'; load <= '1'; 
        pc_in <= std_logic_vector(unsigned(pc_in) + i);
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
        assert pc_out = "0000000000000000"
            report "Specification and implementation differ! (pc_out = pc_in)";
    end loop;

    
    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation
  end process;

end architecture;