-- designing the Shift/Rotate Unit
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
-- entity definition 
entity ShiftRotateUnit is 
    port (
        clock: in std_logic;                  -- clock
        shift_amount: in std_logic_vector(4 downto 0);
        data: in word;
        shift_type: in Shift_rotate_type;
        out_shift_carry: out std_logic;
        shifted_data: out word
    );
end ShiftRotateUnit;
-- implementing the Program Counter
architecture implement_sru of ShiftRotateUnit is
    component sru16 is 
        port (
            slk, in_carry: in std_logic;
            data: in word;
            shift_type: in Shift_rotate_type;
            out_carry: out std_logic;
            d_out: out word
        );
    end component;
    component sru8 is 
        port (
            slk, in_carry: in std_logic;
            data: in word;
            shift_type: in Shift_rotate_type;
            out_carry: out std_logic;
            d_out: out word
        );
    end component;
    component sru4 is 
        port (
            slk, in_carry: in std_logic;
            data: in word;
            shift_type: in Shift_rotate_type;
            out_carry: out std_logic;
            d_out: out word
        );
    end component;
    component sru2 is 
        port (
            slk, in_carry: in std_logic;
            data: in word;
            shift_type: in Shift_rotate_type;
            out_carry: out std_logic;
            d_out: out word
        );
    end component;
    component sru1 is 
        port (
            slk, in_carry: in std_logic;
            data: in word;
            shift_type: in Shift_rotate_type;
            out_carry: out std_logic;
            d_out: out word
        );
    end component;
    signal carry : std_logic_vector(4 downto 0);
    signal data1, data2, data3, data4, data5: word;
begin 
    shift1 : sru1 port map (shift_amount(0), '0', data, shift_type, carry(0), data1);
    shift2 : sru2 port map (shift_amount(1), carry(0), data1, shift_type, carry(1), data2);
    shift4 : sru4 port map (shift_amount(2), carry(1), data2, shift_type, carry(2), data3);
    shift8 : sru8 port map (shift_amount(3), carry(2), data3, shift_type, carry(3), data4);
    shift16 : sru16 port map (shift_amount(4), carry(3), data4, shift_type, carry(4), data5);
    process(clock)
    begin 
        if(rising_edge(clock)) then
            shifted_data <= data5;
            out_shift_carry <= carry(4);
        end if;
    end process;
end implement_sru;
                
