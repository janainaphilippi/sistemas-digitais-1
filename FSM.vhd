library ieee;
use ieee.std_logic_1164.all; 

entity FSM is 
	port ( 
			Clock, Reset, Enter : in std_logic; 
			Operation: in std_logic_vector(1 downto 0); 
			Selection: out std_logic_vector(1 downto 0); 
			Enable_1, Enable_2: out std_logic 
			); 
end FSM; 

architecture FSM_beh of FSM is 
	type states is (S0, S1, S2, S3, S4, S5, S6, S7); 
	signal EA: states;
	signal last_sel, last_EN: std_logic_vector(1 downto 0);

begin 

	P1: process (Clock, Reset, Enter) 
		begin 
			-- não esquecer do end if;
			if Reset = '0' then 
				EA <= S0; 
			elsif Clock'event and Clock = '1' then 			
				case EA is
				
					when S0 =>
						if Enter = '0' then
							EA <= S1;
						else
							EA <= S0;
						end if;
					
					when S1 =>
						if Enter = '0' then
							EA <= S1;
						else
							EA <= S2;
						end if;
					
					when S2 =>
						if    Operation = "00" then 
							EA <= S3; -- Fazer SOMA 
						elsif Operation = "01" then 
							EA <= S4; -- Fazer SUB 
						elsif Operation = "10" then
							EA <= S5; -- Fazer *2
						else			 
							EA <= S6; -- Fazer /2
						end if;
					
					when S3 => --SOMA
						if Enter = '1' then
							EA <= S3;
						else
							EA <= S7;
						end if;
					
					when S4 => --SUB
						if Enter = '1' then
							EA <= S4;
						else
							EA <= S7;
						end if;
					
					when S5 => --*2
						EA <= S0;
						
					when S6 => --/2
						EA <= S0;
						
					when S7 =>
						if Enter = '0' then
							EA <= S7;
						else
							EA <= S0;
						end if;
						
				end case;
			end if;
	end process;
	
	P2: process(EA)
		begin
			case EA is

				when S0 =>
				Enable_1 <= '0';
				Enable_2 <= '0';
					
				when S1 =>
				Enable_1 <= '1';
				Enable_2 <= '0';

				when S2 =>
				Enable_1 <= '0';
				Enable_2 <= '0';
				last_sel <= Operation;
					
				when S3 => --SOMA
				--Enable_1 <= '0';
				--Enable_2 <= '0';
				Selection <= last_sel;
					
				when S4 => --SUB
				--Enable_1 <= '0';
				--Enable_2 <= '0';
				Selection <= last_sel;
					
				when S5 => --*2
				Enable_1 <= '0';
				Enable_2 <= '1';
				Selection <= last_sel;
				
						
				when S6 => --/2
				Enable_1 <= '0';
				Enable_2 <= '1';
				Selection <= last_sel;
						
				when S7 =>
				Enable_1 <= '0';
				Enable_2 <= '1';
				Selection <= last_sel;
				
			end case;
		end process;
end FSM_beh;

		
		
		