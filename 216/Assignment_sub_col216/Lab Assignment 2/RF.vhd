
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

entity RegisterFile is 
    port (rad1, rad2, wad: in std_logic_vector(3 downto 0);
            data: in std_logic_vector(31 downto 0);
            wen,clk: in std_logic;
            dout1,dout2: out std_logiv_vector(31 downto 0) );
end Registerfile;

architecture implement_rf of Registerfile is
type mem is array (15 downto 0) of std_logic_vector(31 downto 0);
signal memory: mem;
signal addressread1,addressread2,addresswrite: integer range 0 to 15
begin
    process(clk,wen,data,rad1,rad2,wad)
    begin
        addressread1 <= conv_integer(rad1);
        addressread2 <= conv_integer(rad2);
        addresswrite <= conv_integer(wad);
        dout1 <= memory(addressread1);
        dout2 <= memory(addressread2);
        if (clk'event and clk = '1') then
            if wen = '1' then 
                memory(addresswrite) <= data;
            end if;
        end if;
    end process;
end implement_rf;
