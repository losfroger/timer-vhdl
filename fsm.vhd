library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity FSM_timer is 
	port(
	start : in std_logic;
	clk : in std_logic;
	--Entrada minutos y segundo
	min : in std_logic_vector (3 downto 0);
	sec : in std_logic_vector (5 downto 0);
	--Se activa cada segundo que pasa
	secPassed : in std_logic;
	--Salidas
	act_timer : out std_logic;
	act_sonido : out std_logic;
	min_out : out std_logic_vector (3 downto 0);
	sec_out : out std_logic_vector (5 downto 0)
	);
end FSM_timer;

architecture behavior of FSM_timer is

signal Qn, Qp : std_logic_vector(3 downto 0) := "0000";
signal minAux : std_logic_vector (3 downto 0) := "0000";
signal secAux : std_logic_vector (5 downto 0) := "000000";

--signal restador : std_logic_vector (5 downto 0) := "000000";

begin
	process (Qp, min, sec, start, secPassed)
	begin
		--restador <= (secAux - '1');
		case Qp is
			--Estado inicial
			when "0000" =>
			secAux <= sec;
			minAux <= min;
			
			act_timer <= '1';
			act_sonido <= '1';
			
			if (start = '0') then
				Qn <= "0001";
			else
				Qn <= Qp;
			end if;
				
			--Estado de conteo hacia abajo (segundos)
			when "0001" =>	
			act_timer <= '0';
			act_sonido <= '1';
			
			if (secPassed = '1') then
				secAux <= secAux - "000001";
			else
				secAux <= secAux;
			end if;
			
			if (secAux = "000000") then
				Qn <= "0010";
			else
				Qn <= Qp;
			end if;
			
			when "0010" =>
			act_timer <= '0';
			act_sonido <= '1';
			
			--Se acabo el tiempo
			if (minAux = "000000" and secAux = "000000") then
				Qn <= "0011";
			else
				minAux <= minAux - "0001";
				secAux <= "111011";
				Qn <= "0001";
			end if;
			
			when "0011" =>
			act_timer <= '1';
			act_sonido <= '0';
			
			
			when others =>
			Qn <= "0000";
			act_timer <= '1';
			act_sonido <= '1';	
			end case;
			
	end process;
	process(clk, Qn)
	begin
		if (rising_edge(CLK)) then
			Qp <= Qn;
		else
		
		end if;
	end process;
	min_out <= minAux;
	sec_out <= secAux;
end behavior;