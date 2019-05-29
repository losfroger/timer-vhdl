library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sec_splitter is 
	port(
	sec : in std_logic_vector (5 downto 0);
	
	dec: out std_logic_vector (3 downto 0);
	uni: out std_logic_vector (3 downto 0)
	);
end sec_splitter;

architecture behavior of sec_splitter is
signal resta : std_logic_vector(5 downto 0) := "000000";
begin
	process(sec, resta)
	begin
		--Si excede los 59
		if (sec > "111011") then
			dec <= "0101";
			uni <= "1001";
		-- 49 < x < 60
		elsif (sec > "110001") then
			dec <= "0101";
			resta <= sec - "110010";
			uni <= resta(3 downto 0);
		
		-- 39 < x < 49
		elsif (sec > "100111") then
			dec <= "0100";
			resta <= sec - "101000";
			uni <= resta(3 downto 0);
		
		-- 29 < x < 39
		elsif (sec > "011101") then
			dec <= "0011";
			resta <= sec - "011110";
			uni <= resta(3 downto 0);
		
		-- 19 < x < 29
		elsif (sec > "010011") then
			dec <= "0010";
			resta <= sec - "010100";
			uni <= resta(3 downto 0);
			
		-- 9 < x < 19
		elsif (sec > "001001") then
			dec <= "0001";
			resta <= sec - "001010";
			uni <= resta(3 downto 0);
		-- 1 < x < 9
		elsif (sec > "000000") then
			dec <= "0000";
			resta <= sec;
			uni <= resta(3 downto 0);
		--0
		else
			dec <= "0000";
			uni <= "0000";
		end if;
	end process;
end behavior;