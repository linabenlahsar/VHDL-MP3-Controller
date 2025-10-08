library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity transcodeur is
    port (
	        nb_binaire     : in STD_LOGIC_VECTOR(9 downto 0);
	        nb_binaire_vol : in STD_LOGIC_VECTOR(3 downto 0);
	        PLAY_PAUSE     : in std_logic;
            RESTART        : in std_logic;
            FORWARD        : in std_logic;        
            sortie1        : out std_logic_vector(6 downto 0);
            sortie2        : out std_logic_vector(6 downto 0);
            sortie3        : out std_logic_vector(6 downto 0);
            sortie4        : out std_logic_vector(6 downto 0);
            S_uni_vol      : out STD_LOGIC_VECTOR (6 downto 0);
            S_uni          : out STD_LOGIC_VECTOR (6 downto 0);
            S_diz          : out STD_LOGIC_VECTOR (6 downto 0);
            S_cent         : out STD_LOGIC_VECTOR (6 downto 0)
          );
end transcodeur;

architecture transcodeur_a of transcodeur is

signal nbre_binaire       : unsigned (9 downto 0);
signal nbre_binaire_diz   : unsigned (9 downto 0);
signal nbre_binaire_uni   : unsigned (9 downto 0);
signal val_cent           : unsigned (3 downto 0);
signal val_diz            : unsigned (3 downto 0);

signal val                : std_logic_vector(2 downto 0);

begin

    val(0) <= PLAY_PAUSE;
    val(1) <= RESTART;
    val(2) <= FORWARD;
    
aff : process(val)

        begin
				case val is
						when "010"  => sortie1  <= "0110001";
                                        sortie2  <= "1111110";
                                        sortie3  <= "1111110";
                                        sortie4  <= "0000111";
						when "001"  => sortie1  <= "0110001";
                                        sortie2  <= "1111110";
                                        sortie3  <= "1111110";
                                        sortie4  <= "1111110";	
                       when "101" =>    sortie1  <= "1111110";
                                        sortie2  <= "1111110";
                                        sortie3  <= "1111110";
                                        sortie4  <= "0000111";		
                        when others =>  sortie1  <= "1111110";
                                        sortie2  <= "1111110";
                                        sortie3  <= "1111110";
                                        sortie4  <= "1111110";
				end case;
		 end process aff;		


P_Trans_vol : process (nb_binaire_vol)

begin
		case nb_binaire_vol is
			when "0000" => S_uni_vol <= "0000001"; --0
			when "0001" => S_uni_vol <= "1001111"; --1
			when "0010" => S_uni_vol <= "0010010"; --2
		    when "0011" => S_uni_vol <= "0000110"; --3
			when "0100" => S_uni_vol <= "1001100"; --4
		    when "0101" => S_uni_vol <= "0100100"; --5		               
			when "0110" => S_uni_vol <= "0100000"; --6
			when "0111" => S_uni_vol <= "0001111"; --7
			when "1000" => S_uni_vol <= "0000000"; --8
			when "1001" => S_uni_vol <= "0000100"; --9
			when others => S_uni_vol <= "0000001"; --1
		end case;
 end process;               


nbre_binaire <= unsigned(nb_binaire);

P_Calcul_Centaine: process (nbre_binaire)

begin
		if    nbre_binaire < to_unsigned(100,10) then val_cent   <= to_unsigned(0,4); 
		elsif nbre_binaire < to_unsigned(200,10) then val_cent   <= to_unsigned(1,4); 
	    elsif nbre_binaire < to_unsigned(300,10) then val_cent   <= to_unsigned(2,4);  
	    elsif nbre_binaire < to_unsigned(400,10) then val_cent   <= to_unsigned(3,4); 
	    elsif nbre_binaire < to_unsigned(500,10) then val_cent   <= to_unsigned(4,4); 
	                                             else val_cent   <= to_unsigned(5,4); 
	    end if;
end Process;

P_Calcul_nb_Diz: process (val_cent, nbre_binaire)

begin
		case val_cent is
			when "0000" => nbre_binaire_diz <= nbre_binaire; 
			when "0001" => nbre_binaire_diz <= nbre_binaire - to_unsigned(100,9); 
			when "0010" => nbre_binaire_diz <= nbre_binaire - to_unsigned(200,9); 
		    when "0011" => nbre_binaire_diz <= nbre_binaire - to_unsigned(300,9); 
			when "0100" => nbre_binaire_diz <= nbre_binaire - to_unsigned(400,9); 
			when others => nbre_binaire_diz <= nbre_binaire - to_unsigned(500,9); 
		end case;
end Process;

P_Calcul_Dizaine: process (nbre_binaire_diz)

begin
		if    nbre_binaire_diz < to_unsigned(10,10) then val_diz   <= to_unsigned(0,4); 
		elsif nbre_binaire_diz < to_unsigned(20,10) then val_diz   <= to_unsigned(1,4); 
	    elsif nbre_binaire_diz < to_unsigned(30,10) then val_diz   <= to_unsigned(2,4);  
	    elsif nbre_binaire_diz < to_unsigned(40,10) then val_diz   <= to_unsigned(3,4); 
	    elsif nbre_binaire_diz < to_unsigned(50,10) then val_diz   <= to_unsigned(4,4); 
	    elsif nbre_binaire_diz < to_unsigned(60,10) then val_diz   <= to_unsigned(5,4); 
	    elsif nbre_binaire_diz < to_unsigned(70,10) then val_diz   <= to_unsigned(6,4);  
	    elsif nbre_binaire_diz < to_unsigned(80,10) then val_diz   <= to_unsigned(7,4); 
	    elsif nbre_binaire_diz < to_unsigned(90,10) then val_diz   <= to_unsigned(8,4); 
	                                                else val_diz   <= to_unsigned(9,4); 
	    end if;
end Process;

P_Calcul_nb_uni: process (val_diz, nbre_binaire_diz)

begin
		case val_diz is
			when "0000" => nbre_binaire_uni <= nbre_binaire_diz; 
			when "0001" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(10,9); 
			when "0010" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(20,9); 
		    when "0011" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(30,9); 
			when "0100" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(40,9); 
			when "0101" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(50,9);  
			when "0110" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(60,9); 
			when "0111" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(70,9); 
		    when "1000" => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(80,9); 		
            when others => nbre_binaire_uni <= nbre_binaire_diz - to_unsigned(90,9); 	
		end case;
end Process;

P_Calcul_S_Cent: process (val_cent)

begin
		case val_cent is
                          when to_unsigned(0,4) => S_cent <= "0000001"; --0
                          when to_unsigned(1,4) => S_cent <= "1001111"; --1
                          when to_unsigned(2,4) => S_cent <= "0010010"; --2
                          when to_unsigned(3,4) => S_cent <= "0000110"; --3
                          when to_unsigned(4,4) => S_cent <= "1001100"; --4
                          when others           => S_cent <= "0100100"; --5
        end case;  
end Process;

P_Calcul_S_diz: process (val_diz)

begin
		case val_diz is
                          when to_unsigned(0,4) => S_diz <= "0000001"; --0
                          when to_unsigned(1,4) => S_diz  <= "1001111"; --1
                          when to_unsigned(2,4) => S_diz  <= "0010010"; --2
                          when to_unsigned(3,4) => S_diz  <= "0000110"; --3
                          when to_unsigned(4,4) => S_diz  <= "1001100"; --4
                          when to_unsigned(5,4) => S_diz  <= "0100100"; --5
                          when to_unsigned(6,4) => S_diz  <= "0100000"; --6
                          when to_unsigned(7,4) => S_diz  <= "0001111"; --7
                          when to_unsigned(8,4) => S_diz  <= "0000000"; --8
                          when others            => S_diz  <= "0000100"; --9
        end case;  
end Process;

P_Calcul_S_uni: process (nbre_binaire_uni)

begin
		case nbre_binaire_uni is
                          when to_unsigned(0,10) => S_uni <= "0000001"; --0
                          when to_unsigned(1,10) => S_uni <= "1001111"; --1
                          when to_unsigned(2,10) => S_uni <= "0010010"; --2
                          when to_unsigned(3,10) => S_uni <= "0000110"; --3
                          when to_unsigned(4,10) => S_uni <= "1001100"; --4
                          when to_unsigned(5,10) => S_uni <= "0100100"; --5
                          when to_unsigned(6,10) => S_uni <= "0100000"; --6
                          when to_unsigned(7,10) => S_uni <= "0001111"; --7
                          when to_unsigned(8,10) => S_uni <= "0000000"; --8
                          when others => S_uni <= "0000100"; --
        end case;  
end Process;


end transcodeur_a;
