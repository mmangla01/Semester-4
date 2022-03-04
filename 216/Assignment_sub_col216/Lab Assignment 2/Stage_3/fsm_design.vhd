-- designing the Finite State Machine
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity FiniteStateMachine is
    port(
        clock, branch_cond: in std_logic;               -- clock and the boolean for condition being true
        decoded_dpos: in DP_operand_src_type;           -- source of the operand in DP instruction
        decoded_insc: in instr_class_type;              -- instruction class
        decoded_opc: in optype;                         -- the operation code in case of DP
        decoded_dtos: in DT_offset_sign_type;           -- the sign of offset in DT instruction
        decoded_load_store: in load_store_type;         -- load or store
        -- control signals 
        PW, IorD, MW, IW, DW, M2R, Rsrc, BW, RW, AW, Asrc1, F_set, ReW: out std_logic;
        Asrc2: out std_logic_vector(1 downto 0);
        alu_opc: out optype                             -- the operation that is to be performed by ALU
    );
end FiniteStateMachine;
-- implementing the architecture of FSM
architecture implement_fsm of FiniteStateMachine is 
    signal next_state: nibble:= (others => '0');        -- internal signal used for storing the next state
begin 
    process(clock)                                      -- process of clock
    begin 
        -- we update the control signals according to the state
        if(rising_edge(clock)) then                     -- on rising edge 
            if(next_state="0000") then          -- if on state 0 then
                next_state <= "0001";-- next state
                PW <= '1';          -- write PC+4 in PC
                IW <= '1';          -- write in instruction register
                alu_opc <= add;     -- add operation in ALU
                Asrc1 <= '0';       -- PC as operand 1
                Asrc2 <= "01";      --  4 as operand 2
                -- else 0
                MW <= '0';
                DW <= '0';
                BW <= '0';
                RW <= '0';
                AW <= '0';
                M2R <= '0';
                ReW <= '0';
                IorD <= '0';
                Rsrc <= '0';
                F_set <= '0';
            elsif(next_state="0001") then          -- if on state 1 then
                -- check for the type of instruction 
                if(decoded_insc=DP) then    -- if DP then the next state is 2
                    next_state <= "0010";
                    Rsrc <= '0';
                elsif(decoded_insc=DT) then    -- if DT then the next state is 3 also the Rsrc is 1
                    next_state <= "0011";
                    Rsrc <= '1';
                else    -- if BRN then the next state is 4 also the Rsrc is 1
                    next_state <= "0100";
                    Rsrc <= '1';
                end if;
                AW <= '1';      -- write in A
                BW <= '1';      -- write in B
                -- else 0
                PW <= '0';          
                IW <= '0';
                MW <= '0';
                DW <= '0';
                RW <= '0';
                M2R <= '0';
                ReW <= '0';
                IorD <= '0';
                F_set <= '0';
                Asrc1 <= '0';
                Asrc2 <= "00";
            elsif(next_state="0010") then          -- if on state 2 then
                next_state <= "0101"; -- next state 
                Asrc1 <= '1';   -- A as operand 1
                F_set <= '1';
                ReW <= '1';     -- write in RES 
                if(decoded_dpos = reg) then -- check for the source of the operand 2
                    Asrc2 <= "00";
                else
                    Asrc2 <= "10";
                end if;
                -- in this case the alu operation is same that is decoded from the instruction
                alu_opc <= decoded_opc; 
                -- else 0
                PW <= '0';
                IW <= '0';
                MW <= '0';
                DW <= '0';
                BW <= '0';
                RW <= '0';
                AW <= '0';
                M2R <= '0';
                IorD <= '0';
                Rsrc <= '0';
            elsif(next_state="0011") then          -- if on state 3 then
                Rsrc <= '1';        -- read address 2 in register file
                Asrc1 <= '1';       -- A as operand 1
                ReW <= '1';     -- write in RES 
                Asrc2 <= "10";      -- second operand as the offset in instruction
                if(decoded_dtos = minus) then   -- check the sign for offset
                    alu_opc <= sub;
                else
                    alu_opc <= add;
                end if;
                if(decoded_load_store=load) then -- check load store for next state
                    next_state <= "0111";
                else
                    next_state <= "0110";
                end if;
                -- else 0
                PW <= '0';
                IorD <= '0';
                MW <= '0';
                IW <= '0';
                DW <= '0';
                M2R <= '0';
                BW <= '0';
                RW <= '0';
                AW <= '0';
                F_set <= '0';
            elsif(next_state="0100") then          -- if on state 4 then
                next_state <= "0000";   -- next state 
                if(branch_cond='1') then -- if the branch condition is true then 
                    PW <= '1';              -- we write in PC else don't
                else 
                    PW <= '0';
                end if;
                alu_opc <= adc;         -- add with carry is to be performed 
                Asrc2 <= "11";      -- second operand is offset
                Rsrc <= '1';        -- read address 2 in register file
                -- else 0
                IorD <= '0';
                MW <= '0';
                IW <= '0';
                DW <= '0';
                M2R <= '0';
                BW <= '0';
                RW <= '0';
                AW <= '0';
                Asrc1 <= '0';
                F_set <= '0';
                ReW <= '0';
            elsif(next_state="0101")then          -- if on state 5 then
                next_state <= "0000";       -- next state    
                RW <= '1';               -- write the output to the register
                -- else 0
                PW <= '0';
                IorD <= '0';
                MW <= '0';
                IW <= '0';
                DW <= '0';
                M2R <= '0';
                Rsrc <= '0';
                BW <= '0';
                AW <= '0';
                Asrc1 <= '0';
                F_set <= '0';
                ReW <= '0';
                Asrc2 <= "00";
            elsif(next_state="0110") then          -- if on state 0 then
                next_state <= "0000";   -- next state
                IorD <= '1';    -- input the data memory address 
                MW <= '1';      -- write in mem
                Rsrc <= '1';    -- read address 2 in register file
                -- else 0
                PW <= '0';
                IW <= '0';
                DW <= '0';
                M2R <= '0';
                BW <= '0';
                RW <= '0';
                AW <= '0';
                Asrc1 <= '0';
                F_set <= '0';
                ReW <= '0';
                Asrc2 <= "00";
            elsif(next_state="0111") then          -- if on state 0 then
                next_state <= "1000";   -- next state
                IorD <= '1';    -- input the data memory address 
                Rsrc <= '1';    -- read address 2 in register file
                DW <= '1';      -- write in data register
                PW <= '0';
                MW <= '0';
                IW <= '0';
                M2R <= '0';
                BW <= '0';
                RW <= '0';
                AW <= '0';
                Asrc1 <= '0';
                F_set <= '0';
                ReW <= '0';
                Asrc2 <= "00";
            elsif (next_state="1000") then          -- if on state 0 then 
                next_state <= "0000";   -- next state
                M2R <= '1';     -- the MUX m2r
                Rsrc <= '1';    -- read address 2 in register file
                RW <= '1';      -- write in register file
                -- else 0
                PW <= '0';
                IorD <= '0';
                MW <= '0';
                IW <= '0';
                DW <= '0';
                BW <= '0';
                AW <= '0';
                Asrc1 <= '0';
                F_set <= '0';
                ReW <= '0';
                Asrc2 <= "00";
            end if;
        end if;
    end process;
end implement_fsm;