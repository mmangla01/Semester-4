-- Importing the required libraries
library IEEE;
use work.MyTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--------------------------------------------------------------------------------------------------------------------
-- desiging the ALU

-- entity definition
entity ALU is
    port (
        op1,op2: in word;           -- 2 operands 
        opc:in optype;              -- operation code
        cin: in std_logic;          -- carry in
        cout: out std_logic;        -- carry out 
        result: out word;            -- final output
        msb1, msb2 : out std_logic -- msb of the inputs 
    );   
end ALU;
-- implementing the architecture of ALU
architecture implement_alu of ALU is  
begin
    process(op1,op2,cin,opc)                            -- triggered by the change change in inputs
    variable temp: std_logic_vector(32 downto 0);       -- temporary variables
    variable tempop2: std_logic_vector(31 downto 0);
    variable tempop3: std_logic_vector(31 downto 0);
    variable tempop4: std_logic_vector(31 downto 0);
    begin
        tempop2 := (not op2) + 1;
        tempop3 := (not op2) + cin;
        tempop4 := op2 + cin;
        case(opc) is                                    -- case switches for operations
            when andop =>                          
            temp := (op1(31) & op1) and (op2(31) & op2);
            when eor => 
            temp := (op1(31) & op1) xor (op2(31) & op2);
            when sub => 
            temp := (op1(31) & op1) + (not (op2(31) & op2)) + 1;
            when rsb => 
            temp := (op2(31) & op2) + (not (op1(31) & op1)) + 1;
            when add => 
            temp := (op1(31) & op1) + (op2(31) & op2);
            when adc => 
            temp := (op1(31) & op1) + (op2(31) & op2) + cin;
            when sbc => 
            temp := (op1(31) & op1) + (not (op2(31) & op2)) + cin;
            when rsc => 
            temp := (op2(31) & op2) + (not (op1(31) & op1)) + cin;
            when tst =>                          
            temp := (op1(31) & op1) and (op2(31) & op2);
            when teq => 
            temp := (op1(31) & op1) xor (op2(31) & op2);
            when cmp => 
            temp := (op1(31) & op1) + (not (op2(31) & op2)) + 1;
            when cmn => 
            temp := (op1(31) & op1) + (op2(31) & op2);
            when orr =>
            temp := (op1(31) & op1) or (op2(31) & op2);
            when mov =>
            temp := op2(31) & op2;
            when bic => 
            temp := (op1(31) & op1) and (not (op2(31) & op2));
            when mvn =>
            temp := (not (op2(31) & op2));
            when others =>
            temp := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end case;
        result <= temp(31 downto 0);                        -- updating the result
        cout <= temp(32);                                   -- carry out
        case(opc) is
            when sub|rsb|cmp =>
            msb2 <= tempop2(31);                            -- updating the msb of operand2 for different conditions
            when sbc|rsc =>
            msb2 <= tempop3(31);
            when adc =>
            msb2 <= tempop4(31);
            when others =>
            msb2 <= op2(31);
        end case;
        msb1 <= op1(31);                                    -- msb of the operand1
    end process;                                            -- ending process
end implement_alu;                                          -- ending implementation

--------------------------------------------------------------------------------------------------------------------
-- designing the condition checker

-- entity definition 
entity ConditionChecker is 
    port (
        flags: in nibble;       -- input the flags
        cond: in nibble;        -- input condition that is to be checked
        is_true: out std_logic  -- if the condition is true 
    );
end ConditionChecker;
-- implementing the architcture of condition checker
architecture implement_cc of ConditionChecker is
begin
    process(flags,cond)         -- process on the change of flags or cond
    begin 
        if(                     -- check for the condition value and the corresponding flags
            (cond=0 and flags(2)="1") or
            (cond=1 and flags(2)="0") or
            (cond=2 and flags(1)="1") or
            (cond=3 and flags(1)="0") or
            (cond=4 and flags(3)="0") or
            (cond=5 and flags(3)="0") or
            (cond=6 and flags(0)="0") or
            (cond=7 and flags(0)="0") or
            (cond=8 and flags(2)="0" and flags(1)="1") or
            (cond=9 and flags(2)="1" and flags(1)="0") or
            (cond=10 and flags(3)=flags(0)) or
            (cond=11 and not(flags(3)=flags(0))) or
            (cond=12 and flags(2)="0" and flags(3)=flags(0)) or
            (cond=13 and flags(2)="1" and not(flags(3)=flags(0))) or
            (cond=14)
        ) then                  -- if they match then true is returned
            is_true <= "1";
        else                    -- else false is returned 
            is_true <= "0";
        end if;
    end process;
end implement_cc;

--------------------------------------------------------------------------------------------------------------------
-- designing the data memory 

-- entity definition 
entity DataMemory is 
    port(
        add: in std_logic_vector(5 downto 0);-- read and write addresses
        clk:in std_logic;          -- clock 
        data: in word;             -- input data
        wen: in nibble;             -- write enable
        dout: out word            -- output data 
    );
end DataMemory;
-- implementation of the architecture of data memory 
architecture implement_dm of DataMemory is 
    type mem is array (0 to 63) of word; -- mem array of data 
    signal memory: mem;                                     -- signal for the data in data memory
begin
    process(clk)                                            -- process with change in clock
    begin  
        -- calculate the index where the input data is to be written and write accordingly
        if(rising_edge(clk)) then                           -- if the rising edge of the clock then we do as write enables
            if wen= "0001" then 
                memory(to_integer(unsigned((add))))(7 downto 0) <= data(7 downto 0);
            elsif wen="0010" then 
                memory(to_integer(unsigned((add))))(15 downto 8) <= data(7 downto 0);
            elsif wen="0100" then 
                memory(to_integer(unsigned((add))))(23 downto 16) <= data(7 downto 0);
            elsif wen="1000" then 
                memory(to_integer(unsigned((add))))(31 downto 24) <= data(7 downto 0);
            elsif wen = "0011" then 
                memory(to_integer(unsigned((add))))(15 downto 0) <= data(15 downto 0);
            elsif wen = "1100" then 
                memory(to_integer(unsigned((add))))(31 downto 16) <= data(15 downto 0);
            elsif wen = "1111" then 
                memory(to_integer(unsigned((add)))) <= data ;
            end if;
        end if;
    end process;
    dout <= memory(to_integer(unsigned((add))));                     -- calculate the index that is to be read and read the data at that index
end implement_dm;

--------------------------------------------------------------------------------------------------------------------
-- designing the flags and associated circuit 

-- entity definition 
entity flags is 
    port (
        set: in std_logic;                  -- if the flags are to be set
        clock: in std_logic;                -- clock
        dp_class : in DP_subclass_type;     -- type of dp instruction
        is_shift: in std_logic;             -- if shift or not
        carry_from_alu: in std_logic;       -- the carry form alu
        carry_from_shift: in std_logic;     -- carry from shift
        msb1, msb2: std_logic;              -- msb of the operands
        result: in word;                    -- result from the ALU
        out_flags: out nibble               -- outputed value of flags
    );
end flags;
-- implementating the architecture of Flags
architecture implement_flags of flags is 
    signal local_flags: nibble;      -- N Z C V locally store the values of the flags 
begin 
    process(clock)                          -- on the process of the clock 
        variable temp: std_logic:=0;        -- initialized the temp variable as 0
        variable temp_flags: nibble;        -- temp flags that will update the values of output and local flags
    begin 
        for I in 0 to 31 loop               -- calculating the zero flag
            temp := temp or result(I);
        end loop;
        if (rising_edge(clock)) then        -- on rising edge of the clock
            -- check for different instructions and set value and update the required flags 
            if ((set = "1" and dp_class = arith) or (dp_class = comp) ) then 
                temp_flags(3) := result(31);
                temp_flags(2) := temp;
                temp_flags(1) := carry_from_result;
                temp_flags(0) := (msb1 and msb2 and (not result(31))) + ((not msb1) and (not msb2) and result(31));
            else
                if (set = "1" and is_shift = "1") then 
                    temp_flags(3) := result(31);
                    temp_flags(2) := temp;
                    temp_flags(1) := carry_from_shift;
                    temp_flags(0) := local_flags(0);
                elsif ((set = "1" and is_shift = "0") or dp_class = test) then
                    temp_flags(3) := result(31);
                    temp_flags(2) := temp;
                    temp_flags(1) := local_flags(1);
                    temp_flags(0) := local_flags(0);
                end if;
            end if;
            out_flags <= temp_flags;        -- set the output and local flags as the temp flags
            local_flags <= temp_flags;
        end if;
    end process;                            -- end the process
end implement_flags;                        -- end the implementation

--------------------------------------------------------------------------------------------------------------------
-- designing the instruction decoder

-- enitity definition
entity InstructionDecoder is 
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
end InstructionDecoder;
-- implementing the architecture of Instruction Decoder
architecture implement_id of InstructionDecoder is 
    type oparraytype is array (0 to 15) of optype;  -- the array of different operations
    constant oparray : oparraytype := (andop, eor, sub, rsb, add, adc, sbc, rsc, tst, teq, cmp, cmn, orr, mov, bic, mvn);
begin
    process (instruction)
        variable cond: nibble := instruction(31 downto 28);  -- variable condition
        variable F : std_logic_vector(1 downto 0):= instruction(27 downto 26);-- variable F
        variable I: std_logic:= instruction(25);     -- variable I
        variable opc: nibble:= instruction(24 downto 22);-- variable operation code
        variable S: std_logic:= instruction(20);     -- variable S 
    begin 
        if(F="00") then                 -- DP or multiplication instruction
            oper <= oparray(to_integer(unsigned(instruction(24 downto 21))));
            if(instruction(7 downto 4)=="1001") then -- multiplication instruction 
                ins_class<= mul;
            else                        -- else DP instruction
                ins_class<=DP;
            end if;
            if ( (opc="001") or (opc="010") or (opc="011") ) then   -- subclasses 
                dp_class <= arith;          -- arithematic (add/sub/rsb/adc/sbc/rsc)
            elsif ( (opc="000") or (opc="110") or (opc="111") ) then 
                dp_class <= logical;        -- logical (mov/mvn/and/orr/bic/eor)
            elsif (opc="101") then
                dp_class <= comp;           -- comparison (cmp/cmn)
            elsif (opc="100") then
                dp_class <= test;           -- test (tst/teq)
            else
                dp_class <= none;           -- else none 
            end if;
            if (I="0") then                 -- operand source is immidiate or register
                dp_operand_src <= reg;
            else
                dp_operand_src <= imm;
            end if;
        elsif(F="01") then                  -- DT instructions
            ins_class <= DT;
            if(instruction(20)="1") then
                ls <= load;                 -- if the L bit is 1 then load
            else
                ls <= store;                -- else store
            end if; 
            if(instruction(23)=="1") then    -- add/sub the offset
                dt_offset_sign <= plus;
            else
                dt_offset_sign <= minus;
            end if;
        elsif(F="10") then                  -- branch instruction
            ins_class <=BRN;
        else
            ins_class <= none;              -- if nothing then none
        end if;
    end process;
end implement_id;

--------------------------------------------------------------------------------------------------------------------
-- designing the Program Counter

-- entity definition 
entity ProgramCounter is 
    port (
        clock: in std_logic;                        -- clock
        offset: in std_logic_vector(23 downto 0);   -- the offset relative to pc
        branch: in std_logic                        -- whether to branch or not
        out_pc: out word;                           -- output pc
    );
end ProgramCounter;
-- implementing the Program Counter
architecture implement_pc of ProgramCounter is 
    signal pc: word:= (others => '0');              -- locally storing the value of pc
begin 
    process (clock)
        variable temp: word;
        variable off: word;
    begin 
        if(rising_edge(clock)) then 
            temp := pc;
            if(offset(23)="0") then
                off := "000000"&offset&"00";
            else 
                off := "111111"&offset&"00";
            end if;
            if(branch=1) then                       -- if we need to branch 
                temp := temp + off + 4;             -- then new pc
            else 
                temp := 4 + temp;                   -- if no branch instruction then increment of 4
            end if;
            pc <= temp;                             -- storing the pc locally 
            out_pc <= temp;                         -- and also outputing it for extracting the next instruction
        end if;
    end process;
end implement_pc;
                
--------------------------------------------------------------------------------------------------------------------
-- designing the program memory 

-- entity definition
entity ProgramMemory is 
    port(
        radd: in std_logic_vector(5 downto 0);             -- reading address 
        dout: out word           -- the data that is read
    );
end ProgramMemory;
-- implementing the architecture of program memory 
architecture implement_pm of ProgramMemory is 
    type mem is array (0 to 63) of word;
    -- mem is array of instruction in program memory
    signal memory: mem:= (
        0 => X"E3A0000A",
        1 => X"E3A01005",
        2 => X"E5801000",
        3 => X"E2811002",
        4 => X"E5801004",
        5 => X"E5902000",
        6 => X"E5903004",
        7 => X"E0434002", others => X"00000000"
    );
    -- ("00000000000000000000000000000000","00000000000000000000000000000001","00000000000000000000000000000010","00000000000000000000000000000011","00000000000000000000000000000100","00000000000000000000000000000101","00000000000000000000000000000110","00000000000000000000000000000111",
    -- "00000000000000000000000000001000","00000000000000000000000000001001","00000000000000000000000000001010","00000000000000000000000000001011","00000000000000000000000000001100","00000000000000000000000000001101","00000000000000000000000000001110","00000000000000000000000000001111",
    -- "00000000000000000000000000010000","00000000000000000000000000010001","00000000000000000000000000010010","00000000000000000000000000010011","00000000000000000000000000010100","00000000000000000000000000010101","00000000000000000000000000010110","00000000000000000000000000010111",
    -- "00000000000000000000000000011000","00000000000000000000000000011001","00000000000000000000000000011010","00000000000000000000000000011011","00000000000000000000000000011100","00000000000000000000000000011101","00000000000000000000000000011110","00000000000000000000000000011111",
    -- "00000000000000000000000000100000","00000000000000000000000000100001","00000000000000000000000000100010","00000000000000000000000000100011","00000000000000000000000000100100","00000000000000000000000000100101","00000000000000000000000000100110","00000000000000000000000000100111",
    -- "00000000000000000000000000101000","00000000000000000000000000101001","00000000000000000000000000101010","00000000000000000000000000101011","00000000000000000000000000101100","00000000000000000000000000101101","00000000000000000000000000101110","00000000000000000000000000101111",
    -- "00000000000000000000000000110000","00000000000000000000000000111001","00000000000000000000000000111010","00000000000000000000000000111011","00000000000000000000000000111100","00000000000000000000000000111101","00000000000000000000000000111110","00000000000000000000000000111111",
    -- "00000000000000000000000001000000","00000000000000000000000001000001","00000000000000000000000001000010","00000000000000000000000001000011","00000000000000000000000001000100","00000000000000000000000001000101","00000000000000000000000001000110","00000000000000000000000001000111");                                     -- signal that is accessing the instruction array
begin
    process(radd)                                           -- process on read address
    begin
        dout <= memory(to_integer(unsigned(radd)));                 -- getting the data at the given address
    end process;
end implement_pm;

--------------------------------------------------------------------------------------------------------------------
-- designing Register File

-- entity declaration
entity RegisterFile is 
    port (
        rad1, rad2, wad: in nibble;     -- read and write addresses
        data: in word;                  -- data that is to be written 
        wen,clk: in std_logic;          -- write enable and clock
        dout1,dout2: out word           -- data that is being read 
    );
end RegisterFile;
-- achitecture implementing the register file
architecture implement_rf of RegisterFile is
    type mem is array (0 to 15) of word;      
    -- defining a type that is array of 16 std_logic_vector (32 bits)
    signal memory: mem;                                     -- internal signal that is of mem type 
begin
    dout1 <= memory(to_integer(unsigned(rad1)));            -- reading the register and outputing the same 
    dout2 <= memory(to_integer(unsigned(rad2)));            -- without any intervention of clock
    process(clk)                                            -- process when clock or writing is triggered
    begin
        if (rising_edge(clk)) then                          -- at rising edge of the clock 
            if wen = '1' then                               -- and write enable set
                memory(to_integer(unsigned(wad))) <= data;  -- write the data to the register address
            end if;
        end if;
    end process;                                            -- end process
end implement_rf;                                           -- end implementation

--------------------------------------------------------------------------------------------------------------------
