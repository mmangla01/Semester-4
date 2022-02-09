-- designing the data memory 
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity DataMemory is 
    port(radd,wadd: in std_logic_vector(5 downto 0);        -- read and write addresses
        clk:in std_logic;                                   -- clock 
        data: in std_logic_vector(31 downto 0);             -- input data
        dout: out std_logic_vector(31 downto 0);            -- output data 
        wen: in std_logic_vector(3 downto 0));              -- write enable
end DataMemory;
-- implementation of the architecture of data memory 
architecture implement_dm of DataMemory is 
    type mem is array (0 to 63) of std_logic_vector(31 downto 0); -- mem array of data 
    signal memory: mem;                                     -- signal for the data in data memory
begin
    dout <= memory(conv_integer(radd));                     -- calculate the index that is to be read and read the data at that index
    process(clk)                                            -- process with change in clock
    begin  
        -- calculate the index where the input data is to be written and write accordingly
        if(rising_edge(clk)) then                           -- if the rising edge of the clock then we do as write enables
            if wen= "0001" then 
                memory(conv_integer(wadd))(7 downto 0) <= data(7 downto 0);
            elsif wen="0010" then 
                memory(conv_integer(wadd))(15 downto 8) <= data(7 downto 0);
            elsif wen="0100" then 
                memory(conv_integer(wadd))(23 downto 16) <= data(7 downto 0);
            elsif wen="1000" then 
                memory(conv_integer(wadd))(31 downto 24) <= data(7 downto 0);
            elsif wen = "0011" then 
                memory(conv_integer(wadd))(15 downto 0) <= data(15 downto 0);
            elsif wen = "1100" then 
                memory(conv_integer(wadd))(31 downto 16) <= data(15 downto 0);
            elsif wen = "1111" then 
                memory(conv_integer(wadd)) <= data ;
            end if;
        end if;
    end process;
end implement_dm;
