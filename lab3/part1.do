# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part1.v

#load simulation using mux as the top level simulation module
vsim part1

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

#set input values using the force command, signal names need to be in {} brackets

# test case 1: a = 0001, b = 0000, c_in = 0
# basic test: s = 0001
force {b[0]} 0
force {b[1]} 0
force {b[2]} 0
force {b[3]} 0

force {a[0]} 1
force {a[1]} 0
force {a[2]} 0
force {a[3]} 0

force {c_in} 0
#run simulation for a few ns
run 10ns

# test case 2: a = 0111, b = 0001, c_in = 1
# carry test (no carry out): s = 1001
force {b[0]} 1
force {b[1]} 0
force {b[2]} 0
force {b[3]} 0

force {a[0]} 1
force {a[1]} 1
force {a[2]} 1
force {a[3]} 0

force {c_in} 1
run 10ns

# test case 3: a = 1111, b = 1111, c_in = 1
# overflow test (carry out 1): s = 1111
force {b[0]} 1
force {b[1]} 1
force {b[2]} 1
force {b[3]} 1

force {a[0]} 1
force {a[1]} 1
force {a[2]} 1
force {a[3]} 1

force {c_in} 1
run 10ns

