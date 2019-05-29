library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std;

entity timer is
	port(
	clk, start : in std_logic;
	
	min : in std_logic_vector (3 downto 0);
	sec : in std_logic_vector (5 downto 0);
	
	sonido : out std_logic;
	
	--7 segmentos
	SsA, SsB, SsC : out std_logic_vector (6 downto 0)
	
	);
end timer;

architecture behaviour of timer is

component sec_splitter is 
	port(
	sec : in std_logic_vector (5 downto 0);
	
	dec: out std_logic_vector (3 downto 0);
	uni: out std_logic_vector (3 downto 0)
	);
end component;

component Timer_Prog is
	generic(n:integer:=27);
	port(
		k : in std_logic_vector(n-1 downto 0);
		CLK, RST : in std_logic ;
		Z : out std_logic
		);
end component;

component S_seg is 
	port(
	b : in std_logic_vector (3 downto 0);
	s : out std_logic_vector(6 downto 0)
	);
end component;

component FSM_timer is 
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
end component;

--Seniales para los displays
signal SigSB, SigSC : std_logic_vector (3 downto 0) := "0000";
--Cuando pasa un segundo
signal segPaso : std_logic := '0';
--Activar timer y el sonido
signal act_timer : std_logic := '0';
signal act_sonido : std_logic := '0';
--Senial de minutos y segundos
signal SMin : std_logic_vector (3 downto 0) := "0000";
signal SSec : std_logic_vector (5 downto 0) := "000000";

begin
	
	FSM : FSM_timer port map (start, clk, min, sec, segPaso, act_timer, act_sonido, SMin, SSec);
	-- 1 segundo = 001011101011101011101000000
	timeProg : Timer_Prog port map ("000000000000000000000000100", clk, act_timer, segPaso);
	splitter : sec_splitter port map (SSec, SigSB, SigSC);
	
	S_segA : S_seg port map (SMin, SsA);
	S_segB : S_seg port map (SigSB, SsB);
	S_segC : S_seg port map (SigSC, SsC);
	
	
end behaviour;