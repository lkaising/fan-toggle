# ============================================================================
# Makefile — fan-toggle
#
# Standard targets: setup, list, build, upload, toggle-on, toggle-off, monitor, clean, help
#
# Configuration override: command-line > config/local.mk > defaults below
# ============================================================================

# --- Per-machine overrides (gitignored) ---
-include config/local.mk

# --- Defaults ---
FQBN ?= arduino:avr:uno
PORT ?= /dev/ttyACM0
BAUD ?= 9600
AVR_CORE_VERSION ?= 1.8.6
CONFIG ?= config/arduino-cli.yaml
BUILD_DIR ?= build
CLI ?= arduino-cli

.DEFAULT_GOAL := build
.PHONY: setup list build upload build-blank upload-blank toggle-on toggle-off monitor clean help

## setup : Install/verify pinned AVR core
setup:
	$(CLI) core install arduino:avr@$(AVR_CORE_VERSION) --config-file $(CONFIG)
	@echo "✓ AVR core $(AVR_CORE_VERSION) installed"

## list : Detect connected boards and ports
list:
	$(CLI) board list

## build : Compile sketch to build/
build:
	$(CLI) compile --fqbn $(FQBN) --build-path $(BUILD_DIR) --config-file $(CONFIG) .
	@echo "✓ Build complete → $(BUILD_DIR)/"

## upload : Compile + flash to board (depends on build)
upload: build
	$(CLI) upload --fqbn $(FQBN) --port $(PORT) --input-dir $(BUILD_DIR)
	@echo "✓ Uploaded to $(PORT)"

## build-blank : Compile blank (do-nothing) sketch
build-blank:
	$(CLI) compile --fqbn $(FQBN) --build-path $(BUILD_DIR)/blank --config-file $(CONFIG) blank
	@echo "✓ Blank build complete → $(BUILD_DIR)/blank/"

## upload-blank : Flash blank sketch to board (stops the fan program)
upload-blank: build-blank
	$(CLI) upload --fqbn $(FQBN) --port $(PORT) --input-dir $(BUILD_DIR)/blank
	@echo "✓ Blank sketch uploaded to $(PORT)"

## toggle-on : Set fan (pin 9) to full speed — sends '1' over serial
toggle-on:
	@stty -F $(PORT) $(BAUD) raw -echo -hupcl clocal cread \
	&& exec 3<>$(PORT) && sleep 1 && printf '1' >&3 && exec 3>&- \
	&& echo "✓ Fan ON (sent '1' to $(PORT))"

## toggle-off : Set fan (pin 9) off — sends '0' over serial
toggle-off:
	@stty -F $(PORT) $(BAUD) raw -echo -hupcl clocal cread \
	&& exec 3<>$(PORT) && sleep 1 && printf '0' >&3 && exec 3>&- \
	&& echo "✓ Fan OFF (sent '0' to $(PORT))"

## monitor : Open serial monitor
monitor:
	$(CLI) monitor --port $(PORT) --config baudrate=$(BAUD)

## clean : Remove build artifacts
clean:
	rm -rf $(BUILD_DIR)
	@echo "✓ Clean"

## help : Show available targets
help:
	@echo "Targets:"
	@grep -hE '^## ' $(MAKEFILE_LIST) | sed 's/^## //' | column -t -s ':'
	@echo ""
	@echo "Override examples:"
	@echo "  make upload PORT=/dev/ttyACM1"
	@echo "  make build FQBN=arduino:avr:mega:cpu=atmega2560"
