library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity volume_counter is
    generic (
        MIN_VOLUME   : natural  := 1;
        MAX_VOLUME   : positive := 9;
        RESET_VOLUME : natural  := 5;
        WIDTH        : positive := 4
    );
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        increase     : in  std_logic;
        decrease     : in  std_logic;
        volume_value : out unsigned(WIDTH - 1 downto 0)
    );
end entity volume_counter;

architecture rtl of volume_counter is
    signal count : natural range MIN_VOLUME to MAX_VOLUME := RESET_VOLUME;
begin
    assert MIN_VOLUME <= RESET_VOLUME and RESET_VOLUME <= MAX_VOLUME
        report "RESET_VOLUME must be inside the configured range"
        severity failure;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count <= RESET_VOLUME;
            elsif increase = '1' and decrease = '0' then
                if count < MAX_VOLUME then
                    count <= count + 1;
                end if;
            elsif decrease = '1' and increase = '0' then
                if count > MIN_VOLUME then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

    volume_value <= to_unsigned(count, WIDTH);
end architecture rtl;
