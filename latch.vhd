LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY latch IS
    PORT ( 
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);        -- 8 bit A input
        Resetn, Clock : IN STD_LOGIC;               -- 1 bit clock input and 1 bit reset input
        Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)        -- 8 bit output
    );
END latch;

ARCHITECTURE Behavior OF latch IS
BEGIN
    PROCESS (Resetn, Clock, A)  -- Process takes reset, clock, and A as inputs for level-sensitive behavior
    BEGIN
        IF Resetn = '0' THEN                        -- when reset input is '0' the output is cleared
            Q <= "00000000";
        ELSIF Clock = '1' THEN                      -- level sensitive - transparent when clock is high
            Q <= A;
        END IF;
    END PROCESS;
END Behavior;