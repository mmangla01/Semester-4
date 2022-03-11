-- designing Register File
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity declaration
entity RegisterFile is 
    port (
        clock, reg_write_enable: in std_logic;          -- write enable and clock
        read_reg_1, read_reg_2, write_reg: in nibble;     -- read and write addresses
        write_data_inreg: in word;                  -- data that is to be written 
        data_outreg_1, data_outreg_2: out word           -- data that is being read 
    );
end RegisterFile;
-- achitecture implementing the register file
architecture implement_rf of RegisterFile is
    type mem is array (0 to 15) of word;      
    -- defining a type that is array of 16 std_logic_vector (32 bits)
    signal memory: mem:=(others => (others => '0'));    -- internal signal that is of mem type 
begin
    data_outreg_1 <= memory(to_integer(unsigned(read_reg_1)));        -- reading the register and outputing the same 
    data_outreg_2 <= memory(to_integer(unsigned(read_reg_2)));        -- without any intervention of clock
    process(clock)                                        -- process when clock or writing is triggered
    begin
        if (rising_edge(clock)) then                      -- at rising edge of the clock 
            if (reg_write_enable = '1') then                           -- and write enable set
                memory(to_integer(unsigned(write_reg))) <= write_data_inreg;-- write the data to the register address
            end if;
        end if;
    end process;                                        -- end process
end implement_rf;                                       -- end implementation
