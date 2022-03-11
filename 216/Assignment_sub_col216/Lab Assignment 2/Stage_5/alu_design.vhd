-- Designing ALU
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity ALU is
    port (
        alu_operand_1, alu_operand_2: in word;           -- 2 operands 
        alu_opc: in optype;              -- operation code
        alu_cin: in std_logic;          -- carry in
        alu_cout: out std_logic;        -- carry out 
        alu_result: out word;           -- final output
        alu_operand_1_msb, alu_operand_2_msb: out std_logic  -- msb of the inputs 
    );   
end ALU;
-- implementing the architecture of ALU
architecture implement_alu of ALU is  
begin
    process(alu_opc, alu_operand_1, alu_operand_2)              -- triggered by the change change in inputs
    variable temp: std_logic_vector(32 downto 0);-- temporary variables
    variable tempop2: std_logic_vector(31 downto 0);
    variable tempop3: std_logic_vector(31 downto 0);
    variable tempop4: std_logic_vector(31 downto 0);
    begin
        tempop2 := (not alu_operand_2) + 1;
        tempop3 := (not alu_operand_2) + alu_cin;
        tempop4 := alu_operand_2 + alu_cin;
        case(alu_opc) is                             -- case switches for operations
            when andop =>                          
            temp := ('0' & alu_operand_1) and ('0' & alu_operand_2);
            when eor => 
            temp := ('0' & alu_operand_1) xor ('0' & alu_operand_2);
            when sub => 
            temp := ('0' & alu_operand_1) + (not ('1' & alu_operand_2)) + 1;
            when rsb => 
            temp := ('0' & alu_operand_2) + (not ('1' & alu_operand_1)) + 1;
            when add => 
            temp := ('0' & alu_operand_1) + ('0' & alu_operand_2);
            when adc => 
            temp := ('0' & alu_operand_1) + ('0' & alu_operand_2) + alu_cin;
            when sbc => 
            temp := ('0' & alu_operand_1) + (not ('1' & alu_operand_2)) + alu_cin;
            when rsc => 
            temp := ('0' & alu_operand_2) + (not ('1' & alu_operand_1)) + alu_cin;
            when tst =>                          
            temp := ('0' & alu_operand_1) and ('0' & alu_operand_2);
            when teq => 
            temp := ('0' & alu_operand_1) xor ('0' & alu_operand_2);
            when cmp => 
            temp := ('0' & alu_operand_1) + (('0' & (not  alu_operand_2)) + 1);
            when cmn => 
            temp := ('0' & alu_operand_1) + ('0' & alu_operand_2);
            when orr =>
            temp := ('0' & alu_operand_1) or ('0' & alu_operand_2);
            when mov =>
            temp := '0' & alu_operand_2;
            when bic => 
            temp := ('0' & alu_operand_1) and (not ('1' & alu_operand_2));
            when mvn =>
            temp := (not ('1' & alu_operand_2));
            when others =>
            temp := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end case;
        alu_result <= temp(31 downto 0);               -- updating the alu_result
        alu_cout <= temp(32);                          -- carry out
        case(alu_opc) is
            when sub|rsb|cmp =>
            alu_operand_2_msb <= tempop2(31); -- updating the msb of operand2 for different conditions
            when sbc|rsc =>
            alu_operand_2_msb <= tempop3(31);
            when adc =>
            alu_operand_2_msb <= tempop4(31);
            when others =>
            alu_operand_2_msb <= alu_operand_2(31);
        end case;
        alu_operand_1_msb <= alu_operand_1(31);                            -- msb of the operand1
    end process;                                    -- ending process
end implement_alu;                                  -- ending implementation
