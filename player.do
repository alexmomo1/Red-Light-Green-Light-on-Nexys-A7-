vcom player.vhd
vsim work.player

add wave -label "clk" /player/clk
add wave -label "reset" /player/reset
add wave -label "sw" /player/sw
add wave -label "en" /player/en
add wave -label "pulse_1hz" /player/pulse_1hz
add wave -label "distanceReg" /player/distanceReg
add wave -label "distance" /player/distance
add wave -label "at12" /player/at12

force /player/clk 0 0ns, 1 5ns -repeat 10ns

force /player/reset 0
force /player/sw 0
force /player/en 0
force /player/pulse_1hz 0
run 20ns

force /player/reset 1 
run 20ns

#test 2: when en=0 not advancing
force /player/sw 1
force /player/en 0
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns

#test 1: advancing normally
force /player/en 1
force /player/sw 1
#verify that it stops advancing at 12
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns
force /player/pulse_1hz 1
run 10ns
force /player/pulse_1hz 0
run 20ns







