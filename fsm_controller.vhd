-- Victor Alexandre Frings-Morales
-- ID : 40309808
-- COEN313 Red Light, Green Light
-- Due Date : April 24th 2026

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm_controller is
	port (
-- INPUTS: START button (std_logic), TIMER signal (event? like a rising edge), player POSITION (one bit per player, std_logic array?), player SWITCH ( again, an array of std_logic)
	clk          : in  std_logic; -- clock of course
	reset        : in  std_logic; -- active-low on nexys a7
	btnStart     : in  std_logic; 
	timerDone    : in  std_logic; -- single-cycle pulse from timer
	sw           : in  std_logic_vector(3 downto 0); -- player switches: which are on
	playersAt12  : in  std_logic_vector(3 downto 0); -- player flags: who has won
	timerStart   : out std_logic; -- pulse to start timer (on for only one cycle)
	iteration    : out std_logic_vector(3 downto 0); -- current iteration (1-10)
	playerEn     : out std_logic_vector(3 downto 0); -- players who are allowed to move
	eliminated   : out std_logic_vector(3 downto 0); -- player flags: who was eliminated
	led          : out std_logic_vector(3 downto 0); -- per-player LED
	winner       : out std_logic_vector(3 downto 0);  -- which player won
	isRed	     : out std_logic;
	isGreen	     : out std_logic
	);

end fsm_controller;

architecture controller of fsm_controller is


	-- IDLE: before the start button is pressed
	-- GREEN: the timer is currently running, players can move and the switches are being monitored
	-- CHECK_WIN: checks if game is won
	-- RED: between iterations, start button not pressed yet and player switches are being monitored
	-- GAME_OVER: all players are dead OR someone won OR 10 iterations have passed
	type state_type is (IDLE, GREEN, RED, CHECK_WIN, GAME_OVER);
	signal currentState : state_type;
	signal nextState    : state_type;

	signal iterCount    : unsigned(3 downto 0);
	signal elimReg      : std_logic_vector(3 downto 0);
	signal winnerReg    : std_logic_vector(3 downto 0);

	signal blinkClk     : std_logic;
	signal blinkCounter : unsigned(25 downto 0);
begin

    
state_register_process : process(clk)
begin
	if rising_edge(clk) then
		if reset = '0' then -- '0' means game is being reset
			currentState <= IDLE;
		else 
			currentState <= nextState;
		end if;
	end if;
end process state_register_process;


next_state_logic : process(currentState, btnStart, timerDone, playersAt12, elimReg, iterCount)
begin
	nextState <= currentState; -- default, means no change after clk
	case currentState is 
		when IDLE =>
			if btnStart = '1' then
				nextState <= GREEN;
			end if;
		when GREEN => 
			if timerDone = '1' then
				nextState <= CHECK_WIN;
			end if;
		when CHECK_WIN =>
			if (elimReg = "1111") or (playersAt12 > "0000") or (iterCount = "1010") then
        			nextState <= GAME_OVER;
			else 
				nextState <= RED;
			end if;
		when RED =>
			if btnStart = '1' then
				nextState <= GREEN;
			end if;
		when others =>
			nextState <= IDLE;
	end case;
end process next_state_logic;


iteration_counter : process(clk)
begin
	if rising_edge(clk) then 
		if reset = '0' then
			iterCount <= "0001"; -- ROUND 1, FIGHT!
		else 
			if (currentState = GREEN) and (timerDone = '1') and (iterCount < 10) then	
				iterCount <= iterCount + 1;
			end if;
		end if;
	end if;
end process iteration_counter;


elimination_register_process : process(clk)
begin
	if rising_edge(clk) then
		if reset = '0' then
			elimReg <= "0000";
		elsif currentState = RED then 
			for i in 0 to 3 loop
				if sw(i) = '1' then
					elimReg(i) <= '1'; 
				end if;
			end loop;
		end if;
	end if;
end process elimination_register_process;


winner_register_process : process(clk)
begin
	if rising_edge(clk) then
		if reset = '0' then
			winnerReg <= "0000";
		elsif currentState = CHECK_WIN then
			winnerReg <= playersAt12;
		end if;
	end if;
end process winner_register_process;


winner_blink_process : process(clk)
begin
	if rising_edge(clk) then
		if reset = '0' then
			blinkCounter <= (others => '0');
			blinkCLk <= '0';
		else
			if blinkCounter > 50000000 then
				blinkCounter <= (others => '0');
				blinkClk <= not blinkClk;
			else 
				blinkCounter <= blinkCounter + 1;
			end if;
		end if;
		
	end if;
end process winner_blink_process;


player_enable: for i in 0 to 3 generate
	playerEn(i) <= '1' 	when (currentState = GREEN) and (elimReg(i) = '0')
		else   '0';
end generate player_enable;

led_output: for i in 0 to 3 generate
	led(i) <=  blinkClk	when (playersAt12(i) = '1')
		else '0' 	when (elimReg(i) = '1')
		else '1';
end generate led_output;

timerStart <= '1' when (nextState = GREEN) and (currentState /= GREEN) else  '0';

eliminated <= elimReg;
winner     <= winnerReg;
iteration  <= std_logic_vector(iterCount);
isGreen <= '1' when currentState = GREEN else '0';
isRed <= '1' when currentState = RED else '0';

end controller;
