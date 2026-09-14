# Board constraints

Add the XDC file matching the exact FPGA board revision before running Vivado implementation.

The top-level ports are:

- `clk_100mhz`
- `rst`
- `button_up`, `button_down`, `button_center`, `button_left`, `button_right`
- `segments[6:0]`, `anodes[7:0]`, `decimal_pt`
- `playing_led`, `direction_led`

Do not reuse a Nexys4 DDR constraint file blindly for a Nexys4 board: verify the part number and package pins against the board manual.
