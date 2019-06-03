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

signal minAuxB : std_logic_vector (3 downto 0) := "0000";
signal secAuxB : std_logic_vector (5 downto 0) := "000000";
														  

--signal restador : std_logic_vector (5 downto 0) := "000000";

begin
	process (Qp, min, sec, start, secPassed, secAuxB, minAuxB)
	begin
		case Qp is
		
			--Estado inicial
			when "0000" =>
			secAux <= sec;
			minAux <= min;
			
			act_timer <= '1';
			act_sonido <= '0';
			
			if (start = '0') then
				Qn <= "0001";
			else
				Qn <= Qp;
			end if;
				
			--Estado de conteo hacia abajo (segundos)
			when "0001" =>	
			act_timer <= '0';
			act_sonido <= '0';
			
			--Si pasa un segundo, restarle uno a los segundos
			if (secPassed = '1') then
				secAux <= secAuxB - '1';
			else
				secAux <= secAuxB;
				minAux <= minAuxB;
			end if;
			
			--Si los segundos estan en cero, ir al siguiente estado
			if (secAuxB = "000000") then
				Qn <= "0010";
			else
				Qn <= Qp;
			end if;
			
			--Resta minuto
			when "0010" =>
			act_timer <= '0';
			act_sonido <= '0';
			
			--Si los minutos y los segundos estan en cero significa que se acabo el tiempo
			--y se va al siguiente estado
			if (minAuxB = "0000") then
				if (secAuxB = "000000") then
					Qn <= "0011";
				end if;
			else
				Qn <= Qp;
			end if;
			
			--Pero si no, solamente se le resta uno a los minutos
			--y se ponen los segundos en 59
			if (secPassed = '1') then
				minAux <= minAuxB - '1';
				secAux <= "111011";
				Qn <= "0001";
			else
				secAux <= secAuxB;
				minAux <= minAuxB;
				
			end if;
			
			--Sonar por dos segundos
			when "0011" =>
			act_timer <= '0';
			act_sonido <= '1'; --Activar el sonido
			--Si pasa un segundo, pasar al siguiente estado (seguir sonando)
			if (secPassed = '1') then
				Qn <= "0100";
			else
				Qn <= "0011";
			end if;
			
			when "0100" =>
			act_timer <= '0';
			act_sonido <= '1'; --Activar sonido
			--Al pasar otro segundo, regresar al estado inicial
			if (secPassed = '1') then
				Qn <= "0000";
			else
				Qn <= "0100";
			end if;
			
			--Default
			when others =>
			Qn <= "0000";
			act_timer <= '1';
			act_sonido <= '0';	
			end case;
	end process;
	process(clk, Qn, minAux , secAux)
	begin
		if (rising_edge(CLK)) then
			Qp <= Qn;
			minAuxB <= minAux;
			secAuxB <= secAux;
			min_out <= minAux;
			sec_out <= secAux;
		else
		
		end if;
	end process;
	
end behavior;