# Architecture

## Functional partition

The project is split into small synchronous blocks:

1. **Input conditioning** — each asynchronous push button passes through a two-flip-flop synchronizer and rising-edge detector.
2. **Player controller** — a finite-state machine cycles through stopped, playing, and paused states. Left/right commands select the traversal direction.
3. **Track counter** — advances or reverses over tracks 1–599 and wraps at each boundary.
4. **Volume counter** — changes from 1 to 9 and saturates at the limits.
5. **Display path** — decimal digits are packed in the top level, decoded, and scanned over eight active-low anodes.
6. **Timing enables** — counters generate one-clock enable pulses. All state remains in the 100 MHz clock domain.

## Control behaviour

| Command | Effect |
|---|---|
| Center from stopped | Start playback |
| Center from playing | Pause |
| Center from paused | Stop and reset track to 1 |
| Left | Select reverse traversal |
| Right | Select forward traversal |
| Up | Increase volume, saturating at 9 |
| Down | Decrease volume, saturating at 1 |

## Display allocation

From the least-significant scanned digit:

- digits 0–2: track number
- digit 3: volume
- digit 4: direction (1 forward, 0 reverse)
- digit 5: state (0 stopped, 1 playing, 2 paused)
- digits 6–7: blank

## Design decisions

- Clock enables are used instead of fabric-generated clocks.
- Arithmetic uses `ieee.numeric_std`.
- Board constraints are separated from RTL.
- Testbenches use reduced generic limits where useful to exercise boundary behaviour quickly.
