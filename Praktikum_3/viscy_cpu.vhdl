library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity VISCY_CPU is
    port (
        clk: in std_logic;
        reset: in std_logic;

        -- Adressbus
        adr: out std_logic_vector (15 downto 0);
        
        -- Datenbus (lesen)
        rdata: in std_logic_vector (15 downto 0);

        -- Datenbus (schreiben)
        wdata: out std_logic_vector (15 downto 0);
        
        -- Lese/Schreibanforderung
        rd, wr: out std_logic;

        -- Rückmeldung für Lese/Schreibzugriff
        ready: in std_logic
    );
end entity;

architecture RTL of VISCY_CPU is
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

    component ALU is
        port (
            a : in std_logic_vector (15 downto 0); -- Eingang A
            b : in std_logic_vector (15 downto 0); -- Eingang B
            sel : in std_logic_vector (2 downto 0); -- Operation
            y : out std_logic_vector (15 downto 0); -- Ausgang
            zero: out std_logic -- gesetzt, falls Eingang B = 0
        );
    end component;

    component ir is
        port (
            clk: in std_logic;
            load: in std_logic; -- Steuersignal
            ir_in: in std_logic_vector (15 downto 0); -- Dateneingang
            ir_out: out std_logic_vector (15 downto 0) -- Datenausgang
        );
    end component;

    component pc is
        port (
            clk: in std_logic;
            reset, inc, load: in std_logic; -- Steuersignale
            pc_in: in std_logic_vector (15 downto 0); -- Dateneingang
            pc_out: out std_logic_vector (15 downto 0) -- Ausgabe Zaehlerstand
        );
    end component;

    component regfile is
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

    -- Data from ALU
    signal b_zero : std_logic;
    signal alu_y : std_logic_vector(15 downto 0);

    -- Data from regfile
    signal regfile_in_data: std_logic_vector(15 downto 0);
    signal regfile_out0_data: std_logic_vector(15 downto 0);
    signal regfile_out1_data: std_logic_vector(15 downto 0);

    -- Data from ir
    signal ir_ir_out: std_logic_vector(15 downto 0);

    -- Data from pc
    signal pc_pc_out: std_logic_vector(15 downto 0);

    -- Data from controller
    signal c_pc_inc: std_logic;
    signal c_pc_load: std_logic;
    signal c_adr_pc_not_reg: std_logic;
    signal c_ir_load: std_logic;
    signal c_reg_ldi: std_logic;
    signal c_reg_ldmem: std_logic;
    signal c_ld_low: std_logic;  -- c_regfile_load_lo in controller
    signal c_ld_high: std_logic;  -- c_regfile_load_hi in controller

    for I_CONTROLLER: CONTROLLER use entity WORK.CONTROLLER(RTL);
    for I_ALU: ALU use entity WORK.ALU(RTL);
    for I_IR: IR use entity WORK.IR(RTL);
    for I_PC: PC use entity WORK.PC(RTL);
    for I_REGFILE: REGFILE use entity WORK.PC(RTL);
begin
    I_CONTROLLER: CONTROLLER port map(
        clk => clk,
        reset => reset,
        ready => ready,
        zero => b_zero,
        c_mem_rd => rd,
        c_mem_wr => wr,
        ir => ir_ir_out, -- (15 downto 11)
        c_pc_inc => c_pc_inc,
        c_pc_load => c_pc_load,
        c_adr_pc_not_reg => c_adr_pc_not_reg,
        c_ir_load => c_ir_load,
        c_reg_ldi => c_reg_ldi,
        c_reg_ldmem => c_reg_ldmem,
        c_regfile_load_lo => c_ld_low,
        c_regfile_load_hi => c_ld_high
    );

    I_ALU: ALU port map(
        zero => b_zero,
        y => alu_y,
        a => regfile_out0_data,
        b => regfile_out1_data,
        sel => ir_ir_out(13 downto 11)
    );

    I_IR: IR port map(
        clk => clk,
        ir_in => rdata,
        ir_out => ir_ir_out,
        load => c_ir_load
    );

    I_PC: PC port map(
        clk => clk,
        reset => reset,
        pc_out => pc_pc_out,
        pc_in => regfile_out0_data,
        inc => c_pc_inc,
        load => c_pc_load
    );

    I_REGFILE: REGFILE port map(
        clk => clk,
        in_data => regfile_in_data,
        out0_data => regfile_out0_data,
        out1_data => regfile_out1_data,
        in_sel => ir_ir_out(10 downto 8),
        out0_sel => ir_ir_out(7 downto 5),
        out1_sel =>ir_ir_out(4   downto 2),
        load_lo => c_ld_low,
        load_hi => c_ld_high
    );

    process (c_reg_ldi, c_reg_ldmem, rdata)
    begin
        if (c_reg_ldi = '1') then
            regfile_in_data <= ir_ir_out(7 downto 0) & ir_ir_out(7 downto 0);
        elsif (c_reg_ldmem = '1') then
            regfile_in_data <= rdata;
        else
            regfile_in_data <= alu_y;
        end if;
    end process;

    process (c_adr_pc_not_reg, regfile_out0_data, pc_pc_out)
    begin
        if (c_adr_pc_not_reg = '1') then
            adr <= pc_pc_out;
        else
            adr <= regfile_out0_data;
        end if;
    end process;

    wdata <= regfile_out1_data;
end architecture;