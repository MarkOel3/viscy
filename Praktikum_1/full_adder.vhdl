library IEEE;
use IEEE.std_logic_1164.all;

entity FULL_ADDER is
    port (a, b, c: in std_logic; sum, carry: out std_logic);
end FULL_ADDER;

architecture BEHAVIOUR of FULL_ADDER is
begin
    process (a, b, c)
    begin
        sum <= a xor b xor c;
        carry <= (a and b) or (a and c) or (b and c);
    end process;
end architecture;

architecture STRUCTURE of FULL_ADDER is
    component XOR2 is
        port (x, y: in std_logic; z: out std_logic);
    end component;

    component OR2 is
        port (x, y: in std_logic; z: out std_logic);
    end component;

    component AND2 is
        port (x, y: in std_logic; z: out std_logic);
    end component;

    signal b_xor_c, b_and_c, a_and_bc: std_logic;

    for I_B_XOR_C, I_SUM: XOR2 use entity WORK.XOR2(TIMED_DATAFLOW);
    for I_CARRY: OR2 use entity WORK.OR2(TIMED_DATAFLOW);
    for I_B_AND_C, I_A_AND_BC: AND2 use entity WORK.AND2(TIMED_DATAFLOW); 
begin
    I_B_XOR_C: XOR2 port map (x => b, y => c, z => b_xor_c);
    I_B_AND_C: AND2 port map (x => b, y => c, z => b_and_c);
    I_SUM: XOR2 port map (x => a, y => b_xor_c, z => sum);
    I_A_AND_BC: AND2 port map (x => a, y => b_xor_c, z => a_and_bc);
    I_CARRY: OR2 port map (x => a_and_bc, y => b_and_c, z => carry);
end architecture;