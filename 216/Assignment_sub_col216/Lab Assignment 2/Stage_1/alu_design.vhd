-- Designing ALU
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity ALU is
    port (op1,op2: in std_logic_vector(31 downto 0);    -- 2 operands 
          opc:in std_logic_vector(3 downto 0);          -- operation code
          cin: in std_logic;                            -- carry in
          cout: out std_logic;                          -- carry out 
          result: out std_logic_vector(31 downto 0));   -- final output
end ALU;
-- architecture definition
architecture implement_alu of ALU is  
begin
    process(op1,op2,cin,opc)                            -- triggered by the change change in inputs
    variable temp: std_logic_vector(32 downto 0);       -- temporary variables
    variable tempbit: std_logic := '0';                 -- defined for sequential statements
    begin
        case(opc) is                                    -- case switches for operations
            when "0000" =>                          
            temp := (tempbit & op1) and (tempbit & op2);
            when "0001" => 
            temp := (tempbit & op1) xor (tempbit & op2);
            when "0010" =>
            temp := (tempbit & op1) + (not (tempbit & op2)) + 1;
            when "0011" => 
            temp := (tempbit & op2) + (not (tempbit & op1)) + 1;
            when "0100" => 
            temp := (tempbit & op1) + (tempbit & op2);
            when "0101" => 
            temp := (tempbit & op1) + (tempbit & op2) + cin;
            when "0110" => 
            temp := (tempbit & op1) + (not (tempbit & op2)) + cin;
            when "0111" =>
            temp := (tempbit & op2) + (not (tempbit & op1)) + cin;
            when "1000" =>                          
            temp := (tempbit & op1) and (tempbit & op2);
            when "1001" => 
            temp := (tempbit & op1) xor (tempbit & op2);
            when "1010" =>
            temp := (tempbit & op1) + (not (tempbit & op2)) + 1;
            when "1011" => 
            temp := (tempbit & op1) + (tempbit & op2);
            when "1100" =>
            temp := (tempbit & op1) or (tempbit & op2);
            when "1101" =>
            temp := tempbit & op2;
            when "1110" => 
            temp := (tempbit & op1) and (not (tempbit & op2));
            when "1111" =>
            temp := (not (tempbit & op2));
            when others =>
            temp := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end case;
        result <= temp(31 downto 0);                        -- updating the result
        cout <= temp(32);                                   -- and carry out
    end process;                                            -- ending process
end implement_alu;                                          -- ending implementation
