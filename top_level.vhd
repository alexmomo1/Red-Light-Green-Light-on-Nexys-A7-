-- Victor Alexandre Frings-Morales
-- ID : 40309808
-- COEN313 Red Light, Green Light
-- Due Date : April 24th 2026

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
	port (
	clk   : in  std_logic;
	reset : in  std_logic;
	button: in  std_logic;
	sw    : in  std_logic_vector(3 downto 0);
	led   : out std_logic_vector(3 downto 0);
	seg   : out std_logic_vector(6 downto 0);
	dp    : out std_logic;
	redLed: out std_logic;
	greenLed: out std_logic;
	an    : out std_logic_vector(7 downto 0)
	);
end top_level;

architecture structural of top_level is

	signal count_1hz			: unsigned(26 downto 0); -- counts 100Mhz
	signal count_10hz			: unsigned(23 downto 0);
	signal pulse_10hz			: std_logic;
	signal pulse_1hz			: std_logic;
	signal btnPulse				: std_logic; 
	signal timerStart			: std_logic;
	signal timerDone			: std_logic;
	signal iteration			: std_logic_vector(3 downto 0);
	signal timeLeft				: std_logic_vector(5 downto 0);
	signal playerEn				: std_logic_vector(3 downto 0);
	signal eliminated			: std_logic_vector(3 downto 0);
	signal playersAt12			: std_logic_vector(3 downto 0);
	signal winner				: std_logic_vector(3 downto 0);
	signal dist0, dist1, dist2, dist3	: std_logic_vector(3 downto 0);
	signal previousBtn			: std_logic;
	signal isRed				: std_logic;
	signal isGreen				: std_logic;

component fsm_controller is
	port (
	clk, reset, btnStart, timerDone		     : in std_logic;
	sw, playersAt12				     : in std_logic_vector(3 downto 0);
	timerStart, isGreen, isRed		     : out std_logic;
	iteration, playerEn, eliminated, led, winner : out std_logic_vector(3 downto 0)
	);
end component;

component timer is
	port (
	clk, reset, pulse_10hz, start	: in std_logic;
	iteration			: in std_logic_vector(3 downto 0);
	timerDone			: out std_logic;
	timeLeft 			: out std_logic_vector(5 downto 0)
	);
end component;

component player is
	port ( 
	clk, reset, sw, en, pulse_1hz		: in std_logic;
	distance				: out std_logic_vector(3 downto 0);
	at12					: out std_logic
	);
end component;

component display_mux is
	port (
	clk, reset				: in std_logic;
	iteration, dist0, dist1, dist2, dist3	: in std_logic_vector(3 downto 0);
	timeLeft				: in std_logic_vector(5 downto 0);
	seg					: out std_logic_vector(6 downto 0);
	dp					: out std_logic;
	an 					: out std_logic_vector(7 downto 0)
	);
end component;

begin

pulse_process : process(clk)
begin
	if rising_edge(clk) then
		pulse_1hz <= '0';
		pulse_10hz <= '0';
		if reset = '0' then
            		count_1hz  <= (others => '0');
			count_10hz <= (others => '0');
		else
			if count_10hz = 9999999 then
				pulse_10hz <= '1';
				count_10hz <= (others => '0');
			else 
				count_10hz <= count_10hz + 1;
			end if;
			if count_1hz = 99999999 then
				pulse_1hz <= '1';
				count_1hz <= (others => '0');
			else 
				count_1hz <= count_1hz + 1;
			end if;
		end if;
	end if;
end process pulse_process;

button_process : process(clk)
begin
	if rising_edge(clk) then 
		previousBtn <= button;
		btnPulse <= button and not previousBtn;
	end if;
end process button_process;

redLed<=isRed;
greenLed<=isGreen;

FSM : fsm_controller port map (
	clk=>clk, reset=>reset, btnStart=>btnPulse, timerDone=>timerDone, sw=>sw, playersAt12=>playersAt12, timerStart=>timerStart, 	iteration=>iteration, playerEn=>playerEn, eliminated=>eliminated, led=>led, winner=>winner, isGreen=>isGreen, isRed=>isRed
);

TIMER1 : timer port map (
	clk=>clk, reset=>reset, pulse_10hz=>pulse_10hz, start=>timerStart, iteration=>iteration, timerDone=>timerDone, timeLeft=>timeLeft
);

p0 : player port map(
	clk=>clk, reset=>reset, sw=>sw(0), en=>playerEn(0), pulse_1hz=>pulse_1hz, distance=>dist0, at12=>playersAt12(0)
);
p1 : player port map(
	clk=>clk, reset=>reset, sw=>sw(1), en=>playerEn(1), pulse_1hz=>pulse_1hz, distance=>dist1, at12=>playersAt12(1)
);
p2 : player port map (
	clk=>clk, reset=>reset, sw=>sw(2), en=>playerEn(2), pulse_1hz=>pulse_1hz, distance=>dist2, at12=>playersAt12(2)
);
p3 : player port map (
	clk=>clk, reset=>reset, sw=>sw(3), en=>playerEn(3), pulse_1hz=>pulse_1hz, distance=>dist3, at12=>playersAt12(3)
);

DISPLAY : display_mux port map (
	clk=>clk, reset=>reset, iteration=>iteration,dist0=>dist0, dist1=>dist1, dist2=>dist2, dist3=>dist3, timeLeft=>timeLeft, 	seg=>seg, dp=>dp, an=>an
);

end structural;
