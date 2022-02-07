-- Designing the ALU
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

-- 1 bit adder
entity Adder1 is
  port (a,b,cin: in bit;
        cout,s: out bit);
end Adder1;
architecture add1bit of Adder1 is
begin 
  s <= a xor b xor cin;
  cout <= (a and b) or (b and cin) or (cin and a);
end add1bit;

-- 2 bit adder
entity Adder2 is 
port (a,b: in bit_vector(1 downto 0);
      cin : in bit;
      cout: out bit;
      s: out bit_vector(1 downto 0));
end Adder2;
architecture add2bit of Adder2 is
  component Adder1 
  port (a,b,cin: in bit;
        cout,s: out bit);
  end component;
  signal c: bit;
  begin 
    A0: Adder1 port map (a(0),b(0),cin,c,s(0));
    A1: Adder1 port map (a(1),b(1),c,cout,s(1));
end add2bit;

-- 4 bit adder
entity Adder4 is 
port (a,b: in bit_vector(3 downto 0);
      cin : in bit;
      cout: out bit;
      s: out bit_vector(3 downto 0));
end Adder4;
architecture add4bit of Adder4 is
  component Adder2 
  port (a,b: in bit_vector(1 downto 0);
  cin: in bit;
        cout: out bit;
        s: out bit_vector(1 downto 0));
  end component;
  signal c: bit;
  begin 
    A0: Adder2 port map (a(1 downto 0),b(1 downto 0),cin,c,s(1 downto 0));
    A1: Adder2 port map (a(3 downto 2),b(3 downto 2),c,cout,s(3 downto 2));
end add4bit;

-- 8 bit adder
entity Adder8 is 
port (a,b: in bit_vector(7 downto 0);
      cin : in bit;
      cout: out bit;
      s: out bit_vector(7 downto 0));
end Adder8;
architecture add8bit of Adder8 is
  component Adder4 
  port (a,b: in bit_vector(3 downto 0);
  cin: in bit;
        cout: out bit;
        s: out bit_vector(3 downto 0));
  end component;
  signal c: bit;
  begin 
    A0: Adder4 port map (a(3 downto 0),b(3 downto 0),cin,c,s(3 downto 0));
    A1: Adder4 port map (a(7 downto 4),b(7 downto 4),c,cout,s(7 downto 4));
end add8bit;

-- 16 bit adder
entity Adder16 is 
port (a,b: in bit_vector(15 downto 0);
      cin : in bit;
      cout: out bit;
      s: out bit_vector(15 downto 0));
end Adder16;
architecture add16bit of Adder16 is
  component Adder8 
  port (a,b: in bit_vector(7 downto 0);
  cin: in bit;
        cout: out bit;
        s: out bit_vector(7 downto 0));
  end component;
  signal c: bit;
  begin 
    A0: Adder8 port map (a(7 downto 0),b(7 downto 0),cin,c,s(7 downto 0));
    A1: Adder8 port map (a(15 downto 8),b(15 downto 8),c,cout,s(15 downto 8));
end add16bit;

-- 32 bit adder
entity Adder32 is 
port (a,b: in bit_vector(7 downto 0);
      cin : in bit;
      cout: out bit;
      s: out bit_vector(7 downto 0));
end Adder32;
architecture add32bit of Adder32 is
  component Adder16 
  port (a,b: in bit_vector(31 downto 0);
  cin: in bit;
        cout: out bit;
        s: out bit_vector(31 downto 0));
  end component;
  signal c: bit;
  begin 
    A0: Adder16 port map (a(15 downto 0),b(15 downto 0),cin,c,s(15 downto 0));
    A1: Adder16 port map (a(31 downto 16),b(31 downto 16),c,cout,s(31 downto 16));
end add32bit;

entity ALU is
  port (op1,op2: in bit_vector(31 downto 0);
        opc:in bit_vector(3 downto 0); 
        cin: in bit;
        cout: out bit;
        result: out bit_vector(31 downto 0));
end ALU;
-- architecture and of ALU is  
-- begin
--   result <= op1 and op2;
--   cout <= cin;
-- end AND;
-- architecture EOR of ALU is
-- begin 
--     result <= op1 xor op2;
--     cout <= cin;
-- end EOR;
-- architecture ADD of ALU is
-- component Adder32
--   port (a,b: in bit_vector(31 downto 0);
--         cin: in  bit;
--         cout: out bit;
--         s: out bit_vector(31 downto 0));
--   end component;
-- begin 
--   A0: Adder32 port map(op1,op2,cin,cout,s);
-- end ADD;
architecture implementation of ALU is
  component Adder32
  port (a,b: in bit_vector(31 downto 0);
        cin: in  bit;
        cout: out bit;
        s: out bit_vector(31 downto 0));
  end component;
  signal addition : bit_vector(31 downto 0);
begin 
    result <= op1 and op2 when opc = "0000"
    else op1 xor op2 when opc = "0001"
    else A0: Adder32 port map (op1,op2,cin,)






    