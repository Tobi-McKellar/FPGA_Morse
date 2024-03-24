# This script has been designed with the purpose of testing the serial communication using 
# ADAFRUIT FT232H Breakout - General Purpose USB to GPIO, SPI, I2C - USB C & Stemma QT

import serial
import time
import serial.tools.list_ports as list_ports


# List all available ports
comlist = list_ports.comports()

# Find the correct USB device
usbserial = [str(x) for x in comlist if 'usbserial-' in str(x)]

# Format the device name as a string and remove anything after a space
usbserial = str(usbserial[0]).split(' ')[0].rstrip()

# Open serial connection
ser = serial.Serial(usbserial, 9600, timeout=1)
print(f"Opened serial communications using port: {usbserial}")

try:
    while True:
        # Accept user input
        user_input = input("Enter data to send (or 'q' to quit): ")

        # Check if user wants to quit
        if user_input == 'q':
            break
        else:
            user_input = ' ' + user_input

        # Convert input to bytes
        data_to_send = user_input.encode()

        # Write data
        ser.write(data_to_send)

        # Delay to allow time for the loopback
        time.sleep(.1)

        # Read data (echoed back from the device)
        try:
            data_received = ser.read(len(data_to_send))
        except:
            pass
        # Print sent and received data
        print(f'Sent: {data_to_send}')
        print(f'Received: {data_received}')

    # Check if received data matches sent data
    if data_received == data_to_send:
        print("Loopback test successful!")
    else:
        print("Loopback test failed.")

except Exception as e:
    print(f'Error: {e}')

finally:
    # Close serial connection
    ser.close()