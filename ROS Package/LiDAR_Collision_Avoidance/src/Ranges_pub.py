#!/usr/bin/env python3

import time
import random
import rospy
import serial
import numpy as np
from sensor_msgs.msg import Range
from LiDAR_Collision_Avoidance.msg import Settings
import tf


class LiDAR_Collision_Avoidance:

    def __init__(self) :

        #/dev/ttyACM0
        self.ser = serial.Serial(
            port='/dev/ttyUSB0',\
            baudrate=115200,\
            parity=serial.PARITY_NONE,\
            stopbits=serial.STOPBITS_ONE,\
            bytesize=serial.EIGHTBITS,\
                timeout=0)

        rospy.init_node('LiDAR_Collision_Avoidance', anonymous=False)
        rospy.Subscriber('LiDAR_Collision_Avoidance' + '/Settings/' , Settings, self.Send_comand)

        self.rate = rospy.Rate(10)
        self.range_topic= rospy.Publisher('LiDAR_Collision_Avoidance' +  '/Ranges/',  Range, queue_size=100) 


        self.data = []
        self.Range_msg= Range()
        self.Range_msg.header.frame_id="LiDAR"
        self.Range_msg.min_range=10
        self.Range_msg.max_range=1200
        self.Range_msg.field_of_view=3.6*(2*np.pi/360)
        self.Range_msg.radiation_type=1

        self.br=tf.TransformBroadcaster()

    def Send_comand(self,msg):
        settings_msg ="/%d,%d,%d,%d,%d,0,/"%(msg.slave_id,msg.initial_tick,msg.final_tick,msg.frequency,msg.tick_step)
        self.ser.write(settings_msg.encode())
        print("Send: " + settings_msg+"\n")


    def ReadRange(self):
        seq = []
        data = []
        config = False
        joined_seq=[]
        while True:
            for c in self.ser.read():
                #print(chr(c))
                if(chr(c)==","):
                    
                    if(config==True):

                        data.append(int(joined_seq))         
                        seq=[]
                else:
                    if (config==True):
                        seq.append(chr(c)) 
                        joined_seq = ''.join(str(v) for v in seq) 
                if(chr(c)=="/"):
                    if (config==True):
                        return data

                    config = not config 



    def main(self):
        
        while not rospy.is_shutdown():
            self.data=self.ReadRange()
            #print(self.data)
            self.publishRanges()
            
        self.ser.close()

            

    def publishRanges(self):
        
        rad_ang=self.data[2]*(2*np.pi/4096)
        
        quater_array=tf.transformations.quaternion_from_euler(0,0,rad_ang)
        self.br.sendTransform((0.2,0,0.08),quater_array,rospy.Time.now(),"LiDAR","base_link")

        self.Range_msg.range=self.data[1]
        self.Range_msg.header.stamp=rospy.Time.now()

        self.range_topic.publish(self.Range_msg)


            
def start():
    LiDAR = LiDAR_Collision_Avoidance()
    LiDAR.main()


if __name__ == '__main__':
    try:
        start()
        rospy.spin()
    except rospy.ROSInterruptException:

        pass
         
    

    

