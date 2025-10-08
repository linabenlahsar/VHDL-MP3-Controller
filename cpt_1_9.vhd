library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity cpt_1_9 is
PORT ( clk: in std_logic;
       rst: in std_logic;
      
       incr: in std_logic;
       decr : in std_logic;
      
       sortiecpt_1_9: out std_logic_vector(3 downto 0) := "0101");
end cpt_1_9;

Architecture Behavioral of cpt_1_9 is

signal sortiecompteur19 : unsigned(3 downto 0);
begin
     compteur_1_9 : process( clk,rst )
     begin
          if ( clk'event and clk = '1') then
              if (rst = '1') then
                sortiecompteur19 <= to_unsigned(5,4);
              elsif ( incr = '1') then
                  if ( sortiecompteur19 = to_unsigned(9,4)) then
                      sortiecompteur19 <= sortiecompteur19;
                  else
                      sortiecompteur19 <= sortiecompteur19 + 1;
                  end if;
              elsif (decr = '1') then
                  if (sortiecompteur19 = to_unsigned(1,4)) then
                      sortiecompteur19 <= sortiecompteur19;
                  else
                       sortiecompteur19 <= sortiecompteur19 - 1;
                  end if;
              end if;
           end if;
   end process;
 
 sortiecpt_1_9 <= std_logic_vector(sortiecompteur19); 
       
end Behavioral;