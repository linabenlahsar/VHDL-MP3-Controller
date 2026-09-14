library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mp3_controller_top is
    generic (
        DISPLAY_DIVISOR : positive := 12_500;
        TRACK_DIVISOR   : positive := 10_000_000
    );
    port (
        clk_100mhz   : in  std_logic;
        rst          : in  std_logic;
        button_up    : in  std_logic;
        button_down  : in  std_logic;
        button_center: in  std_logic;
        button_left  : in  std_logic;
        button_right : in  std_logic;
        segments     : out std_logic_vector(6 downto 0);
        anodes       : out std_logic_vector(7 downto 0);
        decimal_pt   : out std_logic;
        playing_led  : out std_logic;
        direction_led: out std_logic
    );
end entity mp3_controller_top;

architecture rtl of mp3_controller_top is
    signal display_ce        : std_logic;
    signal track_ce          : std_logic;
    signal up_pulse          : std_logic;
    signal down_pulse        : std_logic;
    signal center_pulse      : std_logic;
    signal left_pulse        : std_logic;
    signal right_pulse       : std_logic;
    signal playing           : std_logic;
    signal paused            : std_logic;
    signal restart_track     : std_logic;
    signal direction_forward : std_logic;
    signal track_enable      : std_logic;
    signal track_value       : unsigned(9 downto 0);
    signal volume_value      : unsigned(3 downto 0);
    signal display_digits    : std_logic_vector(31 downto 0);
begin
    display_clock_enable : entity work.clock_enable
        generic map (DIVISOR => DISPLAY_DIVISOR)
        port map (clk => clk_100mhz, rst => rst, ce => display_ce);

    track_clock_enable : entity work.clock_enable
        generic map (DIVISOR => TRACK_DIVISOR)
        port map (clk => clk_100mhz, rst => rst, ce => track_ce);

    up_edge : entity work.button_edge_detector
        port map (
            clk => clk_100mhz, rst => rst,
            async_input => button_up, rise_pulse => up_pulse
        );

    down_edge : entity work.button_edge_detector
        port map (
            clk => clk_100mhz, rst => rst,
            async_input => button_down, rise_pulse => down_pulse
        );

    center_edge : entity work.button_edge_detector
        port map (
            clk => clk_100mhz, rst => rst,
            async_input => button_center, rise_pulse => center_pulse
        );

    left_edge : entity work.button_edge_detector
        port map (
            clk => clk_100mhz, rst => rst,
            async_input => button_left, rise_pulse => left_pulse
        );

    right_edge : entity work.button_edge_detector
        port map (
            clk => clk_100mhz, rst => rst,
            async_input => button_right, rise_pulse => right_pulse
        );

    controller : entity work.player_controller_fsm
        port map (
            clk               => clk_100mhz,
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

    track_enable <= track_ce and playing;

    tracks : entity work.track_counter
        generic map (
            MAX_TRACK => 599,
            WIDTH     => 10
        )
        port map (
            clk               => clk_100mhz,
            rst               => rst,
            restart           => restart_track,
            enable            => track_enable,
            direction_forward => direction_forward,
            track_value       => track_value
        );

    volume : entity work.volume_counter
        port map (
            clk          => clk_100mhz,
            rst          => rst,
            increase     => up_pulse,
            decrease     => down_pulse,
            volume_value => volume_value
        );

    process (all)
        variable track_integer : natural range 0 to 1023;
        variable packed_digits : std_logic_vector(31 downto 0);
    begin
        track_integer := to_integer(track_value);
        packed_digits := (others => '1');

        packed_digits(3 downto 0) :=
            std_logic_vector(to_unsigned(track_integer mod 10, 4));
        packed_digits(7 downto 4) :=
            std_logic_vector(to_unsigned((track_integer / 10) mod 10, 4));
        packed_digits(11 downto 8) :=
            std_logic_vector(to_unsigned((track_integer / 100) mod 10, 4));
        packed_digits(15 downto 12) := std_logic_vector(volume_value);

        if direction_forward = '1' then
            packed_digits(19 downto 16) := "0001";
        else
            packed_digits(19 downto 16) := "0000";
        end if;

        if playing = '1' then
            packed_digits(23 downto 20) := "0001";
        elsif paused = '1' then
            packed_digits(23 downto 20) := "0010";
        else
            packed_digits(23 downto 20) := "0000";
        end if;

        display_digits <= packed_digits;
    end process;

    display : entity work.display_scanner
        port map (
            clk        => clk_100mhz,
            rst        => rst,
            scan_ce    => display_ce,
            digits     => display_digits,
            anodes     => anodes,
            segments   => segments,
            decimal_pt => decimal_pt
        );

    playing_led   <= playing;
    direction_led <= direction_forward;
end architecture rtl;
