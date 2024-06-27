library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_TB is
end ALU_TB;

architecture RTL of ALU_TB is
    component ALU is 
        port (
            a : in std_logic_vector (15 downto 0); -- Eingang A
            b : in std_logic_vector (15 downto 0); -- Eingang B
            sel : in std_logic_vector (2 downto 0); -- Operation
            y : out std_logic_vector (15 downto 0); -- Ausgang
            zero: out std_logic -- gesetzt, falls Eingang B = 0
        );
    end component;

    signal a, b, y: std_logic_vector(15 downto 0);
    signal sel: std_logic_vector(2 downto 0);
    signal zero: std_logic;
    for I_ALU: ALU use entity WORK.ALU(RTL);
    begin
        I_ALU: ALU port map(a => a, b => b, sel => sel, y => y, zero => zero);
        process
        begin
          a <= "0000000000000000"; b <= "0000000000000000"; sel <= "000"; 
          wait for 1 ns;
          for i in 1 to 10 loop
            a <= std_logic_vector(unsigned(a) + 5);
            wait for 1 ns;      -- wait a bit
            assert y = a and zero = '1'
                report "Specification and implementation differ! (a <= i; b <= 0000000000000000; sel <= 000;)";
          end loop;

          a <= "0000000000000000"; b <= "0000000000000000"; sel <= "000"; 
          wait for 1 ns;
          for i in 1 to 10 loop
            b <= std_logic_vector(unsigned(b) + 5);
            wait for 1 ns;      -- wait a bit
            assert y = b and zero = '0'
                report "Specification and implementation differ! (a <= 0000000000000000; b <= i; sel <= 000;)";
          end loop;

          a <= "1001000100110011"; b <= "0000000000000000"; sel <= "001"; 
          wait for 1 ns;
          for i in 1 to 10 loop
            b <= std_logic_vector(unsigned(b) + 5);
            wait for 1 ns;      -- wait a bit
            assert y = std_logic_vector(unsigned(a) - unsigned(b))
                report "Specification and implementation differ! (sel <= 001;)";
          end loop;

          a <= "1001000100110011"; b <= "0000000000000000"; sel <= "010"; 
          wait for 1 ns;
          for i in 1 to 16 loop
            a <= (a(14 downto 0) & '0');
            wait for 1 ns;      -- wait a bit
            assert y = (a(14 downto 0) & '0')
                report "Specification and implementation differ! (sel <= 010;)";
            wait for 1 ns;      -- wait a bit
          end loop;

          a <= "1001000100110011"; b <= "0000000000000000"; sel <= "011"; 
          wait for 1 ns;
          for i in 1 to 16 loop
            a <= (a(15) & a(15 downto 1));
            wait for 1 ns;      -- wait a bit
            assert y = (a(15) & a(15 downto 1))
                report "Specification and implementation differ! (sel <= 011;)";
            wait for 1 ns;      -- wait a bit
          end loop;

          a <= "1001000100110011"; b <= "0000000000000000"; sel <= "100"; 
          wait for 1 ns;
          for i in 1 to 16 loop
            a <= std_logic_vector(unsigned(a) + 111 * i);
            b <= std_logic_vector(unsigned(b) - 432 * i);
            wait for 1 ns;      -- wait a bit
            assert y = (a and b)
                report "Specification and implementation differ! (sel <= 100;)";
            wait for 1 ns;      -- wait a bit
          end loop;

          a <= "1001000100110011"; b <= "0000000000000000"; sel <= "101"; 
          wait for 1 ns;
          for i in 1 to 16 loop
            a <= std_logic_vector(unsigned(a) + 111 * i);
            b <= std_logic_vector(unsigned(b) - 432 * i);
            wait for 1 ns;      -- wait a bit
            assert y = (a or b)
                report "Specification and implementation differ! (sel <= 101;)";
            wait for 1 ns;      -- wait a bit
          end loop;

          a <= "1001000100110011"; b <= "0000000000000000"; sel <= "110"; 
          wait for 1 ns;
          for i in 1 to 16 loop
            a <= std_logic_vector(unsigned(a) + 111 * i);
            b <= std_logic_vector(unsigned(b) - 432 * i);
            wait for 1 ns;      -- wait a bit
            assert y = (a xor b)
                report "Specification and implementation differ! (sel <= 110;)";
            wait for 1 ns;      -- wait a bit
          end loop;


          a <= "1001000100110011"; b <= "0000000000000000"; sel <= "111"; 
          wait for 1 ns;
          for i in 1 to 16 loop
            a <= std_logic_vector(unsigned(a) + 111 * i);
            wait for 1 ns;      -- wait a bit
            assert y = not a
                report "Specification and implementation differ! (sel <= 111;)";
            wait for 1 ns;      -- wait a bit
          end loop;

          -- Print a note & finish simulation now
          assert false report "Simulation finished" severity note;
          wait;               -- end simulation
        end process;
end architecture;