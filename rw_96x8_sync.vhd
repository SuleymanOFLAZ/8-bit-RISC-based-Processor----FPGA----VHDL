--Bu kod 8-bit islemcinin data memory kismidir.

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_memory is
	port(
		address : in std_logic_vector (7 downto 0);
		data_in : in std_logic_vector (7 downto 0);
		write_en : in std_logic;
		clk : in std_logic;
		 -- Outputs:
		data_out : out std_logic_vector (7 downto 0)
		);
end entity;

Architecture arch of data_memory is

type rem_type is array (128 to 223) of std_logic_vector(7 downto 0); --96x8 bit
signal REM0 : rem_type := (others => x"00" );

signal enable : std_logic;
begin

process(address)
begin
	if(address >= x"80" and address <= x"DF") then --128 ile 223 araliginda ise
		enable <= '1';
	else
		enable <= '0';
	end if;
end process;

process(clk)
begin
	if(rising_edge(clk)) then
		if(enable = '1' and write_en = '1') then
			REM0(to_integer(unsigned(address))) <= data_in;
		elsif(enable = '1' and write_en = '0') then
			data_out <= REM0(to_integer(unsigned(address)));
		end if;
	end if;
end process;

end arch;