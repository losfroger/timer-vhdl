library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--"001011101011101011101000000"


entity Timer_Prog is
generic(n:integer:=27);
port(
k : in std_logic_vector(n-1 downto 0);
CLK, RST : in std_logic ;
Z : out std_logic
);
end Timer_Prog;

architecture simple of Timer_Prog is
	signal Qp,Qn,aux : unsigned(n-1 downto 0);
	signal ze : std_logic;
begin
	aux<=(others=>'0');
	process(Qp,Qn,ze)
	begin
		if(ze='1')then
		Qn<=unsigned(k);
		else
		Qn <= Qp-1;
		end if;

		if(Qp=aux) then
		ze<='1';
		Z<='1';
		else
		ze<='0';
		Z<='0';
		end if;
		
		--Q<=std_logic_vector(Qp);
	end process;

	--Codigo de registro
	process(CLK,RST)
	begin
		if(RST='0')then
			Qp<=(others=>'0');
		elsif rising_edge(CLK)then
			Qp<=Qn;
			end if;
	end process;
	
end simple;