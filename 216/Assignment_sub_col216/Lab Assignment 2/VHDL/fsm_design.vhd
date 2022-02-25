
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FiniteStateMachine is
    port(
        clock: std_logic;
        instruction_data, value_of_r1, value_of_r2, result_from_alu: in word;
        decoded_insc: in instr_class_type;
        decoded_load_store: in load_store_type;
        state: out nibble;
        A, B, IR, DR, RES: out word
    );
end FiniteStateMachine;

architecture implement_fsm of FiniteStateMachine is 
    signal A_local, B_local, IR_local, DR_local, RES_local: word := (others =>'0');
    signal local_state: nibble:= (others => '0');
begin 
    process(clock)
    begin 
        if(local_state="0000") then
            local_state <= "0001";
            state <= "0001";
            IR <= IR_local ;
            A_local <= value_of_r1;
            B_local <= value_of_r2;            
        elsif(local_state="0001") then
            A <= A_local;
            B <= B_local;
            RES_local <= result_from_alu;
            if(decoded_insc=DP) then
                local_state = "0010";
                state <= "0010";
            elsif(decoded_insc=DT) then
                local_state = "0011";
                state <= "0011";
            else
                local_state = "0100";
                state <= "0100";
                RES <= result_from_alu;
            end if;
        elsif(local_state="0010") then
            local_state = "0101";
            state <= "0101";
            RES <= RES_local;
            IR_local <= instruction_data;
        elsif(local_state="0011") then
            RES <= RES_local;
            if(decoded_load_store=load) then 
                local_state = "0111";
                state <= "0111";
            else
                local_state = "0110";
                state <= "0110";
                RES_local <= result_from_alu;
                B_local <= value_of_r2;
            end if;
        elsif(local_state="0100") then
            local_state <= "0000";
            state <= "0000";
            IR_local <= instruction_data;
        elsif(local_state="0101")then
            local_state <= "0000";
            state <= "0000";
            IR <= IR_local;
            IR_local <= instruction_data;
        elsif(local_state="0110") then
            local_state <= "0000";
            state <= "0000";
            RES <= RES_local;
            B <= B_local;
            IR_local <= instruction_data;
        elsif(local_state="0111") then
            local_state <= "1000";
            state <= "1000";
            DR_local <= instruction_data;
            RES <= RES_local;
        elsif (local_state="1000") then 
            local_state <= "0000";
            state <= "0000";
            IR_local <= instruction_data;
            DR <= DR_local;
            IR <= IR_local;
        end if;
    end process;
end implement_fsm;
            


            










