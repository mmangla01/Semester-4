-- Designing the ALU
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

entity ALU is
    port (op1,op2: in std_logic_vector(31 downto 0);
          opc:in std_logic_vector(3 downto 0); 
          cin: in std_logic;
          cout: out std_logic;
          result: out std_logic_vector(31 downto 0));
end ALU;
architecture implement_alu of ALU is  
    signal temp: std_logic_vector(32 downto 0):= "0";
    signal tempbit: std_logic := '0';
begin
    process(op1,op2,cin)
        cout <= cin;
        case opc is 
        when ("0000"or"1000") => 
        (result <= op1 and op2;
        cout <= cin);
        when ("0001" or "1001") => 
        (result <= op1 xor op2;
        cout <= cin);
        when ("0010" or "1010") =>
        (temp <= (tempbit & op1) + (not (tempbit & op2)) + "1";
        result <= temp(31 downto 0);
        cout <= temp(32));
        when "0011" => 
        (temp <= (tempbit & op2) + (not (tempbit & op1)) + "1";
        result <= temp(31 downto 0);
        cout <= temp(32));
        when ("0100" or "1011") => 
        (temp <= (tempbit & op1)+(tempbit & op2);
        result <= temp(31 downto 0);
        cout <= temp(32));
        when "0101" => 
        (temp <= (tempbit & op1)+(tempbit & op2)+1 when cin = '1' else (tempbit & op1)+(tempbit & op2);
        result <= temp(31 downto 0);
        cout <= temp(32));
        when "0110" => 
        (temp <= (tempbit & op1)+(not (tempbit & op2))+1 when cin = '1' else (tempbit & op1)+(not (tempbit & op2));
        result <= temp(31 downto 0);
        cout <= temp(32));
        when "0111" =>
        (temp <= (tempbit & op2)+(not (tempbit & op1))+1 when cin = '1' else (tempbit & op2)+(not (tempbit & op1));
        result <= temp(31 downto 0);
        cout <= temp(32));
        when "1100" =>
        (result <= op1 or op2;
        cout <= cin);
        when "1101" =>
        (result <= op2;
        cout <= cin);
        when "1110" => 
        (result <= op1 and (not op2);
        cout <= cin);
        when "1111" =>
        (result <= not op2;
        cout <= cin);
        end case;
    end process;
end implement_alu;

    
    
    
    
    
    
    
    
    
    
    
    
    
    -- 00000000000000000000000000000000 (32)
    
    -- end implementation;
    -- architecture EOR of ALU is
        -- begin 
--     result <= op1 xor op2;
--     cout <= cin;
-- end EOR;
-- architecture ADD of ALU is
-- component Adder32
-- port (a,b: in bit_vector(31 downto 0);
--         cin: in  bit;
--         cout: out bit;
--         s: out bit_vector(31 downto 0));
-- end component;
-- begin 
-- A0: Adder32 port map(op1,op2,cin,cout,s);
-- end ADD;