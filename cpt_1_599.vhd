library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpt_1_599 is
    Port (clk    : in  STD_LOGIC;
          rst    : in  STD_LOGIC;
          incr   : in STD_LOGIC;
          decr  : in STD_LOGIC;
          c_e    : in  STD_LOGIC;
          init  : in  STD_LOGIC;
          sortiecpt_1_599 : out STD_LOGIC_VECTOR (9 downto 0));
end cpt_1_599;

architecture Behavioral of cpt_1_599 is
    signal valeur_compteur : unsigned(9 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin

        if rising_edge(clk) then
            if rst = '1' then
                valeur_compteur <= to_unsigned(1, 10);
            elsif (c_e = '1') then
                if (init = '1') then 
                    valeur_compteur <= to_unsigned(1, 10);
                    
                elsif (incr = '1') then
                    if (decr = '1') then
                        if (valeur_compteur = 599) then
                            valeur_compteur <= to_unsigned(1,10);
                        else
                            valeur_compteur <= valeur_compteur + 1;
                        end if; 
                                            
                    else
                       if (valeur_compteur = 1) then
                            valeur_compteur <= to_unsigned(599,10);
                        else
                            valeur_compteur <= valeur_compteur - 1;
                        end if;
                    end if;
                        
                else
                    valeur_compteur <= valeur_compteur;                        
                end if;
            end if;
        end if;
    end process;

    sortiecpt_1_599 <= std_logic_vector(valeur_compteur);
end Behavioral;