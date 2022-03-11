library IEEE;
use work.myTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity reversal is
    port (
        in_rev: in word;
        out_rev: out word
    );
end reversal;
architecture implement_rev of reversal is
begin
    process(in_rev)
    begin
        for i in 0 to 31 loop
            out_rev(i) <= in_rev(31-i);
        end loop;
    end process;
end implement_rev;