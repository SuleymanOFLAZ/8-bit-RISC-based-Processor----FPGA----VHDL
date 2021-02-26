library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
    port(
        --inputs:
        clk             : in std_logic;
        reset           : in std_logic;
        IR              : in std_logic_vector(7 downto 0);
        CRR_Result     : in std_logic_vector(3 downto 0);

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
end entity;

architecture arcf of control_unit is

    type state_type is (
                        S_FETCH_0, S_FETCH_1, S_FETCH_2, S_DECODE_3,
                        S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
                        S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,
                        S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
                        S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,
                        S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7,
                        S_STB_DIR_4, S_STB_DIR_5, S_STB_DIR_6, S_STB_DIR_7,
                        S_ADD_AB_4,
                        S_SUB_AB_4,
                        S_AND_AB_4,
                        S_OR_AB_4,
                        S_INCA_4,
                        S_INCB_4,
                        S_DECA_4,
                        S_DECB_4,
                        S_BR_4, S_BR_5, S_BR_6, S_BR_7,
    );
    signal current_state, next_state : state_type;

    -- Tum Komutlar:

-- Kaydet/Yukle Komutlari
constant YUKLE_A_SBT	: std_logic_vector(7 downto 0) := x"86";
constant YUKLE_A		: std_logic_vector(7 downto 0) := x"87";
constant YUKLE_B_SBT	: std_logic_vector(7 downto 0) := x"88";
constant YUKLE_B		: std_logic_vector(7 downto 0) := x"89";
constant KAYDET_A		: std_logic_vector(7 downto 0) := x"96";
constant KAYDET_B		: std_logic_vector(7 downto 0) := x"97";
--ALU Komutlari
constant TOPLA_AB		: std_logic_vector(7 downto 0) := x"42";
constant CIKAR_AB		: std_logic_vector(7 downto 0) := x"43";
constant AND_AB			: std_logic_vector(7 downto 0) := x"44";
constant OR_AB			: std_logic_vector(7 downto 0) := x"45";
constant ARTIR_A		: std_logic_vector(7 downto 0) := x"46";
constant ARTIR_B		: std_logic_vector(7 downto 0) := x"47";
constant DUSUR_A		: std_logic_vector(7 downto 0) := x"48";
constant DUSUR_B		: std_logic_vector(7 downto 0) := x"49";
--Atlama Komutlari (Kosullu/Kosulsuz)
constant ATLA					: std_logic_vector(7 downto 0) := x"20";
constant ATLA_NEGATIFSE			: std_logic_vector(7 downto 0) := x"21";
constant ATLA_POZITIFSE			: std_logic_vector(7 downto 0) := x"22";
constant ATLA_ESITSE_SIFIR		: std_logic_vector(7 downto 0) := x"23";
constant ATLA_DEGILSE_SIFIR		: std_logic_vector(7 downto 0) := x"24";
constant ATLA_OVERFLOW_VARSA	: std_logic_vector(7 downto 0) := x"25";
constant ATLA_OVERFLOW_YOKSA	: std_logic_vector(7 downto 0) := x"26";
constant ATLA_ELDE_VARSA		: std_logic_vector(7 downto 0) := x"27";
constant ATLA_ELDE_YOKSA		: std_logic_vector(7 downto 0) := x"28";

begin

--Current State Logic
process(clk, reset)
begin
if(reset = '1') then
    current_state <= S_FETCH_0;
elsif(rising_edge(clk)) then
    current_state <= next_state;
end if;
end process;

-- Next State Logic
process(current_state, IR, CCR_Result)
begin
    case current_state is
            when S_FETCH_0 =>
                next_state <= S_FETCH_1;
            when S_FETCH_1 =>
                next_state <= S_FETCH_2;
            when S_FETCH_2 =>
                next_state <= S_DECODE_3;
            when S_DECODE_3 =>
                if(IR = YUKLE_A_SBT) then
                    next_state <= S_LDA_IMM_4;
                elsif(IR = YUKLE_B_SBT) then
                    next_state <= S_LDB_IMM_4;
                elsif(IR = YUKLE_A) then
                    next_state <= S_LDA_DIR_4;
                elsif(IR = YUKLE_B) then
                    next_state <= S_LDB_DIR_4;
                elsif(IR = KAYDET_A) then
                    next_state <= S_STA_DIR_4;
                elsif(IR = KAYDET_B) then
                    next_state <= S_STB_DIR_4;
                elsif(IR = TOPLA_AB) then
                    next_state <= S_ADD_AB_4;
                elsif(IR = CIKAR_AB) then
                    next_state <= S_SUB_AB_4;
                elsif(IR = AND_AB) then
                    next_state <= S_AND_AB_4;
                elsif(IR = OR_AB) then
                    next_state <= S_OR_AB_4;
                elsif(IR = ARTIR_A) then
                    next_state <= S_INCA_4;
                elsif(IR = ARTIR_B) then
                    next_state <= S_INCB_4;
                elsif(IR = DUSUR_A) then
                    next_state <= S_DECA_4;
                elsif(IR = DUSUR_B) then
                    next_state <= S_DECB_4;
                elsif(IR = ATLA) then
                    next_state <= S_BR_4;
                elsif(IR = ATLA_NEGATIFSE) then
                    if(CCR_Result(3)= '1') then  --NZVC
                        next_state <= S_BR_4;
                    else -- N=0
                        next_state <= S_BR_7;
                    end if;
                elsif(IR = ATLA_POZITIFSE) then
                    if(CCR_Result(3)= '0') then  --NZVC
                        next_state <= S_BR_4;
                    else -- N=1
                        next_state <= S_BR_7;
                    end if;
                elsif(IR = ATLA_ESITSE_SIFIR) then
                    if(CCR_Result(2)= '1') then  --NZVC
                        next_state <= S_BR_4;
                    else -- Z=0
                        next_state <= S_BR_7;
                    end if;
                elsif(IR = ATLA_DEGILSE_SIFIR) then
                    if(CCR_Result(2)= '0') then  --NZVC
                        next_state <= S_BR_4;
                    else -- Z=1
                        next_state <= S_BR_7;
                    end if;
                elsif(IR = ATLA_OVERFLOW_VARSA) then
                    if(CCR_Result(1)= '1') then  --NZVC
                        next_state <= S_BR_4;
                    else -- V=0
                        next_state <= S_BR_7;
                    end if;
                elsif(IR = ATLA_OVERFLOW_YOKSA) then
                    if(CCR_Result(1)= '0') then  --NZVC
                        next_state <= S_BR_4;
                    else -- V=1
                        next_state <= S_BR_7;
                    end if;
                elsif(IR = ATLA_ELDE_VARSA) then
                    if(CCR_Result(0)= '1') then  --NZVC
                        next_state <= S_BR_4;
                    else -- C=0
                            next_state <= S_BR_7;
                    end if;
                elsif(IR = ATLA_ELDE_YOKSA) then
                    if(CCR_Result(0)= '0') then  --NZVC
                            next_state <= S_BR_4;
                    else -- C=1
                            next_state <= S_BR_7;
                    end if;
                else
                    next_state <= S_FETCH_0;
                end if;
----------------------------------------------------------------YUKLE_A_SBT
            when S_LDA_IMM_4 =>
                next_state <= S_LDA_IMM_5;
            when S_LDA_IMM_5 =>
                next_state <= S_LDA_IMM_6;
            when S_LDA_IMM_6 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------YUKLE_B_SBT
            when S_LDB_IMM_4 =>
                next_state <= S_LDB_IMM_5;
            when S_LDB_IMM_5 =>
                next_state <= S_LDB_IMM_6;
            when S_LDB_IMM_6 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------YUKLE_A
            when S_LDA_DIR_4 =>
                next_state <= S_LDA_DIR_5;
            when S_LDA_DIR_5 =>
                next_state <= S_LDA_DIR_6;
            when S_LDA_DIR_6 =>
                next_state <= S_LDA_DIR_7;
            when S_LDA_DIR_7 =>
                next_state <= S_LDA_DIR_8;
            when S_LDA_DIR_8 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------YUKLE_B
            when S_LDB_DIR_4 =>
                next_state <= S_LDB_DIR_5;
            when S_LDB_DIR_5 =>
                next_state <= S_LDB_DIR_6;
            when S_LDB_DIR_6 =>
                next_state <= S_LDB_DIR_7;
            when S_LDB_DIR_7 =>
                next_state <= S_LDB_DIR_8;
            when S_LDB_DIR_8 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------KAYDET_A
            when S_STA_DIR_4 =>
                next_state <= S_STA_DIR_5;
            when S_STA_DIR_5 =>
                next_state <= S_STA_DIR_6;
            when S_STA_DIR_6 =>
                next_state <= S_STA_DIR_7;
            when S_STA_DIR_7 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------KAYDET_B
            when S_STB_DIR_4 =>
                next_state <= S_STB_DIR_5;
            when S_STB_DIR_5 =>
                next_state <= S_STB_DIR_6;
            when S_STB_DIR_6 =>
                next_state <= S_STB_DIR_7;
            when S_STB_DIR_7 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------TOPLA_AB
            when S_ADD_AB_4 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------CIKAR_AB
            when S_SUB_AB_4 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------AND_AB
            when S_AND_AB_4 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------OR_AB
            when S_OR_AB_4 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------ARTIR_A
            when S_INCA_4 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------ARTIR_B
            when S_INCB_4 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------DUSUR_A
            when S_DECA_4 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------DUSUR_B
            when S_DECB_4 =>
                next_state <= S_FETCH_0;
---------------------------------------------------------------- ATLA
            when S_BR_4 =>
                next_state <= S_BR_5;
            when S_BR_5 =>
                next_state <= S_BR_6;
            when S_BR_6 =>
                next_state <= S_FETCH_0;
            when S_BR_7 =>
                next_state <= S_FETCH_0;
----------------------------------------------------------------
            when others =>
                next_state <= S_FETCH_0;
    end case;
end process;

-- Output Logic
process(current_state)
begin
    -- reset signals
    IR_Load <= '0';
    MAR_Load <= '0';
    PC_Load <= '0';
    PC_Inc <= '0';
    A_Load <= '0';
    B_Load <= '0';
    ALU_Sel <= (others => '0');
    CCR_Load <= '0';
    Bus2_Sel <= (others => '0');
    Bus1_Sel <= (others => '0');
    Write_en <= '0';

    case current_state is
        when S_FETCH_0 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_FETCH_1 =>
            PC_Inc <= '1';
        when S_FETCH_2 =>
            Bus2_Sel <= "10"; -- from_memory
            IR_Load <= '1';
        when S_DECODE_3 =>
            -- already updating in Next State Logic
----------------------------------------------------------------YUKLE_A_SBT
        when S_LDA_IMM_4 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_LDA_IMM_5 =>
            PC_Inc <= '1';
        when S_LDA_IMM_6 =>
            Bus2_Sel <= "10"; -- from_memory
            A_Load <= '1';
----------------------------------------------------------------YUKLE_B_SBT
        when S_LDB_IMM_4 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_LDB_IMM_5 =>
            PC_Inc <= '1';
        when S_LDB_IMM_6 =>
            Bus2_Sel <= "10"; -- from_memory
            A_Load <= '1';
----------------------------------------------------------------YUKLE_A
        when S_LDA_DIR_4 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_LDA_DIR_5 =>
            PC_Inc <= '1';
        when S_LDA_DIR_6 =>
            Bus2_Sel <= "10"; -- from_memory
            MAR_Load <= '1';
        when S_LDA_DIR_7 =>
            
        when S_LDA_DIR_8 =>
            Bus2_Sel <= "10"; -- from_memory
            A_Load <= '1';
----------------------------------------------------------------YUKLE_B
        when S_LDB_DIR_4 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_LDB_DIR_5 =>
            PC_Inc <= '1';
        when S_LDB_DIR_6 =>
            Bus2_Sel <= "10"; -- from_memory
            MAR_Load <= '1';
        when S_LDB_DIR_7 =>
            
        when S_LDB_DIR_8 =>
            Bus2_Sel <= "10"; -- from_memory
            B_Load <= '1';
----------------------------------------------------------------KAYDET_A
        when S_STA_DIR_4 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_STA_DIR_5 =>
            PC_Inc <= '1';
        when S_STA_DIR_6 =>
            Bus2_Sel <= "10"; -- from_memory
            MAR_Load <= '1';
        when S_STA_DIR_7 =>
            Bus1_Sel <= "01"; -- A_Reg
            Write_en <= '1';
----------------------------------------------------------------KAYDET_B
        when S_STB_DIR_4 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_STB_DIR_5 =>
            PC_Inc <= '1';
        when S_STB_DIR_6 =>
            Bus2_Sel <= "10"; -- from_memory
            MAR_Load <= '1';
        when S_STB_DIR_7 =>
            Bus1_Sel <= "10"; -- B_Reg
            Write_en <= '1';
----------------------------------------------------------------TOPLA_AB
        when S_ADD_AB_4 =>
            Bus1_Sel <= "01"; -- A_Reg
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "000"; -- Toplama
            A_Load <= '1';
            CCR_Load <= '1';
----------------------------------------------------------------CIKAR_AB
        when S_SUB_AB_4 =>
            Bus1_Sel <= "01"; -- A_Reg
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "001"; -- Cıkarma
            A_Load <= '1';
            CCR_Load <= '1';
----------------------------------------------------------------AND_AB
        when S_AND_AB_4 =>
            Bus1_Sel <= "01"; -- A_Reg
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "010"; -- AND
            A_Load <= '1';
            CCR_Load <= '1';
----------------------------------------------------------------OR_AB
        when S_OR_AB_4 =>
            Bus1_Sel <= "01"; -- A_Reg
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "011"; -- OR
            A_Load <= '1';
            CCR_Load <= '1';
----------------------------------------------------------------ARTIR_A
        when S_INCA_4 =>
            Bus1_Sel <= "01"; -- A_Reg
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "100"; -- INCA
            A_Load <= '1';
            CCR_Load <= '1';
----------------------------------------------------------------ARTIR_B
        when S_INCB_4 =>
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "101"; -- INCB
            B_Load <= '1';
            CCR_Load <= '1';
----------------------------------------------------------------DUSUR_A
        when S_DECA_4 =>
            Bus1_Sel <= "01"; -- A_Reg
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "110"; -- DECA
            A_Load <= '1';
            CCR_Load <= '1';
----------------------------------------------------------------DUSUR_B
        when S_DECB_4 =>
            Bus1_Sel <= "01"; -- A_Reg
            Bus2_Sel <= "00"; -- ALU_Result
            ALU_Sel <= "111"; -- DECb
            b_Load <= '1';
            CCR_Load <= '1';
---------------------------------------------------------------- ATLA
        when S_BR_4 =>
            Bus1_Sel <= "00"; -- PC
            Bus2_Sel <= "01"; -- Bus1
            MAR_Load <= '1';
        when S_BR_5 =>
            
        when S_BR_6 =>
            Bus2_Sel <= "10"; -- from_memory
            PC_Load <= '1';
        -- Sartli atalama saglanmiyorsa
        when S_BR_7 =>
            PC_Inc <= '1';
----------------------------------------------------------------
        when others =>
            next_state <= S_FETCH_0;
end case;

end process;

end architecture;