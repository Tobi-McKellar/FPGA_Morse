library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- This module is designed to take an 8-bit ASCII character and convert it to a 5-bit morse code representation.
-- The module has two outputs, dots and dashes, which represent the morse code for the input character. 
-- The dots and dashes will be superimposed on the 7-segment display to represent the morse code for the input character.
-- The module is specifically designed for a 5-digit 7-segment display with common cathode configuration.

entity char_to_morse_7seg is
    generic(
        CLK_FREQ : integer := 33_300_000;
        READ_FREQ : integer := 2
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        char : in std_logic_vector(7 downto 0);
        dots : out std_logic_vector(4 downto 0);
        fifo_empty : in std_logic;
        get_char : out std_logic;

        dashes : out std_logic_vector(4 downto 0)
    );
end char_to_morse_7seg;

architecture behavioural of char_to_morse_7seg is
    constant MAX_COUNT : integer := CLK_FREQ / READ_FREQ - 1;
    signal s_char : character := ' '; -- use internal character type to make code easier to read
    signal s_counter : integer range 0 to MAX_COUNT := 0;

begin

s_char <= character'val(to_integer(unsigned(char)));

    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                get_char <= '0';
            elsif s_counter = MAX_COUNT and fifo_empty = '0' then
                get_char <= '1';
                s_counter <= 0;
            elsif s_counter < MAX_COUNT then
                s_counter <= s_counter + 1;
                get_char <= '0';
            end if;
        end if;
    end process;

with s_char select dots <= 
    "00000" when '0', -- "-----",
    "10000" when '1', -- ".----",
    "11000" when '2', -- "..---",
    "11100" when '3', -- "...--",
    "11110" when '4', -- "....-",
    "11111" when '5', -- ".....",
    "01111" when '6', -- "-....",
    "00111" when '7', -- "--...",
    "00011" when '8', -- "---..",
    "00001" when '9', -- "----.",
    "10000" when 'a', -- ".-",
    "01110" when 'b', -- "-...",
    "01010" when 'c', -- "-.-.",
    "01100" when 'd', -- "-..",
    "10000" when 'e', -- ".",
    "11010" when 'f', -- "..-.",
    "00100" when 'g', -- "--.",
    "11110" when 'h', -- "....",
    "11000" when 'i', -- "..",
    "10000" when 'j', -- ".---",
    "01000" when 'k', -- "-.-",
    "10110" when 'l', -- ".-..",
    "00000" when 'm', -- "--",
    "01000" when 'n', -- "-.",
    "00000" when 'o', -- "---",
    "10010" when 'p', -- ".--.",
    "00100" when 'q', -- "--.-",
    "10100" when 'r', -- ".-.",
    "11100" when 's', -- "...",
    "00000" when 't', -- "-",
    "11000" when 'u', -- "..-",
    "11100" when 'v', -- "...-",
    "10000" when 'w', -- ".--",
    "01100" when 'x', -- "-..-",
    "01000" when 'y', -- "-.--",
    "00110" when 'z', -- "--..",
    "00000" when ' ',  -- " "
    "11111" when others;

    with s_char select dashes <=
    "11111" when '0', -- "-----",
    "01111" when '1', -- ".----",
    "00111" when '2', -- "..---",
    "00011" when '3', -- "...--",
    "00001" when '4', -- "....-",
    "00000" when '5', -- ".....",
    "10000" when '6', -- "-....",
    "11000" when '7', -- "--...",
    "11100" when '8', -- "---..",
    "11110" when '9', -- "----.",
    "01000" when 'a', -- ".-",
    "10000" when 'b', -- "-...",
    "10100" when 'c', -- "-.-.",
    "10000" when 'd', -- "-..",
    "00000" when 'e', -- ".",
    "00100" when 'f', -- "..-.",
    "11000" when 'g', -- "--.",
    "00000" when 'h', -- "....",
    "00000" when 'i', -- "..",
    "01110" when 'j', -- ".---",
    "10100" when 'k', -- "-.-",
    "01000" when 'l', -- ".-..",
    "11000" when 'm', -- "--",
    "10000" when 'n', -- "-.",
    "11100" when 'o', -- "---",
    "01100" when 'p', -- ".--.",
    "11010" when 'q', -- "--.-",
    "01000" when 'r', -- ".-.",
    "00000" when 's', -- "...",
    "10000" when 't', -- "-",
    "00100" when 'u', -- "..-",
    "00010" when 'v', -- "...-",
    "01100" when 'w', -- ".--",
    "10010" when 'x', -- "-..-",
    "10110" when 'y', -- "-.--",
    "11000" when 'z', -- "--..",
    "00000" when ' ',  -- " "
    "11111" when others;

end architecture;