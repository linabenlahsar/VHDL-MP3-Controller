# Simplified MP3 controller in VHDL

[![GHDL tests](https://github.com/linabenlahsar/VHDL-MP3-Controller/actions/workflows/ghdl.yml/badge.svg)](https://github.com/linabenlahsar/VHDL-MP3-Controller/actions/workflows/ghdl.yml)

This was an academic FPGA project developed with **Zayd Chamcham** on a Nexys4 board. The goal was to design the control interface of a simplified music player: push-button commands, playback state, track selection, volume, and multiplexed seven-segment display.

It is a control-path demonstrator, not an MP3 audio decoder.

## Behaviour

- the centre button cycles through stop, play, and pause;
- left and right select reverse or forward track traversal;
- the track counter covers 1 to 599 and wraps at both limits;
- volume ranges from 1 to 9 and saturates at the limits;
- the display shows the track number, volume, direction, and player state.

All sequential logic remains in the 100 MHz clock domain. Slower operations use one-cycle clock-enable pulses rather than fabric-generated clocks.

## RTL organization

| File | Role |
|---|---|
| `player_controller_fsm.vhd` | playback FSM and direction control |
| `track_counter.vhd` | bidirectional track counter |
| `volume_counter.vhd` | saturating volume counter |
| `button_edge_detector.vhd` | input synchronization and edge detection |
| `clock_enable.vhd` | reusable clock-enable divider |
| `seven_segment_decoder.vhd` | decimal-to-seven-segment conversion |
| `display_scanner.vhd` | eight-digit display multiplexing |
| `mp3_controller_top.vhd` | top-level integration |

The synthesizable files are under `src/`; self-checking testbenches are under `tb/`.

## Tests

Install GHDL and GNU Make, then run:

```bash
make test
```

The regression covers:

- state transitions and direction changes;
- forward and reverse wrap-around of the track counter;
- track restart;
- upper and lower volume saturation.

The same tests run automatically on GitHub Actions.

## Board integration

The default top-level generics assume a 100 MHz input clock. The XDC file is not included because Nexys4 and Nexys4 DDR pin assignments differ. The constraint file must match the exact board revision before Vivado implementation.

The public repository validates compilation and simulated behaviour with GHDL; it does not claim post-implementation timing, area, power, or renewed on-board validation.

## Authors

**Lina Benlahsar** and **Zayd Chamcham**.
