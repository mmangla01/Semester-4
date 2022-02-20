-- designing the condition checker
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity ConditionChecker is 
    port (
        N_flag: in STD_LOGIC;               -- flags
        Z_flag: in STD_LOGIC;
        C_flag: in STD_LOGIC;
        V_flag: in STD_LOGIC;
        cond: in nibble;        -- input condition that is to be checked
        is_true: out std_logic              -- if the condition is true 
    );
end ConditionChecker;
-- implementing the architcture of condition checker
architecture implement_cc of ConditionChecker is
begin
    process(cond)         -- process on the change of flags or cond
    begin 
        if(-- check for the condition value and the corresponding flags
            (cond="0000" and Z_flag='1') or     -- eq
            (cond="0001" and Z_flag='0') or     -- ne
            (cond="0010" and C_flag='1') or     -- hs/cs
            (cond="0011" and C_flag='0') or     -- lo/cc
            (cond="0100" and N_flag='1') or     -- mi
            (cond="0101" and N_flag='0') or     -- pl
            (cond="0110" and V_flag='1') or     -- vs
            (cond="0111" and V_flag='0') or     -- vc
            (cond="1000" and Z_flag='0' and C_flag='1') or  -- hi
            (cond="1001" and Z_flag='1' and C_flag='0') or  -- ls
            (cond="1010" and N_flag=V_flag) or  -- ge
            (cond="1011" and not(N_flag=V_flag)) or         -- lt
            (cond="1100" and Z_flag='0' and N_flag=V_flag) or -- gt
            (cond="1101" and Z_flag='1' and not(N_flag=V_flag)) or -- le
            (cond="1110")                      -- all flags ignored (al)
        ) then                  -- if they match then true is returned
            is_true <= '1';
        else                                -- else false is returned 
            is_true <= '0';
        end if;
    end process;
end implement_cc;