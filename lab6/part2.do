# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog part2.v

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# Test 1: Boundary Values / Full Path
# test to make sure min and max possible inputs for DataIn work as expected; and also to check the full path 

force {Go} 1
force {DataIn} 8'b00000000  # all 0
run 10 ns
force {DataIn} 8'b11111111  # all 1
run 10 ns
force {DataIn} 8'b10000000  # most sig = 1
run 10 ns
force {DataIn} 8'b00000001  # least sig = 1
run 10 ns
force {DataIn} 8'b01010101  # alt 0 1
run 10 ns
force {DataIn} 8'b10101010  # alt 1 0
run 10 ns

# Test 2: Reset Behavior
# make sure reset is working as expected
force {Reset} 1
run 10 ns
# can test partial reset by changing states here
force {Reset} 0
run 10 ns

# Test 3: Edge Cases
force {Go} 1
run 10 ns
force {current_state} 5'd13
run 10 ns
force {current_state} 5'd8
run 10 ns

# Cleanup to remove the forced values
noforce {Clock}
noforce {Reset}
noforce {Go}
noforce {DataIn}
