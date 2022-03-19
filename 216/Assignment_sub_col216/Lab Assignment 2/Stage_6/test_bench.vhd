-- designing the test bench
library IEEE;
use work.myTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity processor_tb is 
    -- empty
end processor_tb;
-- implementing the architecture of the test_bench
architecture implement_tb of processor_tb is
    component GlueCode is 
        port(
            clock, reset: in std_logic
        );
    end component;
    signal clk,rst: std_logic:='0';
begin
    gc: GlueCode port map(clk, rst);
    process
    begin
        wait for 1 ns;  -- starting 
        clk <= '1';     -- initialize the clock
        rst<= '1';      -- and reset the pc
        wait for 10 ns;
        rst<= '0';      -- turn off the reset
        for i in 0 to 1000 loop  -- loop till all the instructions are over 
            clk <= not clk; -- in each loop reverse the clock
            wait for 10 ns; -- after 10 ns
        end loop;
        wait;
    end process;
end implement_tb;
