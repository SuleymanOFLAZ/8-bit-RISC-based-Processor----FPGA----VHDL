library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_path is
    port(
        -- Inputs:
        clk         : in std_logic;
        reset       : in std_logic;
        IR_Load     : in std_logic; -- Load enable fo IR register
        MAR_Load    : in std_logic; -- Load enable for MAR register
        PC_Load     : in std_logic; -- Load enable for PC register
        PC_Inc      : in std_logic; -- Signal for increamenting by one the PC register
        A_Load      : in std_logic; -- Load enable for A register
        B_Load      : in std_logic; -- Load enable for B register
        ALU_Sel     : in std_logic_vector(2 downto 0); -- ALU Select signal
        CCR_Load    : in std_logic; -- Load enable for CCR register
        Bus1_Sel    : in std_logic_vector(1 downto 0); -- Select signal for Bus1 selecter MUX
        Bus2_Sel    : in std_logic_vector(1 downto 0); -- Select signal for Bus2 selecter MUX
        from_memory : in std_logic_vector(7 downto 0); -- 8-bit signal input from memory

        -- Outputs:
        to_memory   : out std_logic_vector(7 downto 0); -- 8-bit signal output to memory
        address     : out std_logic_vector(7 downto 0); -- 8-bit signal output from MAR to memory block
        IR          : out std_logic_vector(7 downto 0); -- 8-bit output from IR register to control unit
        CCR_Result  : out std_logic_vector(3 downto 0)  -- 3-bit NZVC resuts to control unit
    );
end entity;

architecture arch of data_path is
    -- ALU decleration as a component:
    component alu is
        port(	
            A 			: in std_logic_vector(7 downto 0); -- signed
            B 			: in std_logic_vector(7 downto 0); -- signed
            ALU_Sel 	: in std_logic_vector(2 downto 0); -- islem turu
            
            ALU_Result 	: out std_logic_vector(7 downto 0);
            NZVC		: out std_logic_vector(3 downto 0)
        
        );
        
        end component;
    -- Bus signal declerations:
    signal Bus1         : std_logic_vector(7 downto 0);
    signal Bus2         : std_logic_vector(7 downto 0);
    signal ALU_Result   : std_logic_vector(7 downto 0);
    signal NZVC         : std_logic_vector(3 downto 0);
    -- Register decleratians:
    signal IR_Register  : std_logic_vector(7 downto 0);
    signal MAR_Register : std_logic_vector(7 downto 0) := (others => '0');
    signal PC_Register  : std_logic_vector(7 downto 0) := (others => '0');
    signal A_Register   : std_logic_vector(7 downto 0) := (others => '0');
    signal B_Register   : std_logic_vector(7 downto 0) := (others => '0');
    signal CCR_Register : std_logic_vector(3 downto 0) := (others => '0');

begin

ALU_U : alu
    port map (
            A           => B_Register,
            B           => Bus1,
            ALU_Sel     => ALU_Sel,
            NZVC        => NZVC,
            ALU_Result  => ALU_Result
    );

-- Bus1_Mux:
Bus1 <= PC_Register when (Bus1_Sel = "00") else
      A_Register  when (Bus1_Sel = "01") else
      B_Register  when (Bus1_Sel = "10") else (others => '0');

-- Bus2_Mux:
Bus2 <= ALU_Result when (Bus2_Sel <= "00") else
         Bus1  when (Bus2_Sel <= "01") else
         from_memory  when (Bus2_Sel <= "10") else (others => '0');

-- IR Register
process(clk, reset)
begin
    if(reset = '1') then
        IR_Register  <= (others => '0');
    elsif(rising_edge(clk)) then
       if(IR_Load = '1') then
            IR_Register <= Bus2;
       end if;
    end if;
 end process;
IR <= IR_Register;

-- MAR Register
process(clk, reset)
begin
    if(reset = '1') then
        MAR_Register  <= (others => '0');
    elsif(rising_edge(clk)) then
        if(MAR_Load = '1') then
            MAR_Register <= Bus2;
        end if;
    end if;
end process;

address <= MAR_Register;

-- PC Register
process(clk, reset)
begin
    if(reset = '1') then
        PC_Register   <= (others => '0');
    elsif(rising_edge(clk)) then
        if(PC_Load = '1') then
            PC_Register <= Bus2;
        elsif(PC_Inc = '1') then
            PC_Register <= PC_Register + x"01";
        end if;
    end if;
end process;

-- A Register
process(clk, reset)
begin
    if(reset = '1') then
        A_Register    <= (others => '0');
    elsif(rising_edge(clk)) then
        if(A_Load = '1') then
            A_Register <= Bus2;
        end if;
    end if;
end process;

-- B Register
process(clk, reset)
begin
    if(reset = '1') then
        B_Register    <= (others => '0');
    elsif(rising_edge(clk)) then
        if(B_Load = '1') then
            B_Register <= Bus2;
        end if;
    end if;
end process;

-- CCR Register
process(clk, reset)
begin
    if(reset = '1') then
        CCR_Register <= (others => '0');
    elsif(rising_edge(clk)) then
        if(CCR_Load = '1') then
            CCR_Register <= NZVC;
        end if;
    end if;
end process;
CCR_Result <= CCR_Register;

to_memory <= Bus1 ;

end architecture;