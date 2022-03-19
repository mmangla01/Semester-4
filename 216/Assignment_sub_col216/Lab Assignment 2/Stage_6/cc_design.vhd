-- designing the condition checker
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity ConditionChecker is 
    port (
        N_flag, Z_flag, C_flag, V_flag: in STD_LOGIC;               -- flags
        condition: in nibble;        -- input condition that is to be checked
        is_cond_true: out std_logic              -- if the condition is true 
    );
end ConditionChecker;
-- implementing the architcture of condition checker
architecture implement_cc of ConditionChecker is
begin
    process(condition)         -- process on the change of condition
    begin 
        if(-- check for the condition value and the corresponding flags
            (condition="0000" and Z_flag='1') or     -- eq
            (condition="0001" and Z_flag='0') or     -- ne
            (condition="0010" and C_flag='1') or     -- hs/cs
            (condition="0011" and C_flag='0') or     -- lo/cc
            (condition="0100" and N_flag='1') or     -- mi
            (condition="0101" and N_flag='0') or     -- pl
            (condition="0110" and V_flag='1') or     -- vs
            (condition="0111" and V_flag='0') or     -- vc
            (condition="1000" and Z_flag='0' and C_flag='1') or  -- hi
            (condition="1001" and Z_flag='1' and C_flag='0') or  -- ls
            (condition="1010" and N_flag=V_flag) or  -- ge
            (condition="1011" and not(N_flag=V_flag)) or         -- lt
            (condition="1100" and Z_flag='0' and N_flag=V_flag) or -- gt
            (condition="1101" and Z_flag='1' and not(N_flag=V_flag)) or -- le
            (condition="1110")                      -- all flags ignored (al)
        ) then                  -- if they match then true is returned
            is_cond_true <= '1';
        else                                -- else false is returned 
            is_cond_true <= '0';
        end if;
    end process;
end implement_cc;