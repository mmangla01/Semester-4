-- designing the instruction decoder
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- enitity definition
entity InstructionDecoder is 
    port(
        instruction: in word;               -- input instruction 
        -- output the various fields that are decoded from instruction code
        dp_operator_class: out optype;                   -- dp operation 
        ins_class: out instr_class_type;    -- instruction class
        dp_class: out DP_subclass_type;     -- if dp class then dp sub class
        dp_operand_src: out DP_operand_src_type;    -- source of the operands
        ls: out load_store_type;            -- load or store
        dt_offset_sign: out DT_offset_sign_type;-- the offset needs to be added or subtracted 
        shift_type: out Shift_rotate_type
    );
end InstructionDecoder;
-- implementing the architecture of Instruction Decoder
architecture implement_id of InstructionDecoder is 
    type oparraytype is array (0 to 15) of optype;  -- the array of different operations
    constant oparray : oparraytype := (andop, eor, sub, rsb, add, adc, sbc, rsc, tst, teq, cmp, cmn, orr, mov, bic, mvn);
    type srtype is array (0 to 4) of Shift_rotate_type;
    constant srarray : srtype := (LSL, LSR, ASR, RORR, none);
begin
    process (instruction)
        variable opc: std_logic_vector(2 downto 0); -- variable operation code
    begin 
        opc := instruction(24 downto 22);
        if(instruction(27 downto 26)="00") then     -- DP or multiplication instruction
            dp_operator_class <= oparray(to_integer(unsigned(instruction(24 downto 21))));
            if(instruction(7 downto 4)="1001") then -- multiplication instruction 
                ins_class<= mul;
            else                                    -- else DP instruction
                ins_class<=DP;
            end if;
            if ( (opc="001") or (opc="010") or (opc="011") ) then   -- subclasses 
                dp_class <= arith;          -- arithematic (add/sub/rsb/adc/sbc/rsc)
            elsif ( (opc="000") or (opc="110") or (opc="111") ) then 
                dp_class <= logic;          -- logical (mov/mvn/and/orr/bic/eor)
            elsif (opc="101") then
                dp_class <= comp;           -- comparison (cmp/cmn)
            elsif (opc="100") then
                dp_class <= test;           -- test (tst/teq)
            else
                dp_class <= none;           -- else none 
            end if;
            if (instruction(25)='0') then   -- operand source is immidiate or register
                dp_operand_src <= reg;
            else
                dp_operand_src <= imm;
            end if;
        elsif(instruction(27 downto 26)="01") then                  -- DT instructions
            ins_class <= DT;
            if(instruction(20)='1') then
                ls <= load;                 -- if the L bit is 1 then load
            else
                ls <= store;                -- else store
            end if; 
            if(instruction(23)='1') then    -- add/sub the offset
                dt_offset_sign <= plus;
            else
                dt_offset_sign <= minus;
            end if;
        elsif(instruction(27 downto 26)="10") then                  -- branch instruction
            ins_class <= BRN;
        else
            ins_class <= none;              -- if nothing then none
        end if;
        if((instruction(27 downto 26)="00" and instruction(25)='0') or (instruction(27 downto 26)="01" and instruction(25) = '1')) then 
            shift_type <= srarray(to_integer(unsigned(instruction(6 downto 5))));
        elsif((instruction(27 downto 26)="00" and instruction(25)='1') or(instruction(27 downto 26)="01" and instruction(25)='0')) then
            shift_type <= LSL;
        else
            shift_type <= none;
        end if;
    end process;
end implement_id;


