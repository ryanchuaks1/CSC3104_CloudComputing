import bluetooth
from ble_simple_peripheral import BLESimplePeripheral
import time
import machine

ble = bluetooth.BLE()

sp = BLESimplePeripheral(ble)

debounce_time = 0

while True:
    
    # Check if the BLE connection is established
    if sp.is_connected():
        msg = machine.unique_id()
        sp.send(msg)
    
    time.sleep(5)