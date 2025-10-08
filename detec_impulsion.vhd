library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity detec_impulsion is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end detec_impulsion;

architecture Behavioral of detec_impulsion is

signal temp : std_logic;

begin

process (clk)
    begin
    if (clk' event and clk='1') then
            temp <= input;
            output <= (input xor temp) and input;
    end if;
    
    end process;
end Behavioral;
