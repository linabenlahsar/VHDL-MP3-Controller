library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment_decoder is
    port (
        digit    : in  unsigned(3 downto 0);
        segments : out std_logic_vector(6 downto 0)
    );
end entity seven_segment_decoder;

architecture rtl of seven_segment_decoder is
begin
    process (digit)
    begin
        case to_integer(digit) is
            when 0      => segments <= "0000001";
            when 1      => segments <= "1001111";
            when 2      => segments <= "0010010";
            when 3      => segments <= "0000110";
            when 4      => segments <= "1001100";
            when 5      => segments <= "0100100";
            when 6      => segments <= "0100000";
            when 7      => segments <= "0001111";
            when 8      => segments <= "0000000";
            when 9      => segments <= "0000100";
            when others => segments <= "1111111";
        end case;
    end process;
end architecture rtl;
