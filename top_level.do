vcom player.vhd
vcom timer.vhd
vcom fsm_controller.vhd
vcom display_mux.vhd
vcom top_level.vhd

vsim work.top_level

add wave -label "clk" /top_level/clk
add wave -label "reset" /top_level/reset
add wave -label "button" /top_level/button
add wave -label "sw" /top_level/sw
add wave -label "led" /top_level/led
add wave -label "seg" /top_level/seg
add wave -label "dp" /top_level/dp
add wave -label "an" /top_level/an

add wave -label "pulse1hz" /top_level/pulse_1hz
add wave -label "pulse10hz" /top_level/pulse_10hz
add wave -label "btnPulse" /top_level/btnPulse
add wave -label "timerStart" /top_level/timerStart
add wave -label "timerDone" /top_level/timerDone
add wave -label "iteration" /top_level/iteration
add wave -label "timeLeft" /top_level/timeLeft
add wave -label "playerEn" /top_level/playerEn
add wave -label "eliminated" /top_level/eliminated
add wave -label "playersAt12" /top_level/playersAt12
add wave -label "winner" /top_level/winner

add wave -label "currentState" /top_level/FSM/currentState
add wave -label "nextState" /top_level/FSM/nextState
add wave -label "iterCount" /top_level/FSM/iterCount
add wave -label "elimReg" /top_level/FSM/elimReg
add wave -label "winnerReg" /top_level/FSM/winnerReg
add wave -label "blinkClk" /top_level/FSM/blinkClk

add wave -label "count" /top_level/TIMER1/count
add wave -label "running" /top_level/TIMER1/running

add wave -label "0distanceReg" /top_level/p0/distanceReg
add wave -label "1distanceReg" /top_level/p1/distanceReg
add wave -label "2distanceReg" /top_level/p2/distanceReg
add wave -label "3distanceReg" /top_level/p3/distanceReg

add wave -label "rotCount" /top_level/DISPLAY/rotCount
add wave -label "digit" /top_level/DISPLAY/digit
add wave -label "wholeSecs" /top_level/DISPLAY/wholeSecs
add wave -label "tenths" /top_level/DISPLAY/tenths

force /top_level/clk 0 0ns, 1 5ns -repeat 10ns

force -freeze /top_level/pulse_1hz 0
force -freeze /top_level/pulse_10hz 0

force /top_level/reset 0
force /top_level/btn 0
force /top_level/sw "0000"
run 30ns

force /top_level/reset 1 
run 20ns

force -freeze /top_level/btnPulse 1
run 10ns
force -freeze /top_level/btnPulse 0
run 30ns






