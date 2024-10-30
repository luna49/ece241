# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part1.v

#address parameter
vsim -L altera_mf_ver part1

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#set the clock
force clock 0 0ns, 1 5ns -r 10ns

#test case one 
force address 00001
force data 0001
force wren 0 
run 10ns

#test case two: multiple write operations
#data is correctly written to the specified addresses
force address 00000
force data 0011
force wren 1
run 10ns

force address 00010
force data 1010
force wren 1
run 10ns

force address 00111
force data 0110
force wren 1
run 10ns

#test case three: read from unwritten address
#make sure return default value
force address 00100
force wren 0
run 10ns
