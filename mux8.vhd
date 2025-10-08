library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux8 is
    Port ( Commande : in STD_LOGIC_VECTOR (2 downto 0);
           E0 : in STD_LOGIC_VECTOR (6 downto 0);
           E1 : in STD_LOGIC_VECTOR (6 downto 0);
           E2 : in STD_LOGIC_VECTOR (6 downto 0);
           E3 : in STD_LOGIC_VECTOR (6 downto 0);
           E4 : in STD_LOGIC_VECTOR (6 downto 0);
           E5 : in STD_LOGIC_VECTOR (6 downto 0);
           E6 : in STD_LOGIC_VECTOR (6 downto 0);
           E7 : in STD_LOGIC_VECTOR (6 downto 0);
           sortiemux8 : out STD_LOGIC_VECTOR (6 downto 0);
           DP: out STD_LOGIC);
end mux8;

architecture Behavioral of mux8 is

begin

    process (Commande, E0, E1, E2, E3, E4, E5, E6, E7)
    begin
        case commande is
            when "000" => sortiemux8<= E0; DP <= '0';
            when "001" => sortiemux8 <= E1; DP <= '1';
            when "010" => sortiemux8 <= E2; DP <= '1';
            when "011" => sortiemux8 <= E3; DP <= '1';
            when "100" => sortiemux8 <= E4; DP <= '1';
            when "101" => sortiemux8 <= E5; DP <= '1';
            when "110" => sortiemux8 <= E6; DP <= '1';
            when others=> sortiemux8 <= E7; DP <= '1';
        end case;
    end process;
    
end Behavioral;