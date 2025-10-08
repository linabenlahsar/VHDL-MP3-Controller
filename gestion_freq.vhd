library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gestion_freq is
PORT ( clk: in std_logic;
       rst: in std_logic;
      
       CE_affichage: out std_logic;
       CE_perception : out std_logic);
end gestion_freq;

Architecture Behavioral of gestion_freq is

signal cpt_affichage : natural range 0 to 10000000;
signal cpt_perception : natural range 0 to 33333;

begin

    gestion : process (clk, rst)
    begin
        if (rst= '1') then
                cpt_affichage <= 0;
                cpt_perception <= 0;
                CE_affichage <= '0';
                CE_perception <= '0';
        elsif ( clk'event and clk = '1') then
            if ( cpt_affichage = 9999999) then
                 cpt_affichage <= 0;
                 CE_affichage <= '1';
                 cpt_affichage <= cpt_affichage +1;
            else
                 cpt_affichage <= cpt_affichage +1;
                 CE_affichage <= '0';
            end if;
            
            if( cpt_perception = 33332) then
                 cpt_perception <= 0;
                 CE_perception <= '1';
                 cpt_perception <= cpt_perception +1;
            else
                 cpt_perception <= cpt_perception +1;
                 CE_perception <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
