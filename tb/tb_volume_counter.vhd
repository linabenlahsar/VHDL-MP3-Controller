library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb_volume_counter is
end entity;

architecture test of tb_volume_counter is
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal increase     : std_logic := '0';
    signal decrease     : std_logic := '0';
    signal volume_value : unsigned(3 downto 0);
begin
    clk <= not clk after 5 ns;

    dut : entity work.volume_counter
        port map (
            clk          => clk,
            rst          => rst,
            increase     => increase,
            decrease     => decrease,
            volume_value => volume_value
        );

    stimulus : process
        procedure tick is
        begin
            wait until rising_edge(clk);
            wait for 1 ns;
        end procedure;

        procedure press(signal command : out std_logic) is
        begin
            command <= '1';
            tick;
            command <= '0';
            tick;
        end procedure;
    begin
        tick;
        rst <= '0';
        tick;
        assert volume_value = to_unsigned(5, 4)
            report "Reset volume must be 5" severity failure;

        for index in 1 to 8 loop
            press(increase);
        end loop;
        assert volume_value = to_unsigned(9, 4)
            report "Volume must saturate at 9" severity failure;

        increase <= '1';
        decrease <= '1';
        tick;
        increase <= '0';
        decrease <= '0';
        tick;
        assert volume_value = to_unsigned(9, 4)
            report "Simultaneous commands must hold the volume" severity failure;

        for index in 1 to 12 loop
            press(decrease);
        end loop;
        assert volume_value = to_unsigned(1, 4)
            report "Volume must saturate at 1" severity failure;

        report "tb_volume_counter passed" severity note;
        stop;
        wait;
    end process;
end architecture test;
