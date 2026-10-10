vcom timer.vhd
vsim work.timer

add wave -label "clk" /timer/clk
add wave -label "reset" /timer/reset
add wave -label "start" /timer/start
add wave -label "iteration" /timer/iteration
add wave -label "pulse_10hz" /timer/pulse_10hz
add wave -label "timerDone" /timer/timerDone
add wave -label "timeLeft" /timer/timeLeft
add wave -label "count" /timer/count
add wave -label "running" /timer/running

force /timer/clk 0 0ns, 1 5ns -repeat 10ns

force /timer/reset 0 
force /timer/start 0
force /timer/iteration "0000"
force /timer/pulse_10hz 0
run 20ns

force /timer/reset 1
run 20ns


#test 1: load iteration 10 -> 0.5s duration
force /timer/iteration "1010"
force /timer/start 1 
run 10ns
force /timer/start 0
run 20ns

set i 0 
while {$i < 5} {
	force /timer/pulse_10hz 1
	run 10ns
	force /timer/pulse_10hz 0
	run 20ns
	incr i
}
 
run 50ns

#test 2
force /timer/iteration "0001"
force /timer/start 1 
run 10ns
force /timer/start 0
run 20ns

set i 0
while {$i < 60} {
	force /timer/pulse_10hz 1
	run 10ns
	force /timer/pulse_10hz 0
	run 20ns
	incr i
}
run 10ns



