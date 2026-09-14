# FPGA MP3 Controller — VHDL

[![GHDL tests](https://github.com/linabenlahsar/VHDL-MP3-Controller/actions/workflows/ghdl.yml/badge.svg)](https://github.com/linabenlahsar/VHDL-MP3-Controller/actions/workflows/ghdl.yml)

A synthesizable VHDL control interface for a simplified MP3-player demonstrator targeting a Nexys4 / Xilinx Artix-7 FPGA.

The design models the **control path**, not an MP3 audio decoder: push-button commands drive a finite-state machine, a track counter, a volume counter, and a multiplexed eight-digit seven-segment display.

## Engineering highlights

- synchronous finite-state machine with stopped, playing, and paused states
- selectable forward/reverse track traversal over tracks 1–599
- saturating volume control over levels 1–9
- synchronized rising-edge detection for asynchronous push buttons
- reusable clock-enable generator; no logic-generated secondary clocks
- eight-digit multiplexed seven-segment display
- self-checking GHDL regression tests in GitHub Actions

## Repository structure

- `src/` — synthesizable VHDL-2008 modules
- `tb/` — self-checking testbenches
- `docs/architecture.md` — behaviour and integration notes
- `constraints/` — board-constraint guidance
- `Makefile` — one-command local regression
- `.github/workflows/ghdl.yml` — continuous integration

## Run the tests

GNU Make and GHDL are required.

```bash
make test
```

The regression checks the controller state transitions, direction changes, track wrap-around, restart behaviour, and volume saturation.

## FPGA target

The interface is written for a 100 MHz board clock and active-high push buttons. The default generics produce:

- an 8 kHz display-scan enable (1 kHz refresh per digit)
- a 10 Hz track-step enable for the demonstrator

Board pin assignments are intentionally kept outside the RTL. Add the correct Nexys4 or Nexys4 DDR XDC file before implementation; the two boards do not have identical constraints.

## Scope and validation

The RTL and testbenches compile and run with GHDL in CI. Hardware implementation still requires the board-specific XDC file and on-board timing/functional validation. No unsupported timing, area, or power claim is made here.

## Authors

Original academic project: **Lina Benlahsar** and **Zayd Chamcham**.

Portfolio refactoring, documentation, and automated verification preserve the original joint attribution.
