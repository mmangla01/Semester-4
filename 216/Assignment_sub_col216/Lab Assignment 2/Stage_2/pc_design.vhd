-- designing the Program Counter
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity ProgramCounter is 
    port (
        clock: in std_logic;                        -- clock
        -- the offset relative to pc in case of branch instruction to be implemented
        offset: in std_logic_vector(23 downto 0);   
        branch: in std_logic;                       -- whether to branch or not
        rst: in std_logic;                          -- to reset the program to 0
        out_pc: out word                            -- output pc
    );
end ProgramCounter;
-- implementing the Program Counter
architecture implement_pc of ProgramCounter is 
    signal pc: word:= X"00000000";              -- locally storing the value of pc
begin 
    process(clock, rst)
    begin 
        if(rising_edge(clock)) then 
            if(rst='1') then 
                out_pc <= X"00000000";
                pc <= X"00000000";
            elsif(branch='1') then                  -- if we need to branch 
                if(offset(23) = '0') then 
                    out_pc <= std_logic_vector(signed(pc) + signed("000000"&offset&"00") + 8);-- then new pc
                    pc <= std_logic_vector(signed(pc) + signed("000000"&offset&"00") + 8);
                else 
                    out_pc <= std_logic_vector(signed(pc) + signed("111111"&offset&"00") + 8);-- then new pc
                    pc <= std_logic_vector(signed(pc) + signed("111111"&offset&"00") + 8);
                end if;
            else 
                out_pc <= std_logic_vector(4 + signed(pc)); -- if no branch instruction then increment of 4
                pc <= std_logic_vector(signed(pc) + 4);
            end if;
        end if;
    end process;
end implement_pc;
                
