library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod8 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           c_e : in STD_LOGIC;
           AN : out std_logic_vector(7 downto 0);
           smod8 : out std_logic_vector(2 downto 0));
end mod8;

architecture Behavioral of mod8 is

signal s_comp : unsigned(2 downto 0);


begin

    process(clk)
    begin
        if(clk'event and clk = '1') then
            if(rst = '1') then
                s_comp <= "001";
            elsif(c_e = '1') then        
                if(s_comp = "111") then
                    s_comp <= "000";
                else        
                    s_comp <= s_comp + "001";
                end if;
            end if;
        end if;            
    end process;
smod8 <= STD_LOGIC_VECTOR(s_comp);



    process(s_comp)
    begin
        case s_comp is
            when "000" => AN <= "11111110";
            when "001" => AN <= "11111101";
            when "010" => AN <= "11111011";
            when "011" => AN <= "11110111";
            when "100" => AN <= "11101111";
            when "101" => AN <= "11011111";
            when "110" => AN <= "10111111";
            when "111" => AN <= "01111111";
            when others  => AN <= "11111111";
        end case;
   end process;
end Behavioral;