PYTHON ?= python3
ASSEMBLER ?= auto

.PHONY: all build build-z80asm build-pasmo verify clean

all: build

build:
	$(PYTHON) tools/build.py --assembler $(ASSEMBLER)

build-z80asm:
	$(PYTHON) tools/build.py --assembler z80asm

build-pasmo:
	$(PYTHON) tools/build.py --assembler pasmo

verify:
	$(PYTHON) tools/build.py --verify-all

clean:
	rm -rf build
