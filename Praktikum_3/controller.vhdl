library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROLLER is
    port (
        clk, reset: in std_logic;

        -- Statussignale
        ir: in std_logic_vector(15 downto 0); -- Befehlswort
        ready, zero: in std_logic; -- weitere Statussignale

        -- Steuersignale
        c_reg_ldmem, c_reg_ldi, -- Auswahl beim Register-Laden
        c_regfile_load_lo, c_regfile_load_hi, -- Steuersignale Reg.-File
        c_pc_load, c_pc_inc, -- Steuereingaenge PC
        c_ir_load, -- Steuereingang IR
        c_mem_rd, c_mem_wr, -- Signale zum Speicher
        c_adr_pc_not_reg : out std_logic -- Auswahl Adress-Quelle
    );
end entity;

architecture RTL of CONTROLLER is

begin
end architecture;