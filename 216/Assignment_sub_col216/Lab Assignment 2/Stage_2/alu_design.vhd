-- Designing ALU
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity ALU is
    port (
        op1,op2: in word;           -- 2 operands 
        opc:in optype;              -- operation code
        cin: in std_logic;          -- carry in
        cout: out std_logic;        -- carry out 
        result: out word;           -- final output
        msb1, msb2 : out std_logic  -- msb of the inputs 
    );   
end ALU;
-- implementing the architecture of ALU
architecture implement_alu of ALU is  
begin
    process(opc,op1,op2)              -- triggered by the change change in inputs
    variable temp: std_logic_vector(32 downto 0);-- temporary variables
    variable tempop2: std_logic_vector(31 downto 0);
    variable tempop3: std_logic_vector(31 downto 0);
    variable tempop4: std_logic_vector(31 downto 0);
    begin
        tempop2 := (not op2) + 1;
        tempop3 := (not op2) + cin;
        tempop4 := op2 + cin;
        case(opc) is                             -- case switches for operations
            when andop =>                          
            temp := (op1(31) & op1) and (op2(31) & op2);
            when eor => 
            temp := (op1(31) & op1) xor (op2(31) & op2);
            when sub => 
            temp := (op1(31) & op1) + (not (op2(31) & op2)) + 1;
            when rsb => 
            temp := (op2(31) & op2) + (not (op1(31) & op1)) + 1;
            when add => 
            temp := (op1(31) & op1) + (op2(31) & op2);
            when adc => 
            temp := (op1(31) & op1) + (op2(31) & op2) + cin;
            when sbc => 
            temp := (op1(31) & op1) + (not (op2(31) & op2)) + cin;
            when rsc => 
            temp := (op2(31) & op2) + (not (op1(31) & op1)) + cin;
            when tst =>                          
            temp := (op1(31) & op1) and (op2(31) & op2);
            when teq => 
            temp := (op1(31) & op1) xor (op2(31) & op2);
            when cmp => 
            temp := (op1(31) & op1) + (not (op2(31) & op2)) + 1;
            when cmn => 
            temp := (op1(31) & op1) + (op2(31) & op2);
            when orr =>
            temp := (op1(31) & op1) or (op2(31) & op2);
            when mov =>
            temp := op2(31) & op2;
            when bic => 
            temp := (op1(31) & op1) and (not (op2(31) & op2));
            when mvn =>
            temp := (not (op2(31) & op2));
            when others =>
            temp := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end case;
        result <= temp(31 downto 0);               -- updating the result
        cout <= temp(32);                          -- carry out
        case(opc) is
            when sub|rsb|cmp =>
            msb2 <= tempop2(31); -- updating the msb of operand2 for different conditions
            when sbc|rsc =>
            msb2 <= tempop3(31);
            when adc =>
            msb2 <= tempop4(31);
            when others =>
            msb2 <= op2(31);
        end case;
        msb1 <= op1(31);                            -- msb of the operand1
    end process;                                    -- ending process
end implement_alu;                                  -- ending implementation
