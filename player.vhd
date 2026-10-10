-- Victor Alexandre Frings-Morales
-- ID : 40309808
-- COEN313 Red Light, Green Light
-- Due Date : April 24th 2026

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity player is
	port (
	clk         : in  std_logic; -- clack 
	reset       : in  std_logic; 
	sw          : in  std_logic; -- this player's slide switch
	en          : in  std_logic; -- movement enable from FSM
	pulse_1hz   : in  std_logic; -- 1-second enable pulse
	distance    : out std_logic_vector(3 downto 0); -- 0-12 meters
	at12        : out std_logic  -- '1' when distance >= 12
	);
end player;

architecture player_logic of player is

	signal distanceReg : unsigned(3 downto 0);

begin
distance_counter_process : process(clk)
    begin
        if rising_edge(clk) then
		if reset = '0' then
			distanceReg <= "0000";
		elsif pulse_1hz = '1' and en = '1' and sw = '1' and distanceReg < 12 then 
			distanceReg <= distanceReg + 1;
		end if;
	end if;
end process distance_counter_process;
	
	distance <= std_logic_vector(distanceReg);
	at12    <= '1' when distanceReg >= 12 else '0';

end player_logic;
