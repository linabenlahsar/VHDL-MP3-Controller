library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Entity FSM is
PORT ( clk: in std_logic;
       rst: in std_logic;
      
       B_UP: in std_logic;
       B_DOWN: in std_logic;
       B_CENTER: in std_logic;
       B_LEFT: in std_logic;
       B_RIGHT: in std_logic;
      
       PLAY_PAUSE: out std_logic;
       RESTART: out std_logic;
       FORWARD: out std_logic;
       VOLUME_UP: out std_logic;
       VOLUME_DW: out std_logic
       );
end FSM;

Architecture bhv of fsm is

type state_type is ( init, play_fwd, pause, play_bwd, stop);
signal current_state : state_type;
signal next_state : state_type;

begin
    process (current_state, B_CENTER, B_LEFT, B_RIGHT)
    begin
        case current_state is
             when init =>
                  if ( B_CENTER = '1') then
                     next_state <= play_fwd;
                  else
                     next_state <= init;
                  end if;
             when play_fwd =>
                  if (B_CENTER = '1') then
                     next_state <= pause;
                  else
                      next_state <= play_fwd;
                  end if;
             when pause =>
                  if (B_CENTER = '1') then
                      next_state <= stop;
                  elsif ( B_LEFT = '1') then
                      next_state <= play_bwd;
                  elsif ( B_RIGHT = '1') then
                      next_state <= play_fwd;
                  else
                      next_state <= pause;
                  end if;
             when play_bwd =>
                  if ( B_CENTER = '1') then
                      next_state <= pause;
                  else
                      next_state <= play_bwd;
                  end if;
             when stop =>
                  if ( B_CENTER = '1') then
                      next_state <= play_fwd;
                  else
                      next_state <= stop;
                  end if;
--             when OTHERS =>
--                next_state <= init;
        end case;
    end process;

    process(current_state, B_UP, B_DOWN)
    begin
    case current_state is
         when init =>
              PLAY_PAUSE <= '0';
              RESTART    <= '1';
              FORWARD    <= '0';
              VOLUME_UP  <= '0';
              VOLUME_DW <='0';
         when play_fwd =>
              PLAY_PAUSE <= '1';
              RESTART    <= '0';
              FORWARD    <='1';
              VOLUME_UP  <= B_UP;
              VOLUME_DW <= B_DOWN;
         when pause =>
              PLAY_PAUSE <= '0';
              RESTART    <= '0';
              FORWARD    <= '0';
              VOLUME_UP  <= '0';
              VOLUME_DW <= '0';
         when play_bwd =>
              PLAY_PAUSE <= '1';
              RESTART    <= '0';
              FORWARD    <= '0';
              VOLUME_UP  <= B_UP;
              VOLUME_DW <= B_DOWN;
         when stop =>
              PLAY_PAUSE <= '0';
              RESTART    <= '1';
              FORWARD    <= '0';
              VOLUME_UP  <= '0';
              VOLUME_DW <='0';
    end case;
    end process;

    process(clk)
    begin
    if ( clk'event and clk = '1') then
        if (rst = '1') then
               current_state <= init;
        else
               current_state <= next_state;
        end if;
    end if;
    end process;
end;