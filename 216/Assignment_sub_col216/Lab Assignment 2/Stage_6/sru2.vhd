library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru2 is 
    port (
        slk, in_carry: in std_logic;
        data: in word;
        shift_type: in Shift_rotate_type;
        out_carry: out std_logic;
        d_out: out word
    );
end sru2;
architecture implement_sru2 of sru2 is 
begin
    process(slk, in_carry, data, shift_type)
    begin
        if(slk = '1') then
            case (shift_type) is
                when LSL => 
                d_out <= data(29 downto 0) & "00";
                out_carry <= data(30);
                when LSR => 
                d_out <= "00" & data(31 downto 2);
                out_carry <= data(1);
                when ASR => 
                if(data(31)='0') then
                    d_out <= "00" & data(31 downto 2);
                else
                    d_out <= "11" & data(31 downto 2);
                end if;
                out_carry <= data(1);
                when RORR => 
                d_out <= data(1 downto 0) & data(31 downto 2);
                out_carry <= data(1);
                when others => 
                d_out <= data;
                out_carry <= in_carry;
            end case;
        else
            d_out <= data;
            out_carry <= in_carry;
        end if;
    end process;
end implement_sru2;