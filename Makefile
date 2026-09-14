GHDL ?= ghdl
STD := --std=08
BUILD_DIR := build

RTL := \
	src/clock_enable.vhd \
	src/button_edge_detector.vhd \
	src/player_controller_fsm.vhd \
	src/track_counter.vhd \
	src/volume_counter.vhd \
	src/seven_segment_decoder.vhd \
	src/display_scanner.vhd \
	src/mp3_controller_top.vhd

TESTBENCHES := tb_player_controller_fsm tb_track_counter tb_volume_counter

.PHONY: analyze test clean

analyze:
	mkdir -p $(BUILD_DIR)
	$(GHDL) -a $(STD) --workdir=$(BUILD_DIR) $(RTL)
	$(GHDL) -a $(STD) --workdir=$(BUILD_DIR) tb/tb_player_controller_fsm.vhd
	$(GHDL) -a $(STD) --workdir=$(BUILD_DIR) tb/tb_track_counter.vhd
	$(GHDL) -a $(STD) --workdir=$(BUILD_DIR) tb/tb_volume_counter.vhd

test: analyze
	@set -e; for tb in $(TESTBENCHES); do \
		$(GHDL) -e $(STD) --workdir=$(BUILD_DIR) $$tb; \
		$(GHDL) -r $(STD) --workdir=$(BUILD_DIR) $$tb --assert-level=error; \
	done

clean:
	$(GHDL) --clean $(STD) --workdir=$(BUILD_DIR)
	rm -rf $(BUILD_DIR)
