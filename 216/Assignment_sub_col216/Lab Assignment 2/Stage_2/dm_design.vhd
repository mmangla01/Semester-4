-- designing the data memory 
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity DataMemory is 
    port(
        add: in std_logic_vector(5 downto 0);-- read/write address
        clk:in std_logic;          -- clock 
        data: in word;             -- input data
        wen: in nibble;            -- write enable
        dout: out word             -- output data 
    );
end DataMemory;
-- implementation of the architecture of data memory 
architecture implement_dm of DataMemory is 
    type mem is array (0 to 63) of word; -- mem array of data 
    signal memory: mem:= (others => (others => '0'));       -- signal for the data in data memory
begin
    process(clk)                                            -- process with change in clock
    begin  
        -- calculate the index where the input data is to be written and write accordingly
        if(rising_edge(clk)) then   -- if the rising edge of the clock then we do as write enables
            if wen= "0001" then 
                memory(to_integer(unsigned((add))))(7 downto 0) <= data(7 downto 0);
            elsif wen="0010" then 
                memory(to_integer(unsigned((add))))(15 downto 8) <= data(7 downto 0);
            elsif wen="0100" then 
                memory(to_integer(unsigned((add))))(23 downto 16) <= data(7 downto 0);
            elsif wen="1000" then 
                memory(to_integer(unsigned((add))))(31 downto 24) <= data(7 downto 0);
            elsif wen = "0011" then 
                memory(to_integer(unsigned((add))))(15 downto 0) <= data(15 downto 0);
            elsif wen = "1100" then 
                memory(to_integer(unsigned((add))))(31 downto 16) <= data(15 downto 0);
            elsif wen = "1111" then 
                memory(to_integer(unsigned((add)))) <= data ;
            end if;
        end if;
    end process;
    -- calculate the index that is to be read and read the data at that index
    dout <= memory(to_integer(unsigned((add))));   
end implement_dm;
