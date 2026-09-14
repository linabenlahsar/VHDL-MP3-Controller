library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_scanner is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        scan_ce    : in  std_logic;
        digits     : in  std_logic_vector(31 downto 0);
        anodes     : out std_logic_vector(7 downto 0);
        segments   : out std_logic_vector(6 downto 0);
        decimal_pt : out std_logic
    );
end entity display_scanner;

architecture rtl of display_scanner is
    signal scan_index     : unsigned(2 downto 0) := (others => '0');
    signal selected_digit : unsigned(3 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                scan_index <= (others => '0');
            elsif scan_ce = '1' then
                scan_index <= scan_index + 1;
            end if;
        end if;
    end process;

    process (all)
        variable index_value : natural range 0 to 7;
        variable anode_value : std_logic_vector(7 downto 0);
    begin
        index_value := to_integer(scan_index);
        selected_digit <= unsigned(
            digits(index_value * 4 + 3 downto index_value * 4)
        );

        anode_value := (others => '1');
        anode_value(index_value) := '0';
        anodes <= anode_value;
    end process;

    decoder : entity work.seven_segment_decoder
        port map (
            digit    => selected_digit,
            segments => segments
        );

    decimal_pt <= '1';
end architecture rtl;
