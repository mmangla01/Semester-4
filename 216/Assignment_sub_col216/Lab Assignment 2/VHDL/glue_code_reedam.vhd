library IEEE;
use IEEE.std_logic_1164.all; -- standard libraries
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.MyTypes.all;

entity processor is -- empty testbench
	port(
		clock : in std_logic;
		reset : in std_logic
	);
end processor;

architecture main_processor of processor is
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
            N_flag: out STD_LOGIC;  -- outputed value of flags
            Z_flag: out STD_LOGIC;  -- outputed value of flags
            C_flag: out STD_LOGIC;  -- outputed value of flags
            V_flag: out STD_LOGIC;  -- outputed value of flags
            cond: in nibble;        -- input condition that is to be checked
            is_true: out std_logic  -- if the condition is true 
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

	-- Below  all the required connecting signals are defined and initialized.
	signal bool_in : std_logic := '0';
	signal offset : std_logic_vector(31 downto 0) := (others => '0');
	signal pc_output : std_logic_vector(31 downto 0):=(others => '0');
	signal instruction : std_logic_vector(31 downto 0):=(others => '0');
	signal instr_class : instr_class_type;
	signal operation : optype;
	signal condition : nibble;
	signal DP_subclass : DP_subclass_type;
	signal DP_operand_src : DP_operand_src_type;
	signal load_store : load_store_type;
	signal DT_offset_sign : DT_offset_sign_type;
	signal read_address1: std_logic_vector(3 downto 0):= (others  => '0');
	signal read_address2: std_logic_vector(3 downto 0):= (others  => '0');
	signal writeEnable: std_logic := '0';
	signal writeAddress : std_logic_vector(3 downto 0):= (others  => '0');
	signal dataInput : std_logic_vector(31 downto 0) := (others  => '0');
	signal output1: std_logic_vector(31 downto 0):= (others  => '0');
	signal output2: std_logic_vector(31 downto 0):= (others  => '0');
	signal A : std_logic_vector(31 downto 0):=(others =>'0');
	signal B : std_logic_vector(31 downto 0):=(others => '0');
	signal carry_input: std_logic := '0';
	signal final_output: std_logic_vector(31 downto 0):=(others => '0');
	signal carry_output:std_logic:='0';
	signal C:std_logic:='0';
	signal V:std_logic:='0';
	signal N:std_logic:='0';
	signal Z:std_logic:='0';
	signal bool_output:std_logic:='0';
	signal sbit: std_logic:='0';
	signal srot: std_logic:='0';
	signal MSB_A: std_logic:='0';
	signal MSB_B: std_logic:='0';
	signal address:std_logic_vector(5 downto 0):=(others=>'0');
	signal writeEnable_data:std_logic_vector(3 downto 0):=(others=>'0');
	signal input_data:std_logic_vector(31 downto 0):=(others=>'0');
	signal output_data:std_logic_vector(31 downto 0):=(others=>'0');

begin
	get_instruct : ProgramMemory port map(pc_output(7 downto 2),instruction); -- port mapping for program memory
	decode_instr : InstructionDecoder port map(instruction,operation,instr_class,DP_subclass,DP_operand_src,load_store,DT_offset_sign); -- port mapping to decode instruction
	cond_check: ConditionChecker port map(N, Z, C, V, instruction(31 downto 28),bool_output); -- port mapping to check condition

	-- process to set values for port mapping pc
	p0: process(instr_class,bool_output,DT_offset_sign,instruction)
	begin
		-- if(DT_offset_sign=minus) then  -- doing sign extension for offset of pc.
		-- 	offset <= ("111111"&instruction(23 downto 0)&"00");
		-- else
		-- 	offset <= ("000000"&instruction(23 downto 0)&"00");
		-- end if;
		if (instr_class = BRN and bool_output = '1') then -- add offset in pc only if branch instruction and output of condition checker is 1.
			bool_in <= '1';
		else 
			bool_in <= '0';
		end if;
	end process p0;
	program_inst : ProgramCounter port map(clock,instruction(23 downto 0),bool_in,reset,pc_output); -- port mapping for program counter.

	-- process to set values for port mapping register file
	p1: process(instruction,instr_class)
	begin
		writeAddress <= instruction(15 downto 12); -- set write address of register file
		read_address1 <= instruction(19 downto 16); -- set 1st read address of register file
		if(instr_class=DP) then	-- set read address 2 according to type of instruction. 
			read_address2 <= instruction(3 downto 0);
		else
			read_address2 <= instruction(15 downto 12);
		end if;
	end process p1;
	regfile_map : RegisterFile port map(read_address1,read_address2,writeAddress,dataInput,writeEnable,clock,output1,output2); -- port mapping for register file.

	-- process to set values for port mapping ALU
	p2: process(output1,output2,DP_operand_src,instruction,instr_class,C)
	begin 
		A <= output1; -- set value in 1st read adress of reg file as input to alu.
		carry_input <= C; -- set carry input as C flag
		if(DP_operand_src = imm and instr_class=DP) then  -- set the second input to alu according to its instruction and operand class.
			B <= (X"000000"&instruction(7 downto 0));
		elsif((DP_operand_src = reg) and instr_class=DP) then
			B <= output2;
		else
			B <= (X"00000"&instruction(11 downto 0));
		end if;
	end process p2;
	ALU_map : ALU port map(A,B,operation,carry_input,carry_output,final_output,MSB_A,MSB_B); -- port mapping for ALU

	--process to set values for port mapping flags
	p3: process(A,B,load_store,instruction)
	begin
		-- MSB_A <= A(31); -- get msb of input of A
		-- MSB_B <= B(31); -- get msb of input of B
		if load_store = store then -- set bit
			sbit <= '0';
		else
			sbit <= '1';
		end if;
	end process p3;
	Flag_map : flags port map(sbit,clock,DP_subclass,srot,carry_output,'0',MSB_A,MSB_B,final_output, N, Z, C, V); -- port mapping for flag

	-- process to set values for port mapping data memory
	p4: process(instruction,final_output,output2,load_store)
	begin
		address <= final_output(5 downto 0); -- set address of data memory as output of alu.
		input_data <= output2; -- set input data as value in read adress 2 of reg file
		if load_store = load then -- set write enable
			writeEnable_data <= "0000";
		else
			writeEnable_data <= "1111";
		end if;
	end process p4;
	DataMem_map : DataMemory port map(address,clock,input_data,writeEnable_data,output_data); -- port mapping for data memory

	-- process to set values for data memory to reg file link
	p5: process(instruction,load_store,DP_subclass,instr_class,output_data,final_output)
	begin
		if(load_store=load) then -- see if load store is of load type or store type.
			dataInput <= output_data;
		else
			dataInput <= final_output;
		end if;
			
		if ((instr_class=DP and (DP_subclass = arith or DP_subclass = logic)) or (instr_class=DT and load_store = load)) then -- set if we have to write in register.
			writeEnable <= '1';
		else
			writeEnable <= '0';
		end if;
	end process p5;
end main_processor;
