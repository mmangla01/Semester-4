library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru1 is 
    port (
        slk, in_carry: in std_logic;
        data: in word;
        shift_type: in Shift_rotate_type;
        out_carry: out std_logic;
        d_out: out word
    );
end sru1;
architecture implement_sru1 of sru1 is 
begin
    process(slk, in_carry, data, shift_type)
    begin
        if(slk = '1') then
            case (shift_type) is
                when LSL => 
                d_out <= data(30 downto 0) & '0';
                out_carry <= data(31);
                when LSR => 
                d_out <= '0' & data(31 downto 1);
                out_carry <= data(0);
                when ASR => 
                d_out <= data(31) & data(31 downto 1);
                out_carry <= data(0);
                when RORR => 
                d_out <= data(0) & data(31 downto 1);
                out_carry <= data(0);
                when others => 
                d_out <= data;
                out_carry <= in_carry;
            end case;
        else
            d_out <= data;
            out_carry <= in_carry;
        end if;
    end process;
end implement_sru1;