
# Entity: top 
- **File**: top.vhd

## Diagram
![Diagram](top.svg "Diagram")
## Generics

| Generic name | Type      | Value      | Description |
| ------------ | --------- | ---------- | ----------- |
| START_BITS   | integer   | 1          |             |
| DATA_BITS    | integer   | 8          |             |
| STOP_BITS    | integer   | 1          |             |
| BAUD_RATE    | integer   | 9600       |             |
| CLOCK_FREQ   | integer   | 33_300_000 |             |
| ACTIVE_STATE | std_logic | '0'        |             |
| DATA_WIDTH   | integer   | 8          |             |
| DATA_DEPTH   | integer   | 64         |             |
| REFRESH_RATE | integer   | 600        |             |
| UPDATE_RATE  | integer   | 1          |             |

## Ports

| Port name | Direction | Type      | Description |
| --------- | --------- | --------- | ----------- |
| clk       | in        | std_logic |             |
| uart_rx   | in        | std_logic |             |
| uart_tx   | out       | std_logic |             |
| dot       | out       | std_logic |             |
| dash      | out       | std_logic |             |
| cathode0  | out       | std_logic |             |
| cathode1  | out       | std_logic |             |
| cathode2  | out       | std_logic |             |
| cathode3  | out       | std_logic |             |
| cathode4  | out       | std_logic |             |
| tick      | out       | std_logic |             |

## Signals

| Name          | Type                         | Description |
| ------------- | ---------------------------- | ----------- |
| rst           | std_logic                    |             |
| rx_data       | std_logic_vector(7 downto 0) |             |
| rx_done       | std_logic                    |             |
| read_rx_fifo  | std_logic                    |             |
| rx_fifo_in    | std_logic_vector(7 downto 0) |             |
| rx_fifo_out   | std_logic_vector(7 downto 0) |             |
| rx_fifo_empty | std_logic                    |             |
| loopback      | std_logic                    |             |
| tx_data       | std_logic_vector(7 downto 0) |             |
| send_byte     | std_logic                    |             |
| tx_active     | std_logic                    |             |
| read_tx_fifo  | std_logic                    |             |
| tx_fifo_in    | std_logic_vector(7 downto 0) |             |
| tx_fifo_out   | std_logic_vector(7 downto 0) |             |
| display_clk   | std_logic                    |             |
| dots          | std_logic_vector(4 downto 0) |             |
| dashes        | std_logic_vector(4 downto 0) |             |
| s_cathode     | std_logic_vector(4 downto 0) |             |
| s_cnt         | integer                      |             |
| s_tick        | std_logic                    |             |

## Instantiations

- rx_inst: work.uart_rx(behavioural)
- rx_fifo_inst: work.circularfifobuffer(behavioural)
- tx_inst: work.uart_tx(behavioural)
- tx_fifo_inst: work.circularfifobuffer(behavioural)
- display_clk_inst: work.clock_div(behavioural)
- char_to_morse_7seg_inst: work.char_to_morse_7seg(behavioural)
- display_inst: work.morse_display(behavioural)
