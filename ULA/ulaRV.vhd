LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity ulaRV is 
	generic( DATA_WIDTH : natural := 32);
	port( op	: in std_logic_vector(3 downto 0);							-- operacao a ser realizada
			A, B		: in std_logic_vector(DATA_WIDTH-1 downto 0);	-- operandos 32 bits
			result	: out std_logic_vector(DATA_WIDTH-1 downto 0));	-- sai­da 32 bits
			--zero		: out std_logic );									-- indicacao de zero na saida
end ulaRV;

architecture ula of ulaRV is

signal z32 : std_logic_vector(DATA_WIDTH-1 downto 0);
constant ZERO32 : std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000000";
constant UM32 : std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000001";

begin 
	--zero <= '1' when z32 = ZERO32 else '0';
	result <= z32;
	ula_process : process(op, A, B)
	begin 
		case op is
			when "0000" => z32 <= std_logic_vector(unsigned(a) + unsigned(b));  								-- ADD
			when "0001" => z32 <= std_logic_vector(unsigned(a) - unsigned(b));								-- SUB
			when "0010" => z32 <= std_logic_vector(unsigned(a) AND unsigned(b));								-- AND
			when "0011" => z32 <= std_logic_vector(unsigned(a) OR unsigned(b));								-- OR
			when "0100" => z32 <= std_logic_vector(unsigned(a) XOR unsigned(b));								-- XOR
			when "0101" => z32 <= std_logic_vector(shift_left(unsigned(a), to_integer(unsigned(b))));	-- SLL A deslocada de B bits à esquerda
			when "0110" => z32 <= std_logic_vector(shift_right(unsigned(a), to_integer(unsigned(b))));-- SRL
			when "0111" => z32 <= std_logic_vector(shift_right(signed(a), to_integer(unsigned(b))));	-- SRA
			when "1000" => 	if(signed(a) < signed(b)) then  z32 <= UM32;										-- SLT result=1 se A < B, com sinal
									else z32 <= ZERO32;
									end if;			
			when "1001" => 	if(unsigned(a) < unsigned(b)) then z32 <= UM32;									-- SLTU result=1 se A < B, sem sinal
									else z32 <= ZERO32;
									end if;
			when "1010" => 	if(signed(a) >= signed(b)) then z32 <= UM32;										-- SGE result=1 se A >= B com sinal
									else z32 <= ZERO32;
									end if;
			when "1011" => 	if(unsigned(a) >= unsigned(b)) then z32 <= UM32;								-- SGEU result=1 se A >= B sem sinal
									else z32 <= ZERO32;
									end if;
			when "1100" => 	if(unsigned(a) = unsigned(b)) then  z32 <= UM32;								-- SEQ result=1 se A == B
									else z32 <= ZERO32;
									end if;
			when "1101" => 	if(unsigned(a) /= unsigned(b)) then z32 <= UM32;								-- SNE result=1 se A != B 
									else z32 <= ZERO32;
									end if;						
			when others => z32 <= ZERO32;
		end case;
	end process;
end ula;