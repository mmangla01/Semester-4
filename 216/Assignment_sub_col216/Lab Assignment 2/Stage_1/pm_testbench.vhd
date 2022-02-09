-- test bench for the program memory
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
-- DUT component for program memory
component ProgramMemory is 
    port(radd: in std_logic_vector(5 downto 0);             -- reading address 
        dout: out std_logic_vector(31 downto 0));           -- the data that is to read
end component;
-- internal signals used 
signal readaddress: std_logic_vector(5 downto 0):= (others => '0');
signal data: std_logic_vector(31 downto 0);
-- begin architecture
begin 
    -- connect dut
    dut: ProgramMemory port map(readaddress,data);
    process
    begin 
        -- reading the data initialized
        readaddress <= "000000";
        for a in 0 to 63 loop
            wait for 10 ns;
            readaddress <= readaddress + "000001";
        end loop;
        wait;
    end process;
end tb;


