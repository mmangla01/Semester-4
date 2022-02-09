-- test bench for the data memory
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
-- DUT component for data memory 
component DataMemory is 
    port(radd,wadd: in std_logic_vector(5 downto 0);        -- read and write addresses
        clk:in std_logic;                                   -- clock 
        data: in std_logic_vector(31 downto 0);             -- input data
        dout: out std_logic_vector(31 downto 0);            -- output data 
        wen: in std_logic_vector(3 downto 0));              -- write enable
end component;
-- internal signals used 
signal readaddress, writeaddress: std_logic_vector(5 downto 0):= (others => '0');
signal data_in, data_out: std_logic_vector(31 downto 0);
signal clock: std_logic:='0';
signal wenable: std_logic_vector(3 downto 0);
-- begin architecture
begin 
    -- connect dut
    dut: DataMemory port map(readaddress,writeaddress,clock,data_in,data_out,wenable);
    process
    begin 
        clock <= '1';
        readaddress <= "000000";
        writeaddress <= "000000";
        data_in <= "00000000000000000000000000000000";
        wenable <= "0001";
        -- write a byte in memory in left most byte
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            writeaddress <= writeaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wenable <= "0010";
        writeaddress <= "000000";
        -- write a byte in memory in second least significant byte
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            writeaddress <= writeaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wenable <= "0100";
        writeaddress <= "000000";
        -- write a byte in memory in second most significant byte
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            writeaddress <= writeaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wenable <= "1000";
        writeaddress <= "000000";
        -- write a byte in memory in most significant byte
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            writeaddress <= writeaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wenable <= "0011";
        -- write a byte in memory in half word (least significant)
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            writeaddress <= writeaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wenable <= "1100";
        writeaddress <= "010000";
        -- write a byte in memory in half word (most significant)
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            writeaddress <= writeaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wenable <= "1111";
        -- write a byte in memory in word
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            writeaddress <= writeaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wenable <= "0000";
        -- reading the data written in all cases above
        for a in 0 to 48 loop
            clock <= not clock;      
            wait for 5 ns;
            readaddress <= readaddress + "000001";
            data_in <= data_in + "00000000000000000000000000000010";
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wait;
    end process;
end tb;
