library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity top is
    generic (
        -- UART parameters
        START_BITS : integer := 1;
        DATA_BITS : integer := 8;
        STOP_BITS : integer := 1;
        BAUD_RATE : integer := 9600;
        CLOCK_FREQ : integer := 33_300_000;
        ACTIVE_STATE : std_logic := '0';

        -- FIFO parameters
        DATA_WIDTH : integer := 8;
        DATA_DEPTH : integer := 64;

        -- Display parameters
        REFRESH_RATE : integer := 600; -- 600/5 = 120
        UPDATE_RATE : integer := 1 -- reads 2 chars per second
    );
    port (
        clk : in std_logic;
        -- rst : in std_logic;
        uart_rx : in std_logic;
        uart_tx : out std_logic;
        dot : out std_logic;
        dash : out std_logic;
        cathode0 : out std_logic;
        cathode1 : out std_logic;
        cathode2 : out std_logic;
        cathode3 : out std_logic;
        cathode4 : out std_logic;
        tick : out std_logic
    );
end entity top;

architecture structural of top is

    signal rst : std_logic := '0';

    -- UART rx signals
    signal rx_data : std_logic_vector(7 downto 0);
    signal rx_done : std_logic;
    signal read_rx_fifo : std_logic;
    signal rx_fifo_in : std_logic_vector(7 downto 0);
    signal rx_fifo_out : std_logic_vector(7 downto 0);
    signal rx_fifo_empty : std_logic;

    -- loopback wire
    signal loopback : std_logic;

    -- UART tx signals
    signal tx_data : std_logic_vector(7 downto 0);
    signal send_byte : std_logic;
    signal tx_active : std_logic;
    signal read_tx_fifo : std_logic;
    signal tx_fifo_in : std_logic_vector(7 downto 0);
    signal tx_fifo_out : std_logic_vector(7 downto 0);

    -- Display signals
    signal display_clk : std_logic;
    signal dots : std_logic_vector(4 downto 0);
    signal dashes : std_logic_vector(4 downto 0);
    signal s_cathode : std_logic_vector(4 downto 0);

    signal s_cnt : integer := 0;
    signal s_tick : std_logic := '0';
    begin

    tick <= display_clk;
        -- process(display_clk) 
        -- begin
        --     if rising_edge(display_clk) then
        --         if s_cnt = 10 then
        --             s_cnt <= 0;
        --             s_tick <= not s_tick;
        --         else
        --             s_cnt <= s_cnt + 1;
        --         end if;
        --     end if;
        -- end process;

    loopback <= uart_rx;
    uart_tx <= loopback;

    rx_inst : entity work.uart_rx(behavioural)
        generic map (
            baud_rate => BAUD_RATE,
            clock_freq => CLOCK_FREQ,
            start_bits => START_BITS,
            data_bits => DATA_BITS,
            stop_bits => STOP_BITS,
            active_state => ACTIVE_STATE
        )
        port map (
            clk => clk,
            reset => rst,
            rx_serial_in => uart_rx,
            rx_byte_out => rx_fifo_in,
            rx_byte_valid => rx_done
        );

    rx_fifo_inst : entity work.circularfifobuffer(behavioural)
    generic map (
        DATA_WIDTH => DATA_WIDTH,
        DATA_DEPTH => DATA_DEPTH
    )
    port map (
        clk => clk,
        rst => rst,
        write_fifo => rx_done,
        read_fifo => read_rx_fifo,
        data_in => rx_fifo_in,
        data_out => rx_fifo_out,
        fifo_empty => rx_fifo_empty
        -- fifo_full => open,
        -- stored_elements => open
    );

    tx_inst : entity work.uart_tx(behavioural)
    generic map (
        baud_rate => BAUD_RATE,
        clock_freq => CLOCK_FREQ,
        start_bits => START_BITS,
        data_bits => DATA_BITS,
        stop_bits => STOP_BITS,
        active_state => ACTIVE_STATE
    )
    port map (
        clk => clk,
        reset => rst,
        byte_to_transmit => tx_fifo_out,
        send_byte => send_byte,
        tx_serial_out => open,
        tx_active => tx_active
    );

    tx_fifo_inst : entity work.circularfifobuffer(behavioural)
    generic map (
        DATA_WIDTH => DATA_WIDTH,
        DATA_DEPTH => DATA_DEPTH
    )
    port map (
        clk => clk,
        rst => rst,
        write_fifo => '0',
        read_fifo => read_tx_fifo,
        data_in => tx_fifo_in,
        data_out => tx_fifo_out,
        fifo_empty => open
        -- fifo_full => open,
        -- stored_elements => open
    );

    display_clk_inst : entity work.clock_div(behavioural)
    generic map (
        FREQ_IN => CLOCK_FREQ,
        FREQ_OUT => REFRESH_RATE
    )
    port map (
        clk => clk,
        rst => rst,
        clk_out => display_clk
    );


    char_to_morse_7seg_inst : entity work.char_to_morse_7seg(behavioural)
        generic map (
            clk_freq => CLOCK_FREQ,
            read_freq => UPDATE_RATE
        )
        port map(
            clk => clk,
            reset => rst,
            get_char => read_rx_fifo,
            char => rx_fifo_out,
            dots => dots,
            dashes => dashes,
            fifo_empty => rx_fifo_empty
        );

    display_inst : entity work.morse_display(behavioural)
    port map (
        clk => display_clk,
        reset => rst,
        dots => dots,
        dashes => dashes,
        dot => dot,
        dash => dash,
        cathode => s_cathode
    );

    cathode0 <= s_cathode(0);
    cathode1 <= s_cathode(1);
    cathode2 <= s_cathode(2);
    cathode3 <= s_cathode(3);
    cathode4 <= s_cathode(4);

end architecture structural;
