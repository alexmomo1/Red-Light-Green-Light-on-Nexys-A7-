vcom fsm_controller.vhd
vsim work.fsm_controller

add wave -label "clk" /fsm_controller/clk
add wave -label "reset" /fsm_controller/reset
add wave -label "btnStart" /fsm_controller/btnStart
add wave -label "timerDone" /fsm_controller/timerDone
add wave -label "sw" /fsm_controller/sw
add wave -label "playersAt12" /fsm_controller/playersAt12
add wave -label "timerStart" /fsm_controller/timerStart
add wave -label "iteration" /fsm_controller/iteration
add wave -label "playerEn" /fsm_controller/playerEn
add wave -label "eliminated" /fsm_controller/eliminated
add wave -label "led" /fsm_controller/led
add wave -label "winner" /fsm_controller/winner

add wave -label "currentState" /fsm_controller/currentState
add wave -label "nextState" /fsm_controller/nextState
add wave -label "iterCount" /fsm_controller/iterCount
add wave -label "elimReg" /fsm_controller/elimReg
add wave -label "winnerReg" /fsm_controller/winnerReg
add wave -label "blinkClk" /fsm_controller/blinkClk

force /fsm_controller/clk 0 0ns, 1 5ns -repeat 10ns

force /fsm_controller/reset 0
force /fsm_controller/btnStart 0
force /fsm_controller/timerDone 0
force /fsm_controller/sw "0000"
force /fsm_controller/playersAt12 "0000"

run 30ns
force /fsm_controller/reset 1
run 20ns


force /fsm_controller/btnStart 1 
run 10ns
force /fsm_controller/btnStart 0
run 30ns


force /fsm_controller/timerDone 1
run 10ns
force /fsm_controller/timerDone 0
run 30ns

force /fsm_controller/sw "0001"
run 30ns
force /fsm_controller/sw "0000"
run 20ns

set i 0 
while {$i < 8} {
	force /fsm_controller/btnStart 1
	run 10ns
	force /fsm_controller/btnStart 0 
	run 5ns
	force /fsm_controller/timerDone 1
	run 10ns
	force /fsm_controller/timerDone 0 
	run 5ns
	incr i
}

force /fsm_controller/reset 0
force /fsm_controller/btnStart 0
force /fsm_controller/timerDone 0
force /fsm_controller/sw "0000"
force /fsm_controller/playersAt12 "0000"
run 20ns
force /fsm_controller/reset 1
run 20ns


force /fsm_controller/btnStart 1
run 10ns
force /fsm_controller/btnStart 0
run 30ns


force /fsm_controller/playersAt12 "0001"
force /fsm_controller/timerDone 1
run 10ns
force /fsm_controller/timerDone 0
run 30ns


force /fsm_controller/reset 0
force /fsm_controller/btnStart 0
force /fsm_controller/timerDone 0
force /fsm_controller/sw "0000"
force /fsm_controller/playersAt12 "0000"
run 20ns
force /fsm_controller/reset 1
run 20ns

set i 0 
while {$i < 10} {
	force /fsm_controller/btnStart 1 
	run 10ns
	force /fsm_controller/btnStart 0 
	run 30ns
	force /fsm_controller/timerDone 1
	run 10ns
	force /fsm_controller/timerDone 0
	run 30ns
	incr i
}

run 100ns
