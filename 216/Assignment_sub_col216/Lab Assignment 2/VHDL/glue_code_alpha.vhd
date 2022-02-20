library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GlueCode is
    -- port(
    --     start:in word;
    -- );
end GlueCode;

architecture implement_gc of GlueCode is 
    component ALU is
        port (
            op1,op2: in word;           -- 2 operands 
            opc:in word;                -- operation code
            cin: in std_logic;          -- carry in
            cout: out std_logic;        -- carry out 
            result: out word            -- final output
            msb1, msb2 : out std_logic; -- msb of the inputs 
        );   
    end component;
    component DataMemory is 
        port(add: in std_logic_vector(5 downto 0);              -- read and write addresses
            clk:in std_logic;                                   -- clock 
            data: in word;             -- input data
            dout: out word;            -- output data 
            wen: in nibble);              -- write enable
    end component;
    component ProgramMemory is 
        port(radd: in std_logic_vector(5 downto 0);             -- reading address 
            dout: out word);           -- the data that is to read
    end component;
    component RegisterFile is 
        port (rad1, rad2, wad: in nibble;     -- read and write addresses
            data: in word;                 -- data that is to be written 
            wen,clk: in std_logic;                                  -- write enable and clock
            dout1,dout2: out word);        -- data that is being read 
    end component;
    component ConditionChecker is 
        port (
            flags: in nibble;       -- input the flags
            cond: in nibble;        -- input condition that is to be checked
            is_true: out std_logic  -- if the condition is true 
        );
    end component;
    component flags is 
        port (
            set: in std_logic;                  -- if the flags are to be set
            clk: in std_logic;                  -- clock
            dp_class : in DP_subclass_type;     -- type of dp instruction
            is_shift: in std_logic;             -- if shift or not
            carry_from_alu: in std_logic;       -- the carry form alu
            carry_from_shift: in std_logic;     -- carry from shift
            msb1, msb2: std_logic;              -- msb of the operands
            result: in word;                    -- result from the ALU
            out_flags: nibble                   -- outputed value of flags
        );
    end component;
    component InstructionDecoder is 
        port(
            instruction: in word;               -- input instruction 
            -- output the various fields that are decoded from instruction code
            oper: out optype;                   -- dp operation 
            ins_class: out instr_class_type:= (others => none);-- instruction class
            dp_class: out DP_subclass_type:= (others => none);-- if dp class then dp sub class
            dp_operand_src: out DP_operand_src_type;    -- source of the operands
            ls: out load_store_type;            -- load or store
            dt_offset_sign: out DT_offset_type  -- the offset needs to be added or subtracted 
        );
    end component;
    component ProgramCounter is 
        port (
            clk: in std_logic;                        -- clock
            offset: in std_logic_vector(23 downto 0);   -- the offset relative to pc in case of branch instruction to be implemented
            offset_sign: in DT_offset_sign_type;        -- offset to be added or subtracted 
            out_pc: out word;                           -- output pc
            branch: in std_logic                        -- wether to branch or not
        );
    end component;
    -- signal pc: word
    signal clock1,clock2,clock3,clock4: std_logic;
    -- signal os : std_logic_vector(23 downto 0):= (others => '0');
    signal oss: DT_offset_sign_type;
    signal pcout: word;
    signal b: std_logic:= (others =>'0');
    signal instr: word;

begin 
    counter: ProgramCounter port map(clock4,os,oss,pcout,output_bool);
    arithematic: ALU port map(d1, b_in, opc_in, c1_in, c2_out, d_out, ms1, ms2);
    data: DataMemory port map(address,clock1,data_in,data_out,wenable);
    program: ProgramMemory port map(readaddress,data);
    register: RegisterFile port map(r1,r2,w,d,we,clock2,d1,d2);
    condition: ConditionChecker port map(out_flg,condition,output_bool);
    four_flags: flags port map(s,clock3,dpc,iss,cfa,cfs,ms1,ms2,sum,out_flg);
    decoder: InstructionDecoder port map(instr,op,insc,dpc,dpos,load,dtos);
    process
    begin
        os <= instr(23 downto 0);
        readaddress <= pcout(7 downto 2);
        r1 <= instr(19 downto 16);
        w <= instr(15 downto 12);
        condition <= instr(31 downto 28);
        s <= instr(20);
        cfa <= c2_out;
        sum <= d_out;
        instr<= data;
        






    -- counter: ProgramCounter port map(clock4,instr(23 downto 0),oss,pcout,output_bool);
    -- arithematic: ALU port map(d1, b_in, opc_in, c1_in, c2_out, d_out, ms1, ms2);
    -- data: DataMemory port map(address,clock1,data_in,data_out,wenable);
    -- program: ProgramMemory port map(pcout(7 downto 2),instr);
    -- register: RegisterFile port map(instr(19 downto 16),r2,instr(15 downto 12),d,we,clock2,d1,d2);
    -- condition: ConditionChecker port map(out_flg,instr(31 downto 28),output_bool);
    -- four_flags: flags port map(instr(20),clock3,dpc,iss,c2_out,cfs,ms1,ms2,d_out,out_flg);
    -- decoder: InstructionDecoder port map(instr,op,insc,dpc,dpos,load,dtos);
    -- process
    -- begin



