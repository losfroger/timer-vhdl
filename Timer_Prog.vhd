library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--1 segundo = "10111110101111000010000000"

--Timer programable, manda una senial cada que pasa el numero de iteraciones indicada
entity Timer_Prog is
port(
rst : in std_logic; --reset
clk : in std_logic; --reloj
number : std_logic_vector (25 downto 0);
s : out std_logic --Pulso del segundo
);
end Timer_Prog;

architecture simple of Timer_Prog is
	signal Qn, Qp : std_logic_vector (25 downto 0);
begin
	combinacional : process(Qp, number)
	begin
		if (Qp = "00000000000000000000000000") then
			s <= '1';
			Qn <= number;
		else
			s <= '0';
			Qn <= Qp - 1;
		end if;
	end process combinacional;

	secuencial : process(rst,clk, number)
	begin
		if (rst = '1') then
			Qp <= number;
		elsif (rising_edge(clk)) then
			Qp <= Qn;
		end if;
	end process secuencial;
end simple;
