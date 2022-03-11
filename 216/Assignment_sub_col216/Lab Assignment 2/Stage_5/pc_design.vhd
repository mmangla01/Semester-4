-- designing the Program Counter
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity ProgramCounter is 
    port (
        clock, reset: in std_logic;                  -- clock
        input_to_pc: in word;                       -- input pc
        output_from_pc: out word                    -- output pc
    );
end ProgramCounter;
-- implementing the Program Counter
architecture implement_pc of ProgramCounter is
begin 
    process(clock, reset)
    begin 
        if(rising_edge(clock)) then 
            if(reset='1') then          -- if reset then reset to 0
                output_from_pc <= X"00000000";
            else                        -- else output the input pc
                output_from_pc <= input_to_pc;
            end if;
        end if;
    end process;
end implement_pc;
                
