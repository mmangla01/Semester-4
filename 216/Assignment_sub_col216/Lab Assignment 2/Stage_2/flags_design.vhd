-- designing the flags and associated circuit 
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity flags is 
    port (
        set: in std_logic;                  -- if the flags are to be set
        clock: in std_logic;                -- clock
        dp_class : in DP_subclass_type;     -- type of dp instruction
        is_shift: in std_logic;             -- if shift or not
        carry_from_alu: in std_logic;       -- the carry form alu
        carry_from_shift: in std_logic;     -- carry from shift
        msb1, msb2: std_logic;              -- msb of the operands
        result: in word;                    -- result from the ALU
        N_flag: out std_logic;              -- outputed value of flags
        Z_flag: out std_logic;              -- outputed value of flags
        C_flag: out std_logic;              -- outputed value of flags
        V_flag: out std_logic               -- outputed value of flags
    );
end flags;
-- implementating the architecture of Flags
architecture implement_flags of flags is 
    -- N Z C V locally store the values of the flags 
    signal N_local, C_local,Z_local,V_local: std_logic:= '0';      
begin 
    process(clock)                          -- on the process of the clock 
    begin 
        if (rising_edge(clock)) then        -- on rising edge of the clock
            -- check for different instructions and set value and update the required flags 
            if ((set = '1' and dp_class = arith) or (dp_class = comp) ) then 
                if(result = X"00000000") then 
                    Z_local <= '1';
                else 
                    Z_local <= '0';
                end if;
                N_local <= result(31);
                C_local <= carry_from_alu;
                V_local <= (msb1 and msb2 and (not result(31))) or ((not msb1) and (not msb2) and result(31));
                
            else
                if (set = '1' and is_shift = '1') then
                    if(result = X"00000000") then 
                        Z_local <= '1';
                    else 
                        Z_local <= '0';
                    end if; 
                    N_local <= result(31);
                    C_local <= carry_from_shift;
                elsif ((set = '1' and is_shift = '0') or dp_class = test) then
                    N_local <= result(31);
                    if(result = X"00000000") then 
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

                

