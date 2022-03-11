library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru16 is 
    port (
        slk, in_carry: in std_logic;
        data: in word;
        shift_type: in Shift_rotate_type;
        out_carry: out std_logic;
        d_out: out word
    );
end sru16;
architecture implement_sru16 of sru16 is 
begin
    process(slk, in_carry, data, shift_type)
    begin
        if(slk = '1') then
            case (shift_type) is
                when LSL => 
                d_out <= data(15 downto 0) & X"0000";
                out_carry <= data(16);
                when LSR => 
                d_out <= X"0000" & data(31 downto 16);
                out_carry <= data(15);
                when ASR => 
                if(data(31)='0') then
                    d_out <= X"0000" & data(31 downto 16);
                else
                    d_out <= X"ffff" & data(31 downto 16);
                end if;
                out_carry <= data(15);
                when RORR => 
                d_out <= data(15 downto 0) & data(31 downto 16);
                out_carry <= data(15);
                when others => 
                d_out <= data;
                out_carry <= in_carry;
            end case;
        else
            d_out <= data;
            out_carry <= in_carry;
        end if;
    end process;
end implement_sru16;