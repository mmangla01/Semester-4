-- designing the PM Connect
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition 
entity PMConnect is 
    port (
        is_sign_ext, IorD: in std_logic;
        b_num: in std_logic_vector(1 downto 0);
        Rout, Mout: in word;
        decoded_load_store: in load_store_type;
        decoded_trans_type: in DT_data_transfer_type;
        mem_write_enable: out nibble;
        Min, Rin: out word
    );
end PMConnect;
-- implementing the PM Connect
architecture implement_pmc of PMConnect is
begin 
    process(Rout, Mout, b_num, IorD, is_sign_ext, decoded_load_store, decoded_trans_type)
    begin 
        if(decoded_load_store = load) then 
            mem_write_enable <= "0000";
            if(decoded_trans_type = w) then 
                Rin <= Mout;
            elsif(decoded_trans_type = h) then 
                if(is_sign_ext = '0') then 
                    if(b_num = "00" or b_num = "01") then 
                        Rin <= x"0000" & Mout(15 downto 0);
                    else
                        Rin <= x"0000" & Mout(31 downto 16);
                    end if;
                else
                    if(b_num = "00" or b_num = "01") then 
                        if(Mout(15)='0') then 
                            Rin <= x"0000" & Mout(15 downto 0);
                        else
                            Rin <= x"ffff" & Mout(15 downto 0);
                        end if;
                    else
                        if(Mout(31)='0') then 
                            Rin <= x"0000" & Mout(31 downto 16);
                        else
                            Rin <= x"ffff" & Mout(31 downto 16);
                        end if;
                    end if;
                end if; 
            else
                if(is_sign_ext = '0') then
                    if(b_num = "00") then 
                        Rin <= x"000000" & Mout(7 downto 0);
                    elsif(b_num = "01") then
                        Rin <= x"000000" & Mout(15 downto 8);
                    elsif(b_num = "10") then
                        Rin <= x"000000" & Mout(23 downto 16);
                    else
                        Rin <= x"000000" & Mout(31 downto 24);
                    end if;
                else
                    if(b_num = "00") then 
                        if(Mout(7)='0') then 
                            Rin <= x"000000" & Mout(7 downto 0);
                        else
                            Rin <= x"ffffff" & Mout(7 downto 0);
                        end if;
                    elsif(b_num = "01") then 
                        if(Mout(15)='0') then 
                            Rin <= x"000000" & Mout(15 downto 8);
                        else
                            Rin <= x"ffffff" & Mout(15 downto 8);
                        end if;
                    elsif(b_num = "10") then 
                        if(Mout(23)='0') then 
                            Rin <= x"000000" & Mout(23 downto 16);
                        else
                            Rin <= x"ffffff" & Mout(23 downto 16);
                        end if;
                    else
                        if(Mout(31)='0') then 
                            Rin <= x"000000" & Mout(31 downto 24);
                        else
                            Rin <= x"ffffff" & Mout(31 downto 24);
                        end if;
                    end if;
                end if;
            end if;
        else
            if(decoded_trans_type = w) then 
                Min <= Rout;
                mem_write_enable <= "1111";
            elsif(decoded_trans_type = h) then
                Min <= Rout(15 downto 0) & Rout(15 downto 0);
                if(b_num = "00" or b_num = "01") then 
                    mem_write_enable <= "0011";
                else
                    mem_write_enable <= "1100";
                end if;
            else
                Min <= Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0);
                if(b_num = "00") then 
                    mem_write_enable <= "0001";
                elsif(b_num = "01") then 
                    mem_write_enable <= "0010";
                elsif(b_num = "10") then 
                    mem_write_enable <= "0100";
                else 
                    mem_write_enable <= "1000";
                end if;
            end if;
        end if;
    end process;
end implement_pmc;
                
