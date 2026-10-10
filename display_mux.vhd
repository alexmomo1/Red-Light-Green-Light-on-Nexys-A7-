-- Victor Alexandre Frings-Morales
-- ID : 40309808
-- COEN313 Red Light, Green Light
-- Due Date : April 24th 2026

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_mux is
	port (
	clk        : in  std_logic; -- horloge
	reset      : in  std_logic; 
	iteration  : in  std_logic_vector(3 downto 0);
	dist0      : in  std_logic_vector(3 downto 0);
	dist1      : in  std_logic_vector(3 downto 0);
	dist2      : in  std_logic_vector(3 downto 0);
	dist3      : in  std_logic_vector(3 downto 0);
	timeLeft   : in  std_logic_vector(5 downto 0);
	seg        : out std_logic_vector(6 downto 0); -- segments a-g 
	dp         : out std_logic;                    -- decimal point
	an         : out std_logic_vector(7 downto 0)  -- anode select
	);
end display_mux;

architecture mux_logic of display_mux is

	signal wholeSecs : unsigned(3 downto 0);
	signal tenths    : unsigned(3 downto 0);
	signal rotCount  : unsigned(2 downto 0); 
	signal clkDiv    : unsigned(16 downto 0); -- iteration through 8 display with refresh rate divided equally,  						 		  -- each can handle 1000Hz / 8 = 125Hz. need 100MHz / 1kHz = 2^17;
	signal digit     : unsigned(3 downto 0);
	signal showDP    : std_logic;
    
function to_seg(d : unsigned(3 downto 0)) return std_logic_vector is
begin
	case d is
		when "0000" => return "1000000"; -- 0
		when "0001" => return "1111001"; -- 1
		when "0010" => return "0100100"; -- 2
		when "0011" => return "0110000"; -- 3
		when "0100" => return "0011001"; -- 4
		when "0101" => return "0010010"; -- 5
		when "0110" => return "0000010"; -- 6
		when "0111" => return "1111000"; -- 7
		when "1000" => return "0000000"; -- 8
		when "1001" => return "0010000"; -- 9
		when others => return "1111111"; -- nothing
	end case;
end function;

begin

clock_divider_process : process(clk)
begin
	if rising_edge(clk) then
		if reset = '0' then
			clkDiv   <= (others => '0');
			rotCount <= (others => '0');
		elsif clkDiv = 99999 then
			clkDiv   <= (others => '0');
			rotCount <= rotCount + 1;
		else 
			clkDiv   <= clkDiv + 1;
		end if;
	end if;
end process clock_divider_process;

digi_deci_selection : process(rotCount, dist0, dist1, dist2, dist3, wholeSecs, tenths, iteration)
begin
	case rotCount is
		when "000" =>
			if unsigned(dist0) > 9 then
				showDP <= '1';
			else 
				showDP <= '0';
			end if;
			digit  <= unsigned(dist0) mod 10;
		when "001" =>
			if unsigned(dist1) > 9 then
				showDP <= '1';
			else 
				showDP <= '0';
			end if;
			digit  <= unsigned(dist1) mod 10;
		when "010" =>
			if unsigned(dist2) > 9 then
				showDP <= '1';
			else 
				showDP <= '0';
			end if;
			digit  <= unsigned(dist2) mod 10;
		when "011" =>
			if unsigned(dist3) > 9 then
				showDP <= '1';
			else 
				showDP <= '0';
			end if;
			digit  <= unsigned(dist3) mod 10;
		when "100" =>
			showDP <= '0';
			digit  <= unsigned(iteration) mod 10;
		when "101" =>
			showDP <= '0';
			if unsigned(iteration) > 9 then
				digit <= "0001";
			else
				digit <= "0000";
			end if;
		when "110" =>
			showDP <= '0';
			digit  <= tenths;
		when others =>
			showDP <= '1';
			digit  <= wholeSecs;
	end case; 
end process digi_deci_selection;

	wholeSecs <= resize(unsigned(timeLeft) / 10, 4);
	tenths    <= resize(unsigned(timeLeft) mod 10, 4);    
	seg <= to_seg(digit);
	dp  <= not showDP;

anode_select : for i in 0 to 7 generate
    	an(i) <= '0' when rotCount = i else '1';
end generate anode_select;

end mux_logic;
