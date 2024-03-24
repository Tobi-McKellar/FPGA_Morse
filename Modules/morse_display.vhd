library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- This module assumes a common cathode 7-segment display. 

entity morse_display is
    port (
        clk : in std_logic;
        reset : in std_logic;
        dots : in std_logic_vector(4 downto 0);
        dashes : in std_logic_vector(4 downto 0);
        dot : out std_logic;
        dash : out std_logic;
        cathode : out std_logic_vector(4 downto 0)
    );
end entity morse_display;

architecture behavioural of morse_display is
    signal counter : integer range 0 to 4 := 0;
begin
    process(clk, reset)
    begin
        if rising_edge(clk) then
            if counter = 4 then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    with counter select
         cathode <= "01111" when 0,
                    "10111" when 1,
                    "11011" when 2,
                    "11101" when 3,
                    "11110" when 4,
                    "11111" when others;
    
    dot <= dots(counter);
    dash <= dashes(counter);
    

end architecture behavioural;