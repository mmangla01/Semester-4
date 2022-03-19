library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity sru4 is 
    port (
        slk, in_carry: in std_logic;
        data: in word;
        shift_type: in Shift_rotate_type;
        out_carry: out std_logic;
        d_out: out word
    );
end sru4;
architecture implement_sru4 of sru4 is 
begin
    process(slk, in_carry, data, shift_type)
    begin
        if(slk = '1') then
            case (shift_type) is
                when LSL => 
                d_out <= data(27 downto 0) & "0000";
                out_carry <= data(28);
                when LSR => 
                d_out <= "0000" & data(31 downto 4);
                out_carry <= data(3);
                when ASR => 
                if(data(31)='0') then
                    d_out <= "0000" & data(31 downto 4);
                else
                    d_out <= "1111" & data(31 downto 4);
                end if;
                out_carry <= data(3);
                when RORR => 
                d_out <= data(3 downto 0) & data(31 downto 4);
                out_carry <= data(3);
                when others => 
                d_out <= data;
                out_carry <= in_carry;
            end case;
        else
            d_out <= data;
            out_carry <= in_carry;
        end if;
    end process;
end implement_sru4;