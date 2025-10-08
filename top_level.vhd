library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity topplevel is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Bouton_UP : in STD_LOGIC;
           Bouton_DOWN : in STD_LOGIC;
           Bouton_CENTER : in STD_LOGIC;
           Bouton_RIGHT : in STD_LOGIC;
           Bouton_LEFT : in STD_LOGIC;
           DP: out STD_LOGIC;
           Sept_Segments : out STD_LOGIC_VECTOR (6 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end topplevel;

architecture Behavioral of topplevel is


signal CE_perception : STD_LOGIC;
signal CE_affichage : STD_LOGIC;
signal VOLUME_UP: std_logic;
signal VOLUME_DW: std_logic;
signal sortiecpt_1_9: std_logic_vector(3 downto 0);

signal sortiemod8i : std_logic_vector(2 downto 0);

signal sortiecpt_1_599 : STD_LOGIC_VECTOR (9 downto 0);

signal Bouton_haut: STD_LOGIC;
signal Bouton_bas: STD_LOGIC;
signal Bouton_centre: STD_LOGIC;
signal Bouton_gauche: STD_LOGIC;
signal Bouton_droite: STD_LOGIC;

signal PLAY_PAUSE     :  std_logic;
signal RESTART        :  std_logic;
signal FORWARD        :  std_logic;        
signal sortie1        :  std_logic_vector(6 downto 0);
signal sortie2        :  std_logic_vector(6 downto 0);
signal sortie3        :  std_logic_vector(6 downto 0);
signal sortie4        :  std_logic_vector(6 downto 0);
signal S_uni_vol      : STD_LOGIC_VECTOR (6 downto 0);
signal S_uni          : STD_LOGIC_VECTOR (6 downto 0);
signal S_diz          :  STD_LOGIC_VECTOR (6 downto 0);
signal S_cent         :  STD_LOGIC_VECTOR (6 downto 0);

component gestion_freq
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       CE_perception : out STD_LOGIC;
       CE_affichage : out STD_LOGIC);
end component;

component detec_impulsion
Port ( clk : in STD_LOGIC;
       input: in STD_LOGIC;
       output : out STD_LOGIC);
end component;

component cpt_1_9
Port (
       rst: in std_logic;
       clk : in STD_LOGIC;
       incr: in std_logic;
       decr : in std_logic;
      
       sortiecpt_1_9: out std_logic_vector(3 downto 0));

end component;


component cpt_1_599
Port (    clk    : in  STD_LOGIC;
          rst    : in  STD_LOGIC;
          incr   : in STD_LOGIC;
          decr  : in STD_LOGIC;
          c_e    : in  STD_LOGIC;
          init  : in  STD_LOGIC;
          sortiecpt_1_599 : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component transcodeur
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
end component;

component FSM
Port ( clk: in std_logic;
       rst: in std_logic;
      
       B_UP: in std_logic;
       B_DOWN: in std_logic;
       B_CENTER: in std_logic;
       B_LEFT: in std_logic;
       B_RIGHT: in std_logic;
      
       PLAY_PAUSE: out std_logic;
       RESTART: out std_logic;
       FORWARD: out std_logic;
       VOLUME_UP: out std_logic;
       VOLUME_DW: out std_logic
       );
end component;

component mod8
Port (     clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           c_e : in STD_LOGIC;
           AN : out std_logic_vector(7 downto 0);
           smod8 : out std_logic_vector(2 downto 0));
end component;

component mux8
Port ( Commande : in STD_LOGIC_VECTOR (2 downto 0);
       E0 : in STD_LOGIC_VECTOR (6 downto 0);
       E1 : in STD_LOGIC_VECTOR (6 downto 0);
       E2 : in STD_LOGIC_VECTOR (6 downto 0);
       E3 : in STD_LOGIC_VECTOR (6 downto 0);
       E4 : in STD_LOGIC_VECTOR (6 downto 0);
       E5 : in STD_LOGIC_VECTOR (6 downto 0);
       E6 : in STD_LOGIC_VECTOR (6 downto 0);
       E7 : in STD_LOGIC_VECTOR (6 downto 0);
       DP: out STD_LOGIC;
       sortiemux8 : out STD_LOGIC_VECTOR (6 downto 0));
      
end component;

begin

gst_hrlg: gestion_freq
PORT MAP (clk => clk,
          rst => rst,
          CE_perception => CE_perception,
          CE_affichage => CE_affichage
          );

detec_UP : entity work.detec_impulsion
PORT MAP(
        clk   => clk,
        input => Bouton_UP,
        output => Bouton_haut
        );
detec_DOWN : entity work.detec_impulsion
PORT MAP(
        clk   => clk,
        input => Bouton_DOWN,
        output => Bouton_bas
        );
detec_LEFT : entity work.detec_impulsion
PORT MAP(
        clk   => clk,
        input => Bouton_LEFT,
        output => Bouton_gauche
        );
detec_RIGHT : entity work.detec_impulsion
PORT MAP(
        clk   => clk,
        input => Bouton_RIGHT,
        output => Bouton_droite
        );
detec_CENTER : entity work.detec_impulsion
PORT MAP(
        clk   => clk,
        input => Bouton_CENTER,
        output => Bouton_centre
        );
modulo: entity work.mod8
PORT MAP (clk => clk,
          rst => rst,
          c_e => CE_perception,
          smod8 => sortiemod8i,
          AN => AN
      
         );

multiplex: mux8
  PORT MAP (Commande =>sortiemod8i,
          E0 => S_uni_vol,
          E1 => S_cent,
          E2 => S_diz,
          E3 => S_uni,
          E4 => sortie1,
          E5 => sortie2,
          E6 => sortie3,
          E7 => sortie4,
          DP => DP,
          sortiemux8 => Sept_Segments);

transco: transcodeur
PORT MAP (nb_binaire => sortiecpt_1_599,
          nb_binaire_vol => sortiecpt_1_9,
          PLAY_PAUSE=> PLAY_PAUSE,
          RESTART=> RESTART,
          FORWARD=> FORWARD,
          sortie1=> sortie1,
          sortie2=> sortie2,
          sortie3=> sortie3,
          sortie4=> sortie4,
          S_uni_vol=> S_uni_vol,
          S_cent=> S_cent,
          S_diz => S_diz,
          S_uni=> S_uni
         );

machine: FSM
PORT MAP (clk => clk,
          rst => rst,
          B_UP=> Bouton_haut,
                B_DOWN=> Bouton_bas,
          B_CENTER=> Bouton_centre,
                 B_LEFT=> Bouton_gauche,
          B_RIGHT=> Bouton_droite,
                 PLAY_PAUSE => PLAY_PAUSE,
          RESTART=> RESTART,
          FORWARD=> FORWARD,
          VOLUME_UP=> VOLUME_UP,
          VOLUME_DW=> VOLUME_DW);
          

cpt1_9: cpt_1_9
  PORT MAP ( clk=>clk,
             rst=>rst,
             incr=> VOLUME_UP,
             decr => VOLUME_DW,
      
             sortiecpt_1_9=> sortiecpt_1_9);
cpt1_599: cpt_1_599
  PORT MAP ( clk  =>clk,
             rst  =>rst,
             incr   =>PLAY_PAUSE,
             decr  =>FORWARD,
             c_e    =>CE_affichage,
             init =>RESTART,
             sortiecpt_1_599 =>sortiecpt_1_599);


end Behavioral;