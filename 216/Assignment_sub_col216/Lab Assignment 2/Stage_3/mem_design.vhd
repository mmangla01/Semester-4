-- designing the data memory 
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity Memory is 
    port(
        clock, is_instr:in std_logic;        -- clock 
        address_to_mem: in std_logic_vector(5 downto 0);-- read/write address
        input_to_mem: in word;             -- input data
        mem_write_enable: in nibble;            -- write enable
        output_from_mem: out word             -- output data 
    );
end Memory;
-- implementation of the architecture of memory 
architecture implement_dm of Memory is 
    type data_mem is array (0 to 63) of word; -- mem array of data 
    signal data_memory: data_mem:= (others => (others => '0'));       -- signal for the data in data memory
    type prog_mem is array (0 to 63) of word; -- mem array of data 
    signal program_memory: prog_mem:= (others => (others => '0'));    -- signal for the data in program memory
begin
    process(clock)                                            -- process with change in clock
    begin  
        -- calculate the index where the input data is to be written and write accordingly
        if(rising_edge(clock)) then   -- if the rising edge of the clock then we do as write enables
            if mem_write_enable= "0001" then 
                data_memory(to_integer(unsigned(address_to_mem)))(7 downto 0) <= input_to_mem(7 downto 0);
            elsif mem_write_enable="0010" then 
                data_memory(to_integer(unsigned(address_to_mem)))(15 downto 8) <= input_to_mem(7 downto 0);
            elsif mem_write_enable="0100" then 
                data_memory(to_integer(unsigned(address_to_mem)))(23 downto 16) <= input_to_mem(7 downto 0);
            elsif mem_write_enable="1000" then 
                data_memory(to_integer(unsigned(address_to_mem)))(31 downto 24) <= input_to_mem(7 downto 0);
            elsif mem_write_enable = "0011" then 
                data_memory(to_integer(unsigned(address_to_mem)))(15 downto 0) <= input_to_mem(15 downto 0);
            elsif mem_write_enable = "1100" then 
                data_memory(to_integer(unsigned(address_to_mem)))(31 downto 16) <= input_to_mem(15 downto 0);
            elsif mem_write_enable = "1111" then 
                data_memory(to_integer(unsigned(address_to_mem))) <= input_to_mem ;
            end if;
        end if;
    end process;
    -- calculate the index that is to be read and read the data at that index
    process(address_to_mem, is_instr)   -- process on change in address to memory
    begin
        if(is_instr='0') then       -- if not instruction
            output_from_mem <= data_memory(to_integer(unsigned(address_to_mem)));   
        else                        -- else from data
            output_from_mem <= program_memory(to_integer(unsigned(address_to_mem)));   
        end if;
    end process;
end implement_dm;
