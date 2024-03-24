# Set the VHDL compiler and simulator
VHDL_COMPILER = ghdl
SIMULATOR = ghdl

#Package for pnr
PACKAGE = qn84

# Set the source files
SOURCE_FILES := $(wildcard Modules/*.vhd)
TESTBENCH_FILES = $(wildcard Testbenches/*.vhd)
# Set the testbench entity
TESTBENCH_ENTITY = top_tb

# Set the output VCD file
VCD_FILE = top_tb.ghw

# Default target
all: run


# Target to run the simulation
run:
	ghdl -a Modules/uart_rx.vhd
	ghdl -a Modules/uart_tx.vhd
	ghdl -a Modules/circularfifobuffer.vhd 
	ghdl -a Modules/clock_div.vhd 
	ghdl -a Modules/char_to_morse_7seg.vhd 
	ghdl -a Modules/morse_display.vhd 
	ghdl -a Modules/top.vhd
	ghdl -a Testbenches/top_tb.vhd
	ghdl -e top_tb
	ghdl -r top_tb --wave=vcd/top_tb.ghw

view:
	gtkwave vcd/$(VCD_FILE)
	

# Clean target to remove generated files
clean:
	rm -f *.o *.cf $(VCD_FILE)
	rm -rf bld vcd schematics Verilog json
	mkdir bld vcd schematics Verilog json




# schematic: $(MODULES)
# $(MODULES):
# 	cd bld;\
# 	ghdl -a --workdir=../bld ../Modules/$@.vhd;\
# 	$(VHDL_COMPILER) --synth --out=verilog $@ > ../Verilog/$@.v;\
# 	yosys -p "prep -top $@; write_json ../json/$@.json" ../Verilog/$@.v;\
# 	netlistsvg ../json/$@.json -o ../schematics/$@.svg;\

MODULES = top
synthesise: $(MODULES)
$(MODULES):
	cd bld;\
	ghdl -a ../Modules/uart_rx.vhd;\
	ghdl -a ../Modules/uart_tx.vhd;\
	ghdl -a ../Modules/circularfifobuffer.vhd;\
	ghdl -a ../Modules/clock_div.vhd;\
	ghdl -a ../Modules/char_to_morse_7seg.vhd;\
	ghdl -a ../Modules/morse_display.vhd;\
	ghdl -a ../Modules/top.vhd;\
	$(VHDL_COMPILER) --synth --out=verilog $@ > ../Verilog/$@.v;\
	yosys -p "synth_ice40 -top $@; write_json ../json/$@.json" ../Verilog/$@.v;\
	nextpnr-ice40 --lp1k --package $(PACKAGE) --json ../json/$@.json --pcf ../Constraints/Constraints.pcf --pcf-allow-unconstrained --asc $@.asc;\
	icepack -v $@.asc $@.bin;\
	iceburn -e -v -w $@.bin;\