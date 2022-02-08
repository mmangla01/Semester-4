
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

entity ALU is
    port (op1,op2: in std_logic_vector(31 downto 0);
          opc:in std_logic_vector(3 downto 0); 
          cin: in std_logic;
          cout: out std_logic;
          result: out std_logic_vector(31 downto 0));
end ALU;

architecture implement_alu of ALU is  
    signal temp: std_logic_vector(32 downto 0):= (others => '0');
    signal tempbit: std_logic := '0';
begin
    -- process(op1,op2,cin)
    process
    begin
      --   cout <= cin;
        case(opc) is 
        when ("0000"|"1000") => 
        temp <= (tempbit & op1) and (tempbit & op2);
        when ("0001"|"1001") => 
        temp <= (tempbit & op1) xor (tempbit & op2);
        when ("0010"|"1010") =>
        temp <= (tempbit & op1) + (not (tempbit & op2)) + 1;
        when "0011" => 
        temp <= (tempbit & op2) + (not (tempbit & op1)) + 1;
        when ("0100"|"1011") => 
        temp <= (tempbit & op1) + (tempbit & op2);
        when "0101" => 
        temp <= (tempbit & op1) + (tempbit & op2) + 1 when cin = '1' else (tempbit & op1) + (tempbit & op2);
        when "0110" => 
        temp <= (tempbit & op1) + (not (tempbit & op2)) + 1 when cin = '1' else (tempbit & op1) + (not (tempbit & op2));
        when "0111" =>
        temp <= (tempbit & op2) + (not (tempbit & op1)) + 1 when cin = '1' else (tempbit & op2) + (not (tempbit & op1));
        when "1100" =>
        temp <= (tempbit & op1) or (tempbit & op2);
        when "1101" =>
        temp <= tempbit & op2;
        when "1110" => 
        temp <= (tempbit & op1) and (not (tempbit & op2));
        when "1111" =>
        temp <= (not (tempbit & op2));
        when others =>
        temp <= (tempbit & op1);
        end case;
        result <= temp(31 downto 0);
        cout <= temp(32);
    end process;
end implement_alu;
