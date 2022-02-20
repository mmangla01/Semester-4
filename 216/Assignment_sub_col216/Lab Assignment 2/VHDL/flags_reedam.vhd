library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;

entity Flag_setter is
    port (
        set: in std_logic;                  -- if the flags are to be set
        clock: in std_logic;                -- clock
        dp_class : in DP_subclass_type;     -- type of dp instruction
        is_shift: in std_logic;             -- if shift or not
        carry_from_alu: in std_logic;       -- the carry form alu
        carry_from_shift: in std_logic;     -- carry from shift
        msb1, msb2: std_logic;              -- msb of the operands
        result: in word;                    -- result from the ALU
        N_flag: out std_logic;               -- outputed value of flags
        Z_flag: out std_logic;               -- outputed value of flags
        C_flag: out std_logic;               -- outputed value of flags
        V_flag: out std_logic               -- outputed value of flags
    );
end Flag_setter;
architecture flag_arch of Flag_setter is
    signal C_local:std_logic:='0';
    signal V_local:std_logic:='0';
    signal N_local:std_logic:='0';
    signal Z_local:std_logic:='0';
begin
    process(clock)
    begin
        if(rising_edge(clock)) then 
            case(dp_class) is -- case switch for all 16 operations as told in slides.
                when arith =>
                    if set = '1' then
                    	if(result = X"00000000") then
                        	Z_local <= '1';
                        else
                        	Z_local <= '0';
                        end if;
                        N_local <= result(31);
                        C_local <= carry_from_alu;
                        V_local <= (result(31) and (not msb1) and (not msb2)) or (not(result(31)) and msb1 and msb2);
                    else

                    end if;
                when logic =>
                    if set = '1' then
                        if(result = X"00000000") then
                        	Z_local <= '1';
                        else
                        	Z_local <= '0';
                        end if;
                        N_local <= result(31);
                    else
                        
                    end if;
                when comp =>
                    if(result = X"00000000") then
                        	Z_local <= '1';
                        else
                        	Z_local <= '0';
                        end if;
                    N_local <= result(31);
                    C_local <= carry_from_alu;
                    V_local <= (result(31) and (not msb1) and (not msb2)) or (not(result(31)) and msb1 and msb2);
                when test =>
                    if set = '1' then
                    if(result = X"00000000") then
                        	Z_local <= '1';
                        else
                        	Z_local <= '0';
                        end if;
                    N_local <= result(31); 
                    else
                        
                    end if;
                when others =>
                    if set = '1' then
                        
                    else
                        
                    end if;
            end case;
        end if;
    end process;  
    C_flag <= C_local;
    N_flag <= N_local;
    V_flag <= V_local;
    Z_flag <= Z_local;  
end flag_arch;