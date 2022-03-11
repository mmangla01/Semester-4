-- designing the flags and associated circuit 
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity flags is 
    port (
        clock, set_flags, alu_operand_1, alu_operand_2, is_shift: in std_logic;
        carry_from_alu, carry_from_shift, F_set: in std_logic;
        alu_result: in word;                    -- result from the ALU
        dp_class: in DP_subclass_type;     -- type of dp instruction
        N_flag, Z_flag, C_flag, V_flag: out std_logic-- outputed value of flags
    );
end flags;
-- implementating the architecture of Flags
architecture implement_flags of flags is 
    -- N Z C V locally store the values of the flags 
    signal N_local, C_local, Z_local, V_local: std_logic:= '0';      
begin 
    process(clock)                          -- on the process of the clock 
    begin 
        if (rising_edge(clock) and (F_set = '1')) then        -- on rising edge of the clock and F_set is 1
            -- check for different instructions and set value and update the required flags 
            if ((set_flags = '1' and dp_class = arith) or (dp_class = comp) ) then 
                if(alu_result = X"00000000") then 
                    Z_local <= '1';
                else 
                    Z_local <= '0';
                end if;
                N_local <= alu_result(31);
                C_local <= carry_from_alu;
                V_local <= (alu_operand_1 and alu_operand_2 and (not alu_result(31))) or ((not alu_operand_1) and (not alu_operand_2) and alu_result(31));
                
            else
                if (set_flags = '1' and is_shift = '1') then
                    if(alu_result = X"00000000") then 
                        Z_local <= '1';
                    else 
                        Z_local <= '0';
                    end if; 
                    N_local <= alu_result(31);
                    C_local <= carry_from_shift;
                elsif ((set_flags = '1' and is_shift = '0') or dp_class = test) then
                    N_local <= alu_result(31);
                    if(alu_result = X"00000000") then 
                        Z_local <= '1';
                    else 
                        Z_local <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;                            -- end the process
    -- assigning the new values to the output flags
    N_flag <= N_local; 
    C_flag <= C_local;
    V_flag <= V_local;
    Z_flag <= Z_local;
end implement_flags;                        -- end the implementation

                

