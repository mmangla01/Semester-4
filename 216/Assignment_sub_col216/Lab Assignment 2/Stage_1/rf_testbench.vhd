-- test bench for the register file 
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
-- DUT component for register file
component RegisterFile is 
    port (rad1, rad2, wad: in std_logic_vector(3 downto 0);     -- read and write addresses
        data: in std_logic_vector(31 downto 0);                 -- data that is to be written 
        wen,clk: in std_logic;                                  -- write enable and clock
        dout1,dout2: out std_logic_vector(31 downto 0));        -- data that is being read 
end component;
-- internal signals used 
signal r1,r2,w: std_logic_vector(3 downto 0):= (others => '0');
signal d,d1,d2:std_logic_vector(31 downto 0);
signal we,clock: std_logic:='0';
-- begin architecture
begin 
    -- connect dut
    dut: RegisterFile port map(r1,r2,w,d,we,clock,d1,d2);
    process
    begin 
        clock <= '1';
        r1 <= "0000";
        r2 <= "1000";
        w <= "0000";
        d <= "00000000000000000000000000000000";
        we <= '1';
        -- write in memory 
        for a in 0 to 15 loop
            clock <= not clock;      
            wait for 5 ns;
            w <= w + 1;
            d <= d + 2;
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        we <= '0';
        -- read from memory
        for b in 0 to 7 loop
            clock <= not clock;
            wait for 5 ns;
            r1 <= r1 + 1;
            r2 <= r2 + 1;
            clock <= not clock;      -- rising edge of the clock
            wait for 5 ns;
        end loop;
        wait;
    end process;
end tb;
