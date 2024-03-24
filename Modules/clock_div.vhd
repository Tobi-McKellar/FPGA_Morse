library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clock_div is
    generic(
        FREQ_IN : integer := 33_300_000;
        FREQ_OUT : integer := 500
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        clk_out : out std_logic
    );
end entity clock_div;

architecture behavioural of clock_div is

    constant MAX_COUNT : integer := (FREQ_IN / FREQ_OUT) - 1;

    signal s_cnt : integer range 0 to MAX_COUNT := 0;
    signal s_clk_out : std_logic := '0';

begin

    process(clk, rst) 
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_cnt <= 0;
                s_clk_out <= '0';
            elsif s_cnt = MAX_COUNT then
                s_clk_out <= not s_clk_out;
                s_cnt <= 0;
            else
                s_cnt <= s_cnt + 1;
            end if;
        end if;
    end process;
    clk_out <= s_clk_out;
end architecture behavioural;
