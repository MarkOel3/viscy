library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROLLER_TB is 
end entity;

architecture RTL of CONTROLLER_TB is
    component CONTROLLER is
        port (
            clk, reset: in std_logic;
            ir: in std_logic_vector(15 downto 0); -- Befehlswort
            ready, zero: in std_logic; -- weitere Statussignale
            c_reg_ldmem, c_reg_ldi, -- Auswahl beim Register-Laden
            c_regfile_load_lo, c_regfile_load_hi, -- Steuersignale Reg.-File
            c_pc_load, c_pc_inc, -- Steuereingaenge PC
            c_ir_load, -- Steuereingang IR
            c_mem_rd, c_mem_wr, -- Signale zum Speicher
            c_adr_pc_not_reg : out std_logic -- Auswahl Adress-Quelle
        );
    end component;
    
    signal clk, reset, ready, zero, c_reg_ldmem, c_reg_ldi, c_regfile_load_lo, c_regfile_load_hi : std_logic;
    signal c_pc_load, c_pc_inc, c_ir_load, c_mem_rd, c_mem_wr, c_adr_pc_not_reg : std_logic;
    signal ir : std_logic_vector(15 downto 0);

    for I_CONTROLLER: CONTROLLER use entity WORK.CONTROLLER(RTL);
begin
    I_CONTROLLER: CONTROLLER port map(
        clk => clk,
        reset => reset,
        ready => ready,
        zero => zero,
        c_reg_ldmem => c_reg_ldmem,
        c_reg_ldi => c_reg_ldi,
        c_regfile_load_lo => c_regfile_load_lo,
        c_regfile_load_hi => c_regfile_load_hi,
        c_pc_load => c_pc_load,
        c_pc_inc => c_pc_inc,
        c_ir_load => c_ir_load,
        c_mem_rd => c_mem_rd,
        c_mem_wr => c_mem_wr,
        c_adr_pc_not_reg => c_adr_pc_not_reg,
        ir => ir
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