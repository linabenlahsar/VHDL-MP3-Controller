library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity PWM_mod is
    Port (clk : in std_logic;
        rst : in std_logic;
        CE : in std_logic;
        idata : in std_logic_vector(10 downto 0);
        odata : out std_logic);
end PWM_mod;

architecture Behavioral of PWM_mod is

signal indice  : natural range 0 to 2267;
signal idata_signal : signed (10 downto 0);
signal d : unsigned(11 downto 0);
signal indiceCE : std_logic;


begin

process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                odata <= '0';
                indice <= 0;
                d <= "0";
            elsif (CE='1') then
                indiceCE <= '1';
                d<= unsigned( idata + signed(1024,12));
            elsif (indiceCE ='1') then
                if ( indice < d) then
                    odata <= 
                
                




end Behavioral;
