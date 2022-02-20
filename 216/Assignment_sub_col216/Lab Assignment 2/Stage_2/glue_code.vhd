-- designing the glue code
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity GlueCode is
    port(
        reset, clock: in std_logic  -- reset and clock option
    );
end GlueCode;
-- implementing the architecture of glue code
architecture implement_gc of GlueCode is 
    component ALU is
        port (
            op1,op2: in word;           -- 2 operands 
            opc:in optype;              -- operation code
            cin: in std_logic;          -- carry in
            cout: out std_logic;        -- carry out 
            result: out word;           -- final output
            msb1, msb2 : out std_logic  -- msb of the inputs 
        );
    end component;
    component ConditionChecker is 
        port (
            N_flag: in STD_LOGIC;  -- outputed value of flags
            Z_flag: in STD_LOGIC;  -- outputed value of flags
            C_flag: in STD_LOGIC;  -- outputed value of flags
            V_flag: in STD_LOGIC;  -- outputed value of flags
            cond: in nibble;       -- input condition that is to be checked
            is_true: out std_logic -- if the condition is true 
        );
    end component;
    component DataMemory is 
        port(
            add: in std_logic_vector(5 downto 0);-- read and write addresses
            clk:in std_logic;          -- clock 
            data: in word;             -- input data
            wen: in nibble;            -- write enable
            dout: out word             -- output data 
        );
    end component;
    component flags is 
        port (
            set: in std_logic;                  -- if the flags are to be set
            clock: in std_logic;                -- clock
            dp_class : in DP_subclass_type;     -- type of dp instruction
            is_shift: in std_logic;             -- if shift or not
            carry_from_alu: in std_logic;       -- the carry form alu
            carry_from_shift: in std_logic;     -- carry from shift
            msb1, msb2: std_logic;              -- msb of the operands
            result: in word;                    -- result from the ALU
            N_flag: out std_logic;              -- outputed value of flags
            Z_flag: out std_logic;              -- outputed value of flags
            C_flag: out std_logic;              -- outputed value of flags
            V_flag: out std_logic               -- outputed value of flags
        );
    end component;
    component InstructionDecoder is 
        port(
            instruction: in word;               -- input instruction 
            -- output the various fields that are decoded from instruction code
            oper: out optype;                   -- dp operation 
            ins_class: out instr_class_type;    -- instruction class
            dp_class: out DP_subclass_type;     -- if dp class then dp sub class
            dp_operand_src: out DP_operand_src_type;   -- source of the operands
            ls: out load_store_type;            -- load or store
            dt_offset_sign: out DT_offset_sign_type-- the offset needs to be added or subtracted 
        );
    end component;
    component ProgramCounter is 
        port (
            clock: in std_logic;                      -- clock
            offset: in std_logic_vector(23 downto 0); -- the offset relative to pc
            branch: in std_logic;                     -- wether to branch or not
            rst: in std_logic;
            out_pc: out word                          -- output pc
        );
    end component;
    component ProgramMemory is 
        port(
            radd: in std_logic_vector(5 downto 0);    -- reading address 
            dout: out word                       -- the data that is read
        );
    end component;
    component RegisterFile is 
        port (
            rad1, rad2, wad: in nibble;     -- read and write addresses
            data: in word;                  -- data that is to be written 
            wen,clk: in std_logic;          -- write enable and clock
            dout1,dout2: out word           -- data that is being read 
        );
    end component;
    -- internal signals that connect different components
    signal pcout, instr, d_out, d1, data_out, d2, d, b_in: word;    
    signal c2_out, ms1, ms2, output_bool, s, s2, br, C, N, Z, V: std_logic;
    signal r2, mw: nibble;
    signal dpc: DP_subclass_type;
    signal insc: instr_class_type;
    signal dpos: DP_operand_src_type;
    signal load_store: load_store_type;
    signal dtos: DT_offset_sign_type;
    signal op, op_mod: optype;
begin 
    -- map the ports that does not include the multiplexers
    arithematic: ALU port map(d1, b_in, op_mod, C, c2_out, d_out, ms1, ms2);
    condition: ConditionChecker port map(N, Z, C, V, instr(31 downto 28), output_bool);
    data: DataMemory port map(d_out(5 downto 0), clock, d2, mw, data_out);
    four_flags: flags port map(s, clock, dpc,'0', c2_out,'0', ms1, ms2, d_out, N, Z, C, V);
    decoder: InstructionDecoder port map(instr, op, insc, dpc, dpos, load_store, dtos);
    pcounter: ProgramCounter port map(clock, instr(23 downto 0), br, reset, pcout);
    program: ProgramMemory port map(pcout(7 downto 2), instr);
    registerf: RegisterFile port map(instr(19 downto 16), r2, instr(15 downto 12), d, s2, clock, d1, d2);
    process(dpos, insc, d2, instr, d_out, data_out, load_store, output_bool, clock)
    begin
        -- defining the second input of the ALU
        if(dpos = reg) then b_in <= d2; -- in case of operand from register
        else b_in <= "00000000000000000000"&instr(11 downto 0); -- if immediate
        end if;
        -- defining the read address port 2 in the register file
        if (insc = DP) then r2 <= instr(3 downto 0);-- if the instruction is DP then read the operand
        else r2 <= instr(15 downto 12); -- else read the destination
        end if;
        -- defining the data that is to be written in register file
        if(insc=DT) then d <= data_out; -- data from data memory in case of date transfer instruction
        else d <= d_out;        -- else data from data memory
        end if;
        -- write enable of the data memory (only word write is there)
        if(load_store=load) then mw <= "0000";  -- in case of the load instruction don't write
        else mw <= "1111";      -- else write
        end if;
        -- set bit in flags 
        if(insc=DP) then s <= instr(20);    -- if DP instruction then 20th bit
        else s <= '0';                      -- else set is 0
        end if;
        -- defining the write enable of the register file
        if(insc=DT) then s2 <= instr(20);   -- if DT then 20th bit
        elsif (insc=DP) then                -- if DP then
            if(dpc=comp) then               -- if comp then 0
                s2 <= '0';          
            else                            -- else 1
                s2 <= '1';
            end if;  
        else s2 <= '0';
        end if;
        -- setting the branch value of pc
        if(insc=BRN) then br <= output_bool; -- if branch instruction and condition is true
        else br <= '0';                     -- then branch else 0
        end if;
        -- operation being performed in the ALU
        if(insc =DP) then   -- if DP instruction then 
            op_mod <= op;   -- the operation decided by decoder
        elsif(dtos = plus) then -- else if the offset is to be added then 
            op_mod <= add;  -- add operation
        else                -- else the offset is to be subtracted
            op_mod <= sub;  -- => sub operation
        end if;
    end process;
end implement_gc;

