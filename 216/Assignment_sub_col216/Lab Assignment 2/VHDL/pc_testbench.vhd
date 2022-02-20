-- test bench for the alu 
library IEEE;
use work.MyTypes.all;
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
component ProgramCounter is
    port (
        clock: in std_logic;                        -- clock
        offset: in std_logic_vector(23 downto 0);   -- the offset relative to pc in case of branch instruction to be implemented
        offset_sign: in DT_offset_sign_type;        -- offset to be added or subtracted 
        out_pc: out word;                           -- output pc
        branch: in std_logic                        -- wether to branch or not
    );
end component;
-- internal signals used 
signal outpc: word:= (others => '0');
signal clk,b: std_logic;
signal off: std_logic_vector(23 downto 0):= (others => '0');
signal offsgn: DT_offset_sign_type;
-- begin architecture 
begin
  -- Connect DUT
  dut : ProgramCounter port map(clk, off, offsgn, outpc, b);
  process
    variable v: std_logic_vector(3 downto 0);
  begin
    -- input 1
    -- a_in <= "00000000000000000000000000001110";
    -- b_in <= "00000000000000000000000000000111";
    -- c1_in <= '1';
    -- opc_in <= "1111";
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
