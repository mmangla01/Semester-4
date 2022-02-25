-- designing the program memory 
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity ProgramMemory is 
    port(radd: in std_logic_vector(5 downto 0);             -- reading address 
        dout: out std_logic_vector(31 downto 0));           -- the data that is read
end ProgramMemory;
-- implementing the architecture of program memory 
architecture implement_pm of ProgramMemory is 
    type mem is array (0 to 63) of std_logic_vector(31 downto 0);
    -- mem is array of instruction in program memory
    signal memory: mem:= 
    ("00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000010","00000000000000000000000000000011","00000000000000000000000000000100","00000000000000000000000000000101","00000000000000000000000000000110","00000000000000000000000000000111",
    "00000000000000000000000000001000","00000000000000000000000000001001","00000000000000000000000000001010","00000000000000000000000000001011","00000000000000000000000000001100","00000000000000000000000000001101","00000000000000000000000000001110","00000000000000000000000000001111",
    "00000000000000000000000000010000","00000000000000000000000000010001","00000000000000000000000000010010","00000000000000000000000000010011","00000000000000000000000000010100","00000000000000000000000000010101","00000000000000000000000000010110","00000000000000000000000000010111",
    "00000000000000000000000000011000","00000000000000000000000000011001","00000000000000000000000000011010","00000000000000000000000000011011","00000000000000000000000000011100","00000000000000000000000000011101","00000000000000000000000000011110","00000000000000000000000000011111",
    "00000000000000000000000000100000","00000000000000000000000000100001","00000000000000000000000000100010","00000000000000000000000000100011","00000000000000000000000000100100","00000000000000000000000000100101","00000000000000000000000000100110","00000000000000000000000000100111",
    "00000000000000000000000000101000","00000000000000000000000000101001","00000000000000000000000000101010","00000000000000000000000000101011","00000000000000000000000000101100","00000000000000000000000000101101","00000000000000000000000000101110","00000000000000000000000000101111",
    "00000000000000000000000000110000","00000000000000000000000000111001","00000000000000000000000000111010","00000000000000000000000000111011","00000000000000000000000000111100","00000000000000000000000000111101","00000000000000000000000000111110","00000000000000000000000000111111",
    "00000000000000000000000001000000","00000000000000000000000001000001","00000000000000000000000001000010","00000000000000000000000001000011","00000000000000000000000001000100","00000000000000000000000001000101","00000000000000000000000001000110","00000000000000000000000001000111");                                     -- signal that is accessing the instruction array
begin
    process(radd)                                           -- process on read address
    begin
        dout <= memory(conv_integer(radd));                 -- getting the data at the given address
    end process;
end implement_pm;