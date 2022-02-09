-- test bench for the alu 
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- testbench entity
entity testbench is
-- empty
end testbench;
-- testbench architecture
architecture tb of testbench is
-- DUT component
component ALU is
    port (op1,op2: in std_logic_vector(31 downto 0);    -- 2 operands 
          opc:in std_logic_vector(3 downto 0);          -- operation code
          cin: in std_logic;                            -- carry in
          cout: out std_logic;                          -- carry out 
          result: out std_logic_vector(31 downto 0));   -- final output
end component;
-- internal signals used 
signal a_in, b_in, d_out: std_logic_vector(31 downto 0):= (others => '0');
signal c1_in,c2_out: std_logic;
signal opc_in: std_logic_vector(3 downto 0):= (others => '0');
-- begin architecture 
begin
  -- Connect DUT
  dut : ALU port map(a_in, b_in, opc_in, c1_in, c2_out, d_out);
  process
    variable v: std_logic_vector(3 downto 0);
  begin
    -- input 1
    a_in <= "00000000000000000000000000001110";
    b_in <= "00000000000000000000000000000111";
    c1_in <= '1';
    opc_in <= "1111";
    -- loop checking for all opcodes
    for I in 0 to 15 loop 
        v := opc_in;
        opc_in <= v + "0001";
        wait for 10 ns;
    end loop;
    wait for 10 ns;
    -- input 2
    a_in <= "11111111111111111111111111111111";
    b_in <= "00000000000000000000000000000000";
    c1_in <= '1';
    opc_in <= "1111";
    -- loop checking for all opcodes
    for I in 0 to 15 loop
        v := opc_in; 
        opc_in <= v + "0001";
        wait for 10 ns;
    end loop;
    wait for 10 ns;
    -- input 3 
    a_in <= "10101010101010101010101010101010";
    b_in <= "11111111111111110000000000000000";
    c1_in <= '1';
    opc_in <= "1111";
    -- loop checking for all opcodes
    for I in 0 to 15 loop
        v := opc_in; 
        opc_in <= v + "0001";
        wait for 10 ns;
    end loop;
    wait for 10 ns;
    wait;
  end process;
end tb;
