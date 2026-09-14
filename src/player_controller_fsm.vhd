library ieee;
use ieee.std_logic_1164.all;

entity player_controller_fsm is
    port (
        clk               : in  std_logic;
        rst               : in  std_logic;
        input_ce          : in  std_logic;
        center_pulse      : in  std_logic;
        left_pulse        : in  std_logic;
        right_pulse       : in  std_logic;
        playing           : out std_logic;
        paused            : out std_logic;
        restart_track     : out std_logic;
        direction_forward : out std_logic
    );
end entity player_controller_fsm;

architecture rtl of player_controller_fsm is
    type state_t is (stopped_state, playing_state, paused_state);
    signal state         : state_t  := stopped_state;
    signal direction_reg : std_logic := '1';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state         <= stopped_state;
                direction_reg <= '1';
            elsif input_ce = '1' then
                if left_pulse = '1' and right_pulse = '0' then
                    direction_reg <= '0';
                elsif right_pulse = '1' and left_pulse = '0' then
                    direction_reg <= '1';
                end if;

                if center_pulse = '1' then
                    case state is
                        when stopped_state =>
                            state <= playing_state;
                        when playing_state =>
                            state <= paused_state;
                        when paused_state =>
                            state <= stopped_state;
                    end case;
                end if;
            end if;
        end if;
    end process;

    playing           <= '1' when state = playing_state else '0';
    paused            <= '1' when state = paused_state else '0';
    restart_track     <= '1' when state = stopped_state else '0';
    direction_forward <= direction_reg;
end architecture rtl;
