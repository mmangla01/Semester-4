
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

entity ProgramMemory is 
    port(radd: in std_logic_vector(5 downto 0);
        clk:in std_logic;
        dout: out std_logic_vector(31 downto 0));
end ProgramMemory;

architecture implement_pm of ProgramMemory is 
    type mem is array (63 downto 0) of std_logic_vector(31 downto 0);
    signal memory: mem;
    signal addressread: integer range 0 to 63;
begin
    process(clk,radd)
    begin  
        addressread <= conv_integer(radd);
        dout <= memory(addressread);
    end process;
end implement_pm;
            