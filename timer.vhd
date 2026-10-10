-- Victor Alexandre Frings-Morales
-- ID : 40309808
-- COEN313 Red Light, Green Light
-- Due Date : April 24th 2026

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer is
	port (
	clk          : in  std_logic;
	reset        : in  std_logic; -- active-low
	start        : in  std_logic; -- single-cycle pulse from controller
	iteration    : in  std_logic_vector(3 downto 0);
	pulse_10hz   : in  std_logic; -- 100ms enable pulse from top level for acc
	timerDone    : out std_logic; -- single-cycle pulse when countdown hits 0
	timeLeft     : out std_logic_vector(5 downto 0) -- remaining deci-seconds for display
	);
end timer;

architecture countdown of timer is

	type durationArray is array(1 to 10) of integer;  -- for values (0-63)
	constant DURATIONS : durationArray := (60, 45, 34, 25, 19, 14, 11, 8, 6, 5);

	signal count     : unsigned(5 downto 0);
	signal running   : std_logic;

begin

timer_register_process : process(clk)
begin
	if rising_edge(clk) then
		if reset = '0' then
			running <= '0';
			count   <= (others=>'0');
		elsif start = '1' then
			count   <= to_unsigned(DURATIONS(to_integer(unsigned(iteration))), 6);
			running <= '1';	
		elsif running = '1' and pulse_10hz = '1' then
			if count >= 1 then
				count   <= count - 1;
				if count = 1 then 
					running <= '0';
				end if;
			end if;
		end if;			
	end if;
end process timer_register_process;


timerDone <= '1' when (count = 1) and (pulse_10hz = '1') and (running = '1') else '0';
timeLeft <= std_logic_vector(count);

end countdown;
