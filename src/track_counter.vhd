library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity track_counter is
    generic (
        MAX_TRACK : positive := 599;
        WIDTH     : positive := 10
    );
    port (
        clk               : in  std_logic;
        rst               : in  std_logic;
        restart           : in  std_logic;
        enable            : in  std_logic;
        direction_forward : in  std_logic;
        track_value       : out unsigned(WIDTH - 1 downto 0)
    );
end entity track_counter;

architecture rtl of track_counter is
    signal count : natural range 1 to MAX_TRACK := 1;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or restart = '1' then
                count <= 1;
            elsif enable = '1' then
                if direction_forward = '1' then
                    if count = MAX_TRACK then
                        count <= 1;
                    else
                        count <= count + 1;
                    end if;
                else
                    if count = 1 then
                        count <= MAX_TRACK;
                    else
                        count <= count - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    track_value <= to_unsigned(count, WIDTH);
end architecture rtl;
