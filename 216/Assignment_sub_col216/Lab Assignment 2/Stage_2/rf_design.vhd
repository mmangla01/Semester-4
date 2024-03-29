-- designing Register File
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity declaration
entity RegisterFile is 
    port (
        rad1, rad2, wad: in nibble;     -- read and write addresses
        data: in word;                  -- data that is to be written 
        wen,clk: in std_logic;          -- write enable and clock
        dout1,dout2: out word           -- data that is being read 
    );
end RegisterFile;
-- achitecture implementing the register file
architecture implement_rf of RegisterFile is
    type mem is array (0 to 15) of word;      
    -- defining a type that is array of 16 std_logic_vector (32 bits)
    signal memory: mem:=(others => (others => '0'));    -- internal signal that is of mem type 
begin
    dout1 <= memory(to_integer(unsigned(rad1)));        -- reading the register and outputing the same 
    dout2 <= memory(to_integer(unsigned(rad2)));        -- without any intervention of clock
    process(clk)                                        -- process when clock or writing is triggered
    begin
        if (rising_edge(clk)) then                      -- at rising edge of the clock 
            if wen = '1' then                           -- and write enable set
                memory(to_integer(unsigned(wad))) <= data;-- write the data to the register address
            end if;
        end if;
    end process;                                        -- end process
end implement_rf;                                       -- end implementation
