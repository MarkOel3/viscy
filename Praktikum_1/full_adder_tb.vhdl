library IEEE;
use IEEE.std_logic_1164.all;

entity FULL_ADDER_TB is
end FULL_ADDER_TB;

architecture TESTBENCH2 of FULL_ADDER_TB is
  -- Component declaration...
  component FULL_ADDER is
    port (a, b, c: in std_logic; sum, carry: out std_logic);
  end component;

  -- Configuration...
  for SPEC: FULL_ADDER use entity WORK.FULL_ADDER(BEHAVIOUR);
  for IMPL: FULL_ADDER use entity WORK.FULL_ADDER(STRUCTURE);

  -- Internal signals...
  signal a, b, c, sum_spec, carry_spec, sum_impl, carry_impl: std_logic;
  
    procedure run_wait is
    begin
        wait for 8 ns;    
    end procedure;

begin
  -- Instantiate half adder...
  SPEC: FULL_ADDER port map (a => a, b => b, c => c, sum => sum_spec, carry => carry_spec);
  IMPL: FULL_ADDER port map (a => a, b => b, c => c, sum => sum_impl, carry => carry_impl);

  -- Main process...
  process
  begin

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '0'; b <= '0'; c <= '0';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=0, c=0)";

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '0'; b <= '0'; c <= '1';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=0, c=1)";

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '0'; b <= '1'; c <= '0';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=1, c=0)";

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '0'; b <= '1'; c <= '1';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=1, c=1)";

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '1'; b <= '0'; c <= '0';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=0, c=0)";

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '1'; b <= '0'; c <= '1';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=0, c=1)";

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '1'; b <= '1'; c <= '0';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=1, c=0)";

    a <= 'X'; b <= 'X'; c <= 'X';
    run_wait;
    a <= '1'; b <= '1'; c <= '1';
    run_wait;
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=1, c=1)";

    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation
  end process;
end architecture;