library ieee;
use ieee.std_logic_1164.all;

entity button_edge_detector is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        async_input : in  std_logic;
        rise_pulse  : out std_logic
    );
end entity button_edge_detector;

architecture rtl of button_edge_detector is
    signal sync_ff1 : std_logic := '0';
    signal sync_ff2 : std_logic := '0';
    signal previous : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sync_ff1  <= '0';
                sync_ff2  <= '0';
                previous  <= '0';
                rise_pulse <= '0';
            else
                sync_ff1  <= async_input;
                sync_ff2  <= sync_ff1;
                previous  <= sync_ff2;
                rise_pulse <= sync_ff2 and not previous;
            end if;
        end if;
    end process;
end architecture rtl;
