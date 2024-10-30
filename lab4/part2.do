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

#TEST CASE 1: Check Reset Functionality
# This test makes sure that the reset function is always checked for first.
force {Clock} 0
force {Reset_b} 1
force {Data} 4'b0000
force {Function} 2'b00
# Transition to a rising clock edge
force {Clock} 1
run 10ns

#TEST CASE 2: Maximum Data Value
# Test with maximum data input and addition function.
force {Clock} 0
force {Reset_b} 0
force {Data} 4'b1111
force {Function} 2'b00
force {Clock} 1
run 10ns

#TEST CASE 3: Multiplication Operation with Minimum Data
# Test multiplication with minimum data value.
force {Clock} 0
force {Data} 4'b0000
force {Function} 2'b01
force {Clock} 1
run 10ns

#TEST CASE 4: Left Shift Operation with Data = 1
# Test left shift with Data = 1 (which should result in no change)
force {Clock} 0
force {Data} 4'b0001
force {Function} 2'b10
force {Clock} 1
run 10ns

#TEST CASE 5: Hold Current Value
# Hold the current value in the register, which means output should not change.
force {Clock} 0
force {Function} 2'b11
force {Clock} 1
run 10ns

# Cleanup to remove the forced values
noforce {Clock}
noforce {Reset_b}
noforce {Data}
noforce {Function}
