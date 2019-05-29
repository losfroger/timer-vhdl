library IEEE;
use IEEE.std_logic_1164.all;

entity S_seg is 
	port(
	b : in std_logic_vector (3 downto 0);
	s : out std_logic_vector(6 downto 0)
	);
end S_seg;

architecture behavior of S_seg is
begin
	process(b)
	begin
        case (b) is
            when "0000" => s<="1000000";
            when "0001" => s<="1111001";
            when "0010" => s<="0100100";
            when "0011" => s<="0110000";
            when "0100" => s<="0011001";
            when "0101" => s<="0010010";
            when "0110" => s<="0000010";
            when "0111" => s<="1111000";
            when "1000" => s<="0000000";
            when "1001" => s<="0011000";
            when others => s<="1111111";
    	end case;
		end process;
end behavior;
