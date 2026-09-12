library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alucore2 is
    port(
        Clock      : in  std_logic;
        A, B       : in  unsigned(7 downto 0);
        student_id : in  unsigned(3 downto 0);
        OP         : in  unsigned(15 downto 0);
        sign       : out std_logic;
        R1         : out unsigned(3 downto 0);
        R2         : out unsigned(3 downto 0)
    );
end alucore2;

architecture calculation of alucore2 is
    signal Result : unsigned(7 downto 0) := (others => '0');
begin

    -- COMBINATIONAL PROCESS
    process(A, B, OP)
    begin
        -- default values
        Result <= (others => '0');
        sign   <= '0';

        case OP is

            -- 1) Invert the bit-significance order of A
            --    (bit-reverse A)
            when "0000000000000001" =>
                Result(7) <= A(0);
                Result(6) <= A(1);
                Result(5) <= A(2);
                Result(4) <= A(3);
                Result(3) <= A(4);
                Result(2) <= A(5);
                Result(1) <= A(6);
                Result(0) <= A(7);

            -- 2) Shift A to left by 4 bits, input bit = 1 (SHL)
            --    new low 4 bits are '1'
            when "0000000000000010" =>
                Result <= A(3 downto 0) & "1111";

            -- 3) Invert upper four bits of B
            when "0000000000000100" =>
                Result(7 downto 4) <= NOT B(7 downto 4);
                Result(3 downto 0) <= B(3 downto 0);

            -- 4) Min(A, B)
            when "0000000000001000" =>
                if A <= B then
                    Result <= A;
                else
                    Result <= B;
                end if;

            -- 5) (A + B) + 4
            when "0000000000010000" =>
                Result <= A + B + to_unsigned(4, 8);

            -- 6) Increment A by 3
            when "0000000000100000" =>
                Result <= A + to_unsigned(3, 8);

            -- 7) Replace the even bits of A with even bits of B
            --    even bit positions: 0,2,4,6  (LSB is bit 0)
            when "0000000001000000" =>
                Result(0) <= B(0);
                Result(2) <= B(2);
                Result(4) <= B(4);
                Result(6) <= B(6);

                Result(1) <= A(1);
                Result(3) <= A(3);
                Result(5) <= A(5);
                Result(7) <= A(7);

            -- 8) XNOR(A, B)
            when "0000000010000000" =>
                Result <= NOT (A XOR B);

            -- 9) Rotate B to right by 3 bits (ROR)
            --    result = B(2 downto 0) & B(7 downto 3)
            when "0000000100000000" =>
                Result <= B(2 downto 0) & B(7 downto 3);

            when others =>
                Result <= (others => '0');
                sign   <= '0';
        end case;
    end process;

    -- Split 8-bit result into two nibbles for display
    R1 <= Result(3 downto 0);
    R2 <= Result(7 downto 4);

end calculation;
