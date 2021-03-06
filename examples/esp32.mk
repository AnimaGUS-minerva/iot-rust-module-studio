SHELL := /bin/bash
RUST_MODULE_STUDIO := $(shell realpath ../..)

TOOLCHAIN_XTENSA := $(RUST_MODULE_STUDIO)/toolchain/xtensa

esp32-build-module:
	RUST_MODULE_STUDIO=$(RUST_MODULE_STUDIO) source ../esp32.setup && \
        XTENSA_GCC=$(TOOLCHAIN_XTENSA)/riot/xtensa-esp32-elf/bin/xtensa-esp32-elf-gcc \
		cargo +esp xbuild --lib --release --target xtensa-esp32-none-elf $(CARGO_FEATURES)
	ls -lrt target/xtensa-esp32-none-elf/release/*.a

RIOT_PATH := $(TOOLCHAIN_XTENSA)/riot
RIOT_BASE ?= $(RUST_MODULE_STUDIO)/RIOT
esp32-build-riot:
	RUST_MODULE_STUDIO=$(RUST_MODULE_STUDIO) source ../esp32.setup && cd ./riot && \
		RIOT_PATH=${RIOT_PATH} RIOT_BASE=${RIOT_BASE} CONTINUE_ON_EXPECTED_ERRORS=1 \
		$(TOOLCHAIN_XTENSA)/riot/riot-build
esp32-build-riot-micropython:
	RUST_MODULE_STUDIO=$(RUST_MODULE_STUDIO) source ../esp32.setup && cd ./micropython/ports/riot && \
		RIOT_PATH=${RIOT_PATH} RIOT_BASE=${RIOT_BASE} CONTINUE_ON_EXPECTED_ERRORS=1 \
		CUSTOM_BOARD=esp32  $(TOOLCHAIN_XTENSA)/riot/riot-build

RIOT_ESP32_BIN ?= ./riot.esp32.bin
esp32-run-riot:
	RIOT_ESP32_BIN=$(RIOT_ESP32_BIN) \
		cargo run --manifest-path ../runner/Cargo.toml esp32 $(EMU_TIMEOUT)

esp32-clean:
	rm -rf $(TOOLCHAIN_XTENSA)/xtensa-esp32-none-elf
