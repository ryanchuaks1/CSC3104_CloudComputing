import bluetooth
from ble_simple_peripheral import BLESimplePeripheral
import time
import machine
import ubinascii
import uos
from ucryptolib import aes

MODE_ECB = 1
MODE_CBC = 2
MODE_CTR = 6
BLOCK_SIZE = 16
key = b'E8B6C00C9ADC5E75BB656ECD429CB164'
iv = b'3A25B111FCD22C66'

def encrypt(key, iv, message):
    pad = BLOCK_SIZE - len(message) % BLOCK_SIZE
    plaintext = message + " "*pad
    
    cipher = aes(key, MODE_CBC, iv)
    ct_bytes = iv + cipher.encrypt(plaintext)
    
    return ct_bytes

def decrypt(key, iv, cipher_bytes):
    iv = cipher_bytes[:BLOCK_SIZE]
    cipher = aes(key, MODE_CBC, iv)
    decrypted = cipher.decrypt(ct_bytes)[BLOCK_SIZE:]
    
    return decrypted

    

#plaintext = 'This is AES cryptographic'
#ct_bytes = encrypt(key, iv, plaintext)
#decrypted = decrypt(key, iv, ct_bytes)
#print('AES-CBC decrypted:', decrypted)

def bluetooth_init():
    ble = bluetooth.BLE()
    
    sp = BLESimplePeripheral(ble)
    
    return sp

def advertise_bluetooth_message(sp, message):
    
    # Checks if a device is connected
    #
    if sp.is_connected():
        print(message)
        sp.send(message)
    
    return;

sp = bluetooth_init()
hwid = machine.unique_id()
ct_bytes = encrypt(key, iv, hwid)
ct = ubinascii.hexlify(ct_bytes).decode('utf-8')
print(ct)
while True:
    advertise_bluetooth_message(sp, ct)
    
    time.sleep(0.2)