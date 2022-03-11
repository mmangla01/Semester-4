-- designing the glue code
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity GlueCode is
    port(
        clock, reset: in std_logic  -- reset and clock option
    );
end GlueCode;
-- implementing the architecture of glue code
architecture implement_gc of GlueCode is 
    component ALU is
        port (
            alu_operand_1, alu_operand_2: in word;           -- 2 operands 
            alu_opc:in optype;              -- operation code
            alu_cin: in std_logic;          -- carry in
            alu_cout: out std_logic;        -- carry out 
            alu_result: out word;           -- final output
            alu_operand_1_msb, alu_operand_2_msb: out std_logic  -- msb of the inputs 
        );   
    end component;
    component ConditionChecker is 
        port (
            N_flag, Z_flag, C_flag, V_flag: in STD_LOGIC;               -- flags
            condition: in nibble;        -- input condition that is to be checked
            is_cond_true: out std_logic              -- if the condition is true 
        );
    end component;
    component flags is 
        port (
            clock, set_flags, alu_operand_1, alu_operand_2, is_shift: in std_logic;
            carry_from_alu, carry_from_shift, F_set: in std_logic;
            alu_result: in word;                    -- result from the ALU
            dp_class: in DP_subclass_type;     -- type of dp instruction
            N_flag, Z_flag, C_flag, V_flag: out std_logic-- outputed value of flags
        );
    end component;
    component InstructionDecoder is 
        port(
            instruction: in std_logic_vector(27 downto 4);               -- input instruction 
            -- output the various fields that are decoded from instruction code
            dp_operator_class: out optype;                   -- dp operation 
            ins_class: out instr_class_type;    -- instruction class
            dp_class: out DP_subclass_type;     -- if dp class then dp sub class
            dp_operand_src: out DP_operand_src_type;    -- source of the operands
            ls: out load_store_type;            -- load or store
            dt_offset_sign: out DT_offset_sign_type;-- the offset needs to be added or subtracted 
            shift_type: out Shift_rotate_type
        );
    end component;
    component Memory is 
        port(
            clock, is_instr:in std_logic;        -- clock and a boolean that tells what to read 
            address_to_mem: in std_logic_vector(5 downto 0);-- read/write address
            input_to_mem: in word;              -- input data
            mem_write_enable: in nibble;        -- write enable
            output_from_mem: out word           -- output data 
        );
    end component;
    component ProgramCounter is 
        port (
            clock, reset: in std_logic;                  -- clock
            input_to_pc: in word;
            output_from_pc: out word                    -- output pc
        );
    end component;
    component RegisterFile is 
        port (
            clock, reg_write_enable: in std_logic;          -- write enable and clock
            read_reg_1, read_reg_2, write_reg: in nibble;   -- read and write addresses
            write_data_inreg: in word;                      -- data that is to be written 
            data_outreg_1, data_outreg_2: out word           -- data that is being read 
        );
    end component;
    -- the component that has the states and gives us the control signals 
    component FiniteStateMachine is
        port(
            clock, branch_cond: in std_logic;               -- clock and the boolean for condition being true
            decoded_dpos: in DP_operand_src_type;           -- source of the operand in DP instruction
            decoded_insc: in instr_class_type;              -- instruction class
            decoded_opc: in optype;                         -- the operation code in case of DP
            decoded_dtos: in DT_offset_sign_type;           -- the sign of offset in DT instruction
            decoded_load_store: in load_store_type;         -- load or store
            -- control signals 
            PW, IorD, MW, IW, DW, M2R, Rsrc1, BW, RW: out std_logic;
            AW, Asrc1, F_set, ReW, SAW, SDW, SReW, Rsrc2: out std_logic;
            Asrc2: out std_logic_vector(1 downto 0);
            alu_opc: out optype                             -- the operation that is to be performed by ALU
        );
    end component;
    component ShiftRotateUnit is 
        port (
            clock, in_shift_carry: in std_logic;                  -- clock
            shift_amount: in std_logic_vector(4 downto 0);
            data: in word;
            shift_type: in Shift_rotate_type;
            out_shift_carry: out std_logic;
            shifted_data: out word
        );
    end component;
    -- internal signals that connect different components
    signal alu_operand_1_msb, alu_operand_2_msb, alu_cin, alu_cout, output_bool: std_logic:='0';
    signal set, SAW, SReW, PW, IorD, MW, IW, DW, M2R, Rsrc1, BW, RW, AW, Asrc1: std_logic:='0';
    signal F_set, ReW, C, N, Z, V, out_shift_carry, Rsrc2, SDW, is_shift: std_logic:='0';
    signal Asrc2: std_logic_vector(1 downto 0):= (others=>'0');
    signal mem_write_enable, read_address_2, read_address_1: nibble:= (others=>'0');
    signal shift_amount: std_logic_vector(4 downto 0):= (others => '0');
    signal mem_address: std_logic_vector(5 downto 0):= (others=>'0');
    signal alu_result, alu_operand_1, alu_operand_2, write_data_reg, A, B: word:= (others=>'0'); 
    signal reg1data, reg2data, in_data_sru, output_from_pc, output_from_mem: word:= (others=>'0'); 
    signal input_to_pc, SA, SRES, IR, DR, RES, shifted_data, SD: word:= (others=>'0');
    signal alu_opc, decoded_opc: optype;
    signal decoded_dpc: DP_subclass_type;
    signal decoded_insc: instr_class_type;
    signal decoded_dpos: DP_operand_src_type;
    signal decoded_load_store: load_store_type;
    signal decoded_dtos: DT_offset_sign_type;
    signal decoded_st, shift_type: Shift_rotate_type;
begin 
    -- map the ports that does not include the multiplexers
    arithematic: ALU port map(alu_operand_1, alu_operand_2, alu_opc, alu_cin, alu_cout, alu_result, 
                alu_operand_1_msb, alu_operand_2_msb);
    pcounter: ProgramCounter port map(clock, reset, input_to_pc, output_from_pc);
    memory_dut: Memory port map(clock, not IorD, mem_address, B, mem_write_enable, output_from_mem);
    condition: ConditionChecker port map(N, Z, C, V, IR(31 downto 28), output_bool);
    four_flags: flags port map(clock, set, alu_operand_1_msb, alu_operand_2_msb, is_shift, alu_cout, 
                out_shift_carry, F_set, alu_result, decoded_dpc, N, Z, C, V);
    decoder: InstructionDecoder port map(IR(27 downto 4), decoded_opc, decoded_insc, decoded_dpc, 
            decoded_dpos, decoded_load_store, decoded_dtos, decoded_st);
    registerf: RegisterFile port map(clock, RW, read_address_1, read_address_2, IR(15 downto 12), 
                write_data_reg, reg1data, reg2data);
    fsm: FiniteStateMachine port map(clock, output_bool, decoded_dpos, decoded_insc, decoded_opc, 
        decoded_dtos, decoded_load_store, PW, IorD, MW, IW, DW, M2R, Rsrc1, BW, RW, AW, Asrc1, F_set, 
        ReW, SAW, SDW, SReW, Rsrc2, Asrc2, alu_opc);
    sru: ShiftRotateUnit port map(clock, C, shift_amount, in_data_sru, shift_type, out_shift_carry, 
        shifted_data);

    -- now we control the components by the control signals that we get from the FSM
    process(output_from_mem, reg1data, reg2data, alu_result, output_from_pc, C, PW, IorD, MW, IW, DW, 
            M2R, Rsrc1, BW, RW, AW, Asrc1, F_set, ReW, A, B, IR, DR, RES, SA, Rsrc2, SAW, SDW, SD, 
            SReW, SRES)
    begin
        if(decoded_insc = DP and decoded_dpos = imm) then
            -- in_rev <= x"000000" & IR(7 downto 0);
            -- in_data_sru <= out_rev;
            in_data_sru <= x"000000" & IR(7 downto 0);
            -- rotate left by twice the 4 bit number IR(11 downto 8)
            shift_amount <= IR(11 downto 8) & '0' ;
            shift_type <= RORR;
            is_shift <= '1';
        elsif((decoded_insc = DT and IR(25) = '1') or (decoded_insc = DP and decoded_dpos = reg)) then
            in_data_sru <= SD;
            is_shift <= '1';
            if(IR(4)='0') then
                shift_amount <= IR(11 downto 7);
            else
                shift_amount <= SA(4 downto 0);
            end if;
            shift_type <= decoded_st;
        else 
            in_data_sru <= x"00000" & IR(11 downto 0);
            shift_type <= none;
            is_shift <= '0';
        end if;

        -- writing the registers when write enable is 1
        if(IW = '1') then IR <= output_from_mem; -- Instruction Register
        end if;
        if(DW = '1') then DR <= output_from_mem; -- Data Register
        end if;
        if(AW = '1') then A <= reg1data;         -- A Register
        end if;
        if(BW = '1') then B <= reg2data;         -- B Register
        end if;
        if(ReW = '1') then RES <= alu_result;    -- Result Register
        end if;
        if(SAW = '1') then SA <= reg1data;
        end if;
        if(SDW = '1') then SD <= reg2data;
        end if;
        if(SReW = '1') then SRES <= shifted_data;
        end if;

        if(PW = '1') then   -- if the PC write is 1 then input is given to PC 
            input_to_pc <= alu_result(29 downto 0)&"00";
        end if;
        
        if(M2R='0') then    -- implementing the MUX that checks the input data to register
            write_data_reg <= RES;
        else 
            write_data_reg <= DR;
        end if;
        if(Rsrc2 = '0') then -- implementing the MUX that checks the input read address in register
            read_address_2 <= IR(3 downto 0);
        else 
            read_address_2 <= IR(15 downto 12);
        end if;
        if(Rsrc1 = '0') then
            read_address_1 <= IR(19 downto 16);
        else
            read_address_1 <= IR(11 downto 8);
        end  if;
        if(Asrc1='0') then  -- implementing the MUX that checks the operand 1 to ALU
            alu_operand_1 <= "00"&output_from_pc(31 downto 2);
        else 
            alu_operand_1 <= A;
        end if;
        if(Asrc2="00") then -- implementing the MUX that checks the operand 2 to ALU
            alu_operand_2 <= SRES;
        elsif(Asrc2 ="01") then 
            alu_operand_2 <= X"00000001";
        elsif (Asrc2 = "10") then 
            if(IR(23)='1') then 
                alu_operand_2 <= "11111111"&IR(23 downto 0);
            else
                alu_operand_2 <= "00000000"&IR(23 downto 0);
            end if;
        end if;
        if(IorD='0') then       -- MUX for input address to memory
            mem_address <= output_from_pc(7 downto 2);
        else
            mem_address <= RES(5 downto 0);
        end if;
        
        if(MW ='1') then    -- update the memory write enable
            mem_write_enable <= "1111";
        else
            mem_write_enable <= "0000";
        end if;
        if(Asrc2 = "10") then   -- carry in for ALU 
            alu_cin <= '1';     -- if branch then cin is 1
        else
            alu_cin <= C;       -- else cin is from C flag
        end if;
        set <= IR(20);
    end process;
end implement_gc;

