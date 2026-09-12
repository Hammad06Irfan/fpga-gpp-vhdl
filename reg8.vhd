LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg8 IS
    PORT ( 
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);        -- 8 bit A input
        Resetn, Clock : IN STD_LOGIC;               -- 1 bit clock input and 1 bit reset input
        Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)        -- 8 bit output
    );
END reg8;

ARCHITECTURE Behavior OF reg8 IS
BEGIN
    PROCESS (Resetn, Clock, A)
    BEGIN
        IF Resetn = '0' THEN
            Q <= "00000000";
        ELSIF Clock = '1' THEN
            Q <= A;  -- Transparent when clock is high
        END IF;
        -- Note: When Clock = '0', Q holds its previous value
    END PROCESS;
END Behavior;