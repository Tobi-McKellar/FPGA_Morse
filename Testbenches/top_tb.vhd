library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is

    constant CLK_PERIOD : time := 30.303 ns;

    signal simDone : boolean := false;
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal uart_rx : std_logic := '0';
    signal uart_tx : std_logic := '0';
    signal dot : std_logic := '0';
    signal dash : std_logic := '0';
    signal cathode : std_logic_vector(4 downto 0) := (others => '0');

    signal byte_to_transmit : std_logic_vector(7 downto 0) := (others => '0');
    signal send_byte : std_logic := '0';
    signal tx_serial_out : std_logic := '0';
    signal tx_active : std_logic := '0';


    begin

    top_inst : entity work.top(structural)
    generic map (
        refresh_rate => 5000,
        update_rate => 1000,
        baud_rate => 19200
    )
        port map(
            clk => clk,
            -- rst => rst,
            uart_rx => tx_serial_out,
            uart_tx => uart_tx,
            dot => dot,
            dash => dash,
            cathode0 => cathode(0),
            cathode1 => cathode(1),
            cathode2 => cathode(2),
            cathode3 => cathode(3),
            cathode4 => cathode(4)
            );

    uart_tx_inst : entity work.uart_tx(behavioural)
        generic map (
            START_BITS => 1,
            DATA_BITS => 8,
            STOP_BITS => 1,
            BAUD_RATE => 19200,
            CLOCK_FREQ => 33_300_000,
            ACTIVE_STATE => '0'
        )
        port map (
            clk => clk,
            reset => rst,
            byte_to_transmit => byte_to_transmit,
            send_byte => send_byte,
            tx_serial_out => tx_serial_out,
            tx_active => tx_active
        );
    
    serial_process : process
    begin
        wait for 100 us;
        send_byte <= '1';
        byte_to_transmit <= X"67";
        wait until tx_active = '0';
     

        -- byte_to_transmit <= X"68";
        -- wait until tx_active = '0';


        byte_to_transmit <= X"69";
        wait until tx_active = '0';


        byte_to_transmit <= X"30";
        wait until tx_active = '0';


        -- byte_to_transmit <= X"31";
        -- wait until tx_active = '0';


        byte_to_transmit <= X"32";
        wait for 100 us;
        send_byte <= '0';

        wait for 10 ms;
        simDone <= true;
        wait;
    end process;

    clk_process : process
    begin 
        if simDone then
            wait;
        else
            clk <= '1';
            wait for CLK_PERIOD/2;
            clk <= '0';
            wait for CLK_PERIOD/2;
        end if;
    end process;
end architecture sim;