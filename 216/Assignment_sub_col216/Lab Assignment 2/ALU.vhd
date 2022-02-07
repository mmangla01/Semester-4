
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ALU is
  port (op1,op2: in bit_vector(31 downto 0);
        opc:in bit_vector(3 downto 0); 
        cin: in bit;
        cout: out bit;
        result: out bit_vector(31 downto 0));
end ALU;
architecture AND of ALU is  
begin
  result <= op1 and op2;
  cout <= cin;
end AND;
architecture EOR of ALU is
begin 
    result <= op1 xor op2;
    cout <= cin;
end EOR;
architecture ADD of ALU is
begin 
  

    