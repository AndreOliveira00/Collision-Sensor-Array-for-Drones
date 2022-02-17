
import serial
import time

#/dev/ttyACM0
ser = serial.Serial(
    port='COM10',\
    baudrate=115200,\
    parity=serial.PARITY_NONE,\
    stopbits=serial.STOPBITS_ONE,\
    bytesize=serial.EIGHTBITS,\
        timeout=0)

print("\nconnected to: " + ser.portstr)
settings = "/1024,3072,10,12,49,/"
ser.write(settings.encode())
print("Send: " + settings+"\n")
seq = []
data = []
config = False
joined_seq=[]
row=""
try:
    f = open("Logs\Log_teste2.txt", "w")
    f = open("Logs\Log_teste2.txt", "a")
    while True:
        for c in ser.read():
            
            if(chr(c)==","):
                if (config==True):
                    # print(joined_seq)
                    # data.append(joined_seq)
                    row=row+ " " + joined_seq
                    seq=[]
            else:
                if (config==True):
                    # print(chr(c))
                    seq.append(chr(c)) 
                    joined_seq = ''.join(str(v) for v in seq) 
            if(chr(c)=="/"):
                if (config==True):
                    row=row + "\r\n"
                    
                    print(row[1:])
                    f.write(row[1:])
                    row=""
                    data = []
                    seq=[]
                config = not config

except KeyboardInterrupt:
    ser.close()
    f.close()
    
     
    




