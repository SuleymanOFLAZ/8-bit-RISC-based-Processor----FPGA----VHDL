library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity memory is
port (
		--inputs:
		address 	: in std_logic_vector(7 downto 0);
		data_in 	: in std_logic_vector(7 downto 0);
		write_en 	: in std_logic;
		clk 		: in std_logic;
		rst 		: in std_logic;
		
		--Outputs:
		data_out : out std_logic_vector(7 downto 0);
		
		--Input ports declerations (16x8-bit):
		port_in_00 : in std_logic_vector(7 downto 0);
		port_in_01 : in std_logic_vector(7 downto 0);
		port_in_02 : in std_logic_vector(7 downto 0);
		port_in_03 : in std_logic_vector(7 downto 0);
		port_in_04 : in std_logic_vector(7 downto 0);
		port_in_05 : in std_logic_vector(7 downto 0);
		port_in_06 : in std_logic_vector(7 downto 0);
		port_in_07 : in std_logic_vector(7 downto 0);
		port_in_08 : in std_logic_vector(7 downto 0);
		port_in_09 : in std_logic_vector(7 downto 0);
		port_in_10 : in std_logic_vector(7 downto 0);
		port_in_11 : in std_logic_vector(7 downto 0);
		port_in_12 : in std_logic_vector(7 downto 0);
		port_in_13 : in std_logic_vector(7 downto 0);
		port_in_14 : in std_logic_vector(7 downto 0);
		port_in_15 : in std_logic_vector(7 downto 0);
		
		--Output ports declerations (16x8-bit):
		port_out_00 : out std_logic_vector(7 downto 0);
		port_out_01 : out std_logic_vector(7 downto 0);
		port_out_02 : out std_logic_vector(7 downto 0);
		port_out_03 : out std_logic_vector(7 downto 0);
		port_out_04 : out std_logic_vector(7 downto 0);
		port_out_05 : out std_logic_vector(7 downto 0);
		port_out_06 : out std_logic_vector(7 downto 0);
		port_out_07 : out std_logic_vector(7 downto 0);
		port_out_08 : out std_logic_vector(7 downto 0);
		port_out_09 : out std_logic_vector(7 downto 0);
		port_out_10 : out std_logic_vector(7 downto 0);
		port_out_11 : out std_logic_vector(7 downto 0);
		port_out_12 : out std_logic_vector(7 downto 0);
		port_out_13 : out std_logic_vector(7 downto 0);
		port_out_14 : out std_logic_vector(7 downto 0);
		port_out_15 : out std_logic_vector(7 downto 0)
		
	);
end entity;



Architecture arch of memory is

component program_memory is
	port(
		address 	: in std_logic_vector (7 downto 0);
		clk 		: in std_logic;
		 -- Outputs:
		data_out 	: out std_logic_vector (7 downto 0)
	);
end component;

component data_memory is
	port(
		address 	: in std_logic_vector (7 downto 0);
		data_in 	: in std_logic_vector (7 downto 0);
		write_en 	: in std_logic;
		clk 		: in std_logic;
		 -- Outputs:
		data_out 	: out std_logic_vector (7 downto 0)
		);
end component;

component output_ports is
	port (
		address 	: in std_logic_vector(7 downto 0);
		data_in 	: in std_logic_vector(7 downto 0);
		write_en	: in std_logic;
		clk			: in std_logic;
		rst			: in std_logic;
		--Outputs:
		port_out_00 : out std_logic_vector(7 downto 0);
		port_out_01 : out std_logic_vector(7 downto 0);
		port_out_02 : out std_logic_vector(7 downto 0);
		port_out_03 : out std_logic_vector(7 downto 0);
		port_out_04 : out std_logic_vector(7 downto 0);
		port_out_05 : out std_logic_vector(7 downto 0);
		port_out_06 : out std_logic_vector(7 downto 0);
		port_out_07 : out std_logic_vector(7 downto 0);
		port_out_08 : out std_logic_vector(7 downto 0);
		port_out_09 : out std_logic_vector(7 downto 0);
		port_out_10 : out std_logic_vector(7 downto 0);
		port_out_11 : out std_logic_vector(7 downto 0);
		port_out_12 : out std_logic_vector(7 downto 0);
		port_out_13 : out std_logic_vector(7 downto 0);
		port_out_14 : out std_logic_vector(7 downto 0);
		port_out_15 : out std_logic_vector(7 downto 0)
		);
		
end component;


signal data_out_rom : std_logic_vector(7 downto 0);
signal data_out_rem : std_logic_vector(7 downto 0);
begin

--PORT MAPPING--

ROM_U : program_memory
	port map (
				address 	=> address,
				clk 		=> clk,
				data_out 	=> data_out_rom
			);
REM_U : data_memory
	port map (
				address 	=> address,
				data_in 	=> data_in,
				write_en 	=> write_en,
				clk 		=> clk,
				data_out 	=> data_out_rem
			);
OUT_U : output_ports
	port map (
				address 	=> address,
				data_in 	=> data_in,
				write_en 	=> write_en,
				clk 		=> clk,
				rst 		=> rst,
				--Output Ports--
				port_out_00 => port_out_00,
				port_out_01 => port_out_01,
				port_out_02 => port_out_02,
				port_out_03 => port_out_03,
				port_out_04 => port_out_04,
				port_out_05 => port_out_05,
				port_out_06 => port_out_06,
				port_out_07 => port_out_07,
				port_out_08 => port_out_08,
				port_out_09 => port_out_09,
				port_out_10 => port_out_10,
				port_out_11 => port_out_11,
				port_out_12 => port_out_12,
				port_out_13 => port_out_13,
				port_out_14 => port_out_14,
				port_out_15 => port_out_15
			);

process(address, data_out_rom, data_out_rem,
port_in_00, port_in_01, port_in_02, port_in_03, port_in_04, port_in_05, port_in_06, port_in_07, 
port_in_08, port_in_09, port_in_10, port_in_11, port_in_12, port_in_13, port_in_14, port_in_15 )
begin
        if(address >= x"00" and address <= x"7F") then  --taking data_out from rom--
                    data_out <= data_out_rom;
        elsif(address >= x"80" and address <= x"DF") then  --taking data_out from rem--
                    data_out <= data_out_rem;
        else --taking data_out from port_in_xx--
            case address is
                when x"F0" =>
                    data_out <= port_in_00;
                when x"F1" =>
                    data_out <= port_in_01;
                when x"F2" =>
                    data_out <= port_in_02;
                when x"F3" =>
                    data_out <= port_in_03;
                when x"F4" =>
                    data_out <= port_in_04;
                when x"F5" =>
                    data_out <= port_in_05;
                when x"F6" =>
                    data_out <= port_in_06;
                when x"F7" =>
                    data_out <= port_in_07;
                when x"F8" =>
                    data_out <= port_in_08;
                when x"F9" =>
                    data_out <= port_in_08;
                when x"FA" =>
                    data_out <= port_in_09;
                when x"FB" =>
                    data_out <= port_in_10;
                when x"FC" =>
                    data_out <= port_in_11;
                when  x"FD" =>
                    data_out <= port_in_12;
                when x"FE" =>
                    data_out <= port_in_13;
                when x"FF" =>
                    data_out <= port_in_14;
                when others =>
                    data_out <= (others => '0');
            end case;
        end if;
end process;

end architecture;





























