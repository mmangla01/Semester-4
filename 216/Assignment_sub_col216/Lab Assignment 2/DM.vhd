
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

entity DataMemory is 
    port(radd,wadd: in std_logic_vector(5 downto 0);
        clk:in std_logic;
        data: in std_logic_vector(31 downto 0);
        dout: out std_logic_vector(31 downto 0);
        wen: in std_logic_vector(3 downto 0));
end DataMemory;

architecture implement_dm of DataMemory is 
    type mem is array (63 downto 0) of std_logic_vector(31 downto 0);
    signal memory: mem;
    signal addressread, addresswrite: integer range 0 to 63;
begin
    process(clk,radd,wadd,wen,data)
    begin  
        addressread <= conv_integer(radd);
        addresswrite <= conv_integer(wadd);
        dout <= memory(addressread);
        if( clk'event and clk = '1') then
            if wen(0)='1' then 
                memory(addresswrite)(7 downto 0) <= data(7 downto 0);
            end if;
            if wen(1)='1' then 
                memory(addresswrite)(15 downto 8) <= data(15 downto 8);
            end if;
            if wen(2)='1' then 
                memory(addresswrite)(23 downto 16) <= data(23 downto 16);
            end if;
            if wen(3)='1' then 
                memory(addresswrite)(31 downto 24) <= data(31 downto 24);
            end if;
        end if;
    end process;
end implement_dm;
            