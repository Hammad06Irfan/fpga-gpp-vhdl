library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_core3 is
    port(
        Clock      : in  std_logic;               -- not used logically (for compatibility)
        A, B       : in  unsigned(7 downto 0);    -- B not used here
        student_id : in  unsigned(3 downto 0);    -- 4-bit digit from FSM
        OP         : in  unsigned(15 downto 0);   -- microcode (not needed for logic)
        sign       : out std_logic;               -- always '0' in this design
        R1         : out unsigned(3 downto 0);    -- 4-bit code: 1111 = 'y', 0000 = 'n'
        R2         : out unsigned(3 downto 0)     -- unused, kept as 0000
    );
end alu_core3;

architecture behavior of alu_core3 is
    signal A_high    : unsigned(3 downto 0);
    signal A_low     : unsigned(3 downto 0);
    signal result_cd : unsigned(3 downto 0) := (others => '0');
begin

    -- Split A into its two 4-bit digits
    A_high <= A(7 downto 4);
    A_low  <= A(3 downto 0);

    -- Combinational logic: option g condition
    process(A_high, A_low, student_id, OP)
    begin
        -- Default
        result_cd <= (others => '0');
        sign      <= '0';

        -- Option g:
        -- 'y' if one of the 2 digits of A equals student_id
        if (A_high = student_id) or (A_low = student_id) then
            -- code for "y"
            result_cd <= "1111";
        else
            -- code for "n"
            result_cd <= "0000";
        end if;
    end process;

    -- Map internal result to outputs
    R1 <= result_cd;                -- used by y/n 7-segment driver
    R2 <= (others => '0');          -- unused for Problem 3

end behavior;
