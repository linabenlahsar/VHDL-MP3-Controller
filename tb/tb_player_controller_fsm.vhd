library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity tb_player_controller_fsm is
end entity;

architecture test of tb_player_controller_fsm is
    signal clk               : std_logic := '0';
    signal rst               : std_logic := '1';
    signal center_pulse      : std_logic := '0';
    signal left_pulse        : std_logic := '0';
    signal right_pulse       : std_logic := '0';
    signal playing           : std_logic;
    signal paused            : std_logic;
    signal restart_track     : std_logic;
    signal direction_forward : std_logic;
begin
    clk <= not clk after 5 ns;

    dut : entity work.player_controller_fsm
        port map (
            clk               => clk,
            rst               => rst,
            input_ce          => '1',
            center_pulse      => center_pulse,
            left_pulse        => left_pulse,
            right_pulse       => right_pulse,
            playing           => playing,
            paused            => paused,
            restart_track     => restart_track,
            direction_forward => direction_forward
        );

    stimulus : process
        procedure tick is
        begin
            wait until rising_edge(clk);
            wait for 1 ns;
        end procedure;
    begin
        tick;
        tick;
        rst <= '0';
        tick;

        assert playing = '0' and paused = '0' and restart_track = '1'
            report "Reset must select the stopped state" severity failure;
        assert direction_forward = '1'
            report "Reset direction must be forward" severity failure;

        center_pulse <= '1';
        tick;
        center_pulse <= '0';
        tick;
        assert playing = '1' and restart_track = '0'
            report "Center must start playback" severity failure;

        left_pulse <= '1';
        tick;
        left_pulse <= '0';
        tick;
        assert direction_forward = '0'
            report "Left must select reverse traversal" severity failure;

        center_pulse <= '1';
        tick;
        center_pulse <= '0';
        tick;
        assert paused = '1' and playing = '0'
            report "Second center press must pause" severity failure;

        right_pulse <= '1';
        tick;
        right_pulse <= '0';
        tick;
        assert direction_forward = '1'
            report "Right must select forward traversal" severity failure;

        center_pulse <= '1';
        tick;
        center_pulse <= '0';
        tick;
        assert restart_track = '1' and playing = '0' and paused = '0'
            report "Third center press must stop and request restart" severity failure;

        report "tb_player_controller_fsm passed" severity note;
        stop;
        wait;
    end process;
end architecture test;
