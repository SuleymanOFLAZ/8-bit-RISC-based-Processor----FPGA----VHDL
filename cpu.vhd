library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cpu is
    port(
        -- Inputs:
        clk         : in std_logic;
        reset       : in std_logic;
        from_memory : in std_logic_vector(7 downto 0);
        
        -- Outputs:
        write_en    : out std_logic;
        to_memory   : out std_logic_vector(7 downto 0);
        address     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture arch of cpu is
    component control_unit is
        port(
            --inputs:
            clk             : in std_logic;
            reset           : in std_logic;
            IR              : in std_logic_vector(7 downto 0);
            CCR_Result      : in std_logic_vector(3 downto 0);
    
            --Outpust:
            IR_Load         : out std_logic;
            MAR_Load        : out std_logic;
            PC_Load         : out std_logic;
            PC_Inc          : out std_logic;
            A_Load          : out std_logic;
            B_Load          : out std_logic;
            ALU_Sel         : out std_logic_vector(2 downto 0);
            CCR_Load        : out std_logic;
            Bus2_Sel        : out std_logic_vector(1 downto 0);
            Bus1_Sel        : out std_logic_vector(1 downto 0);
            Write_en        : out std_logic
        );
    end component;

    component data_path is
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
    end component;

signal IR              : std_logic_vector(7 downto 0);
signal CCR_Result      : std_logic_vector(3 downto 0);
signal IR_Load         : std_logic;
signal MAR_Load        : std_logic;
signal PC_Load         : std_logic;
signal PC_Inc          : std_logic;
signal A_Load          : std_logic;
signal B_Load          : std_logic;
signal ALU_Sel         : std_logic_vector(2 downto 0);
signal CCR_Load        : std_logic;
signal Bus2_Sel        : std_logic_vector(1 downto 0);
signal Bus1_Sel        : std_logic_vector(1 downto 0);

begin

Control_Unit_u : control_unit
            port map (
                clk         => clk ,
                reset       => reset ,
                IR          => IR ,
                CCR_Result => CCR_Result ,
                IR_Load     => IR_Load ,
                MAR_Load    => MAR_Load ,
                PC_Load     => PC_Load ,
                PC_Inc      => PC_Inc ,
                A_Load      => A_Load ,
                B_Load      => B_Load ,
                ALU_Sel     => ALU_Sel ,
                CCR_Load    => CCR_Load ,
                Bus2_Sel    => Bus2_Sel ,
                Bus1_Sel    => Bus1_Sel ,
                Write_en    => write_en
            );

Data_Path_u : data_path 
            port map (
                clk         => clk ,
                reset       => reset ,
                IR_Load     => IR_Load ,
                MAR_Load    => MAR_Load ,
                PC_Load     => PC_Load ,
                PC_Inc      => PC_Inc ,
                A_Load      => A_Load ,
                B_Load      => B_Load ,
                ALU_Sel     => ALU_Sel ,
                CCR_Load    => CCR_Load ,
                Bus1_Sel    => Bus1_Sel ,
                Bus2_Sel    => Bus2_Sel ,
                from_memory => from_memory ,
                to_memory   => to_memory ,
                address     => address ,
                IR          => IR ,
                CCR_Result  => CCR_Result
                    );

end architecture;