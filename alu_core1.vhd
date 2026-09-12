library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_core1 is
    port(
        Clock   : in std_logic;
        A, B    : in unsigned(7 downto 0);
        student_id : in unsigned(3 downto 0);
        OP      : in unsigned(15 downto 0);
        sign     : out std_logic;
        R1      : out unsigned(3 downto 0);
        R2      : out unsigned(3 downto 0)
    );
end alu_core1;

architecture calculation of alu_core1 is
    signal Result : unsigned(7 downto 0) := (others => '0');
begin

    -- COMBINATIONAL PROCESS (no clock dependency)
    process(A, B, OP)
    begin
        case OP is
            when "0000000000000001" => 
                -- Addition: A + B
                Result <= A + B;
                sign <= '0';
                
            when "0000000000000010" => 
					-- Subtraction: A - B (not absolute value)
				if A >= B then
						Result <= A - B;
						sign <= '0';
				else
					-- For A < B, use 2's complement for negative result
					Result <= (NOT(B - A)) + 1;  -- Proper 2's complement
					sign <= '1';
				end if;
                
            when "0000000000000100" => 
                -- Inverse of A
                Result <= NOT A;
                sign <= '0';
                
            when "0000000000001000" => 
                -- NAND: NOT (A AND B)
                Result <= NOT (A AND B);
                sign <= '0';
                
            when "0000000000010000" => 
                -- NOR: NOT (A OR B)
                Result <= NOT (A OR B);
                sign <= '0';
                
            when "0000000000100000" => 
                -- AND: A AND B
                Result <= A AND B;
                sign <= '0';
                
            when "0000000001000000" => 
                -- XOR: A XOR B  
                Result <= A XOR B;
                sign <= '0';
                
            when "0000000010000000" => 
                -- OR: A OR B  
                Result <= A OR B;
                sign <= '0';
                
            when "0000000100000000" => 
                -- XNOR: NOT (A XOR B)
                Result <= NOT (A XOR B);
                sign <= '0';
                
            when others =>
                Result <= (others => '0');
                sign <= '0';
        end case;
    end process;

    R1 <= Result(3 downto 0);
    R2 <= Result(7 downto 4);

end calculation;