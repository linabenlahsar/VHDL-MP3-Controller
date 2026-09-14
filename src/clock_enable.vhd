library ieee;
use ieee.std_logic_1164.all;

entity clock_enable is
    generic (
        DIVISOR : positive := 100_000
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        ce  : out std_logic
    );
end entity clock_enable;

architecture rtl of clock_enable is
    signal counter : natural range 0 to DIVISOR - 1 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= 0;
                ce      <= '0';
            elsif counter = DIVISOR - 1 then
                counter <= 0;
                ce      <= '1';
            else
                counter <= counter + 1;
                ce      <= '0';
            end if;
        end if;
    end process;
end architecture rtl;
