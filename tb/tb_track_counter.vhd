library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb_track_counter is
end entity;

architecture test of tb_track_counter is
    signal clk               : std_logic := '0';
    signal rst               : std_logic := '1';
    signal restart           : std_logic := '0';
    signal enable            : std_logic := '0';
    signal direction_forward : std_logic := '1';
    signal track_value       : unsigned(1 downto 0);
begin
    clk <= not clk after 5 ns;

    dut : entity work.track_counter
        generic map (
            MAX_TRACK => 3,
            WIDTH     => 2
        )
        port map (
            clk               => clk,
            rst               => rst,
            restart           => restart,
            enable            => enable,
            direction_forward => direction_forward,
            track_value       => track_value
        );

    stimulus : process
        procedure tick is
        begin
            wait until rising_edge(clk);
            wait for 1 ns;
        end procedure;

        procedure step is
        begin
            enable <= '1';
            tick;
            enable <= '0';
            tick;
        end procedure;
    begin
        tick;
        rst <= '0';
        tick;
        assert track_value = to_unsigned(1, 2)
            report "Reset track must be 1" severity failure;

        step;
        assert track_value = to_unsigned(2, 2)
            report "Forward step 1 failed" severity failure;
        step;
        assert track_value = to_unsigned(3, 2)
            report "Forward step 2 failed" severity failure;
        step;
        assert track_value = to_unsigned(1, 2)
            report "Forward wrap-around failed" severity failure;

        direction_forward <= '0';
        step;
        assert track_value = to_unsigned(3, 2)
            report "Reverse wrap-around failed" severity failure;

        restart <= '1';
        tick;
        restart <= '0';
        tick;
        assert track_value = to_unsigned(1, 2)
            report "Restart failed" severity failure;

        report "tb_track_counter passed" severity note;
        stop;
        wait;
    end process;
end architecture test;
