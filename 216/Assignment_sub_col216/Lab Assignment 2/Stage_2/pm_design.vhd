-- designing the program memory 
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity ProgramMemory is 
    port(
        radd: in std_logic_vector(5 downto 0);             -- reading address 
        dout: out word           -- the data that is read
    );
end ProgramMemory;
-- implementing the architecture of program memory 
architecture implement_pm of ProgramMemory is 
    type mem is array (0 to 63) of word;
    -- mem is array of instruction in program memory
    signal memory: mem:= (
        0 => X"E3A00000",
        1 => X"E3A01000",
        2 => X"E0800001",
        3 => X"E2811001",
        4 => X"E3510005",
        5 => X"1AFFFFFB",
        others => X"00000000"
    );                                    -- signal that is accessing the instruction array
begin
    process(radd)                                           -- process on read address
    begin
        dout <= memory(to_integer(unsigned(radd))); -- getting the data at the given address
    end process;
end implement_pm;
