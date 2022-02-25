#!/usr/bin/env python3

import time
import rospy
from pynput import keyboard
from LiDAR_Collision_Avoidance.msg import Settings
import os



class LiDAR_Control:

    def __init__(self) :

        rospy.init_node('LiDAR_Control' , anonymous=False)

        self.Setting_topic= rospy.Publisher('LiDAR_Collision_Avoidance' +  '/Settings/',  Settings, queue_size=100)
        self.Settings_msg= Settings()
        self.Settings_msg.slave_id=48

        self.rate = rospy.Rate(1)
        self.tick_step=300
        self.initial_tick=1500
        self.final_tick=2048
        self.frequency=50
        self.print_banner()

    def main(self):
    
        while not rospy.is_shutdown():
            with keyboard.Events() as events:
                event = events.get(1e6)
                self.Command(event.key)
                self.print_banner()
                self.Settings_msg.initial_tick = self.initial_tick
                self.Settings_msg.final_tick = self.final_tick
                self.Settings_msg.tick_step = self.tick_step
                self.Settings_msg.frequency = self.frequency
                self.Setting_topic.publish(self.Settings_msg)
 

    def Command(self,key):

        if key == keyboard.KeyCode.from_char('q'):
            if(self.tick_step >= 1 ):
                self.tick_step = self.tick_step-40
                
        if key == keyboard.KeyCode.from_char('e'):
            if(self.tick_step <= 800 ):
                self.tick_step = self.tick_step+40   
        
        if key == keyboard.KeyCode.from_char('d'):
            self.initial_tick = self.initial_tick-128
            self.final_tick = self.final_tick-128
            if(self.initial_tick < 0 ):
                self.final_tick = self.final_tick-self.initial_tick
                self.initial_tick = 0
                
        if key == keyboard.KeyCode.from_char('a'):
            self.initial_tick = self.initial_tick+128
            self.final_tick = self.final_tick+128
            if(self.final_tick > 4096 ):
                self.initial_tick = self.initial_tick-( self.final_tick-4096 )
                self.final_tick = 4096 
            
        if key == keyboard.KeyCode.from_char('w'):
            self.initial_tick= self.initial_tick-16
            self.final_tick = self.final_tick+16
            
            if(self.final_tick > 4096 ):
                self.initial_tick = self.initial_tick-( self.final_tick-4096 )
                self.final_tick = 4096
                
            if(self.initial_tick < 0 ):
                self.final_tick = self.final_tick - self.initial_tick
                self.initial_tick=0
 
                
        if key == keyboard.KeyCode.from_char('s'):
            self.initial_tick = self.initial_tick+16
            self.final_tick = self.final_tick-16
            
            if(self.initial_tick > self.final_tick):
                self.initial_tick = self.final_tick
            
            if(self.final_tick > 4096 ):
                self.initial_tick = self.initial_tick - ( self.final_tick - 4096)
                self.final_tick = 4096
                
            if(self.initial_tick < 0 ):
                self.final_tick = self.final_tick - self.initial_tick
                self.initial_tick=0
                
                 
        if key == keyboard.KeyCode.from_char('+'):
           if(self.frequency <= 100 ):
               self.frequency = self.frequency+10    
              
               
        if key == keyboard.KeyCode.from_char('-'):
          if(self.frequency >= 1 ):
              self.frequency = self.frequency-10   
            
               
        time.sleep(2)

    def print_banner(self):

        clear = lambda: os.system('clear')
        clear()
        print("|============================================================================|")
        print("|============================MAPEAMENTO-DE-TECLAS============================|")
        print("|============================================================================|")
        print("|----------------------------------------------------------------------------|")
        print("| 's' ---> Diminuir o ângulo do scan                                         |")
        print("| 'w' ---> Aumentar o ângulo do scan                                         |")
        print("|----------------------------------------------------------------------------|")
        print("| 'a' ---> Rodar a posição angular de scan no sentido anti-horário           |")
        print("| 'd' ---> Rodar a posição angular de scan no sentido horário                |")
        print("|----------------------------------------------------------------------------|")
        print("| 'q' ---> Diminuir o tick de incremento                                     |")
        print("| 'e' ---> Aumentar o tick de incremento                                     |")
        print("|----------------------------------------------------------------------------|")
        print("| '-' ---> Diminuir a frequência de funcionamento                            |")
        print("| '+' ---> Diminuir a frequência de funcionamento                            |")
        print("|----------------------------------------------------------------------------|")
        print("|============================================================================|")
        print("|====================CONFIGURAÇÕES-DE-FUNCIONAMENTO-ATIVAS===================|")
        print("|============================================================================|")
        print("|----------------------------------------------------------------------------|")
        print("| Tick inical ---> ",self.initial_tick,"                                   ")
        print("|----------------------------------------------------------------------------|")
        print("| Tick Final ---> ",self.final_tick,"                                     ")
        print("|----------------------------------------------------------------------------|")
        print("| Tick de incremento ---> ",self.tick_step,"                                ")
        print("|----------------------------------------------------------------------------|")
        print("| Frequência de funcionamento ---> ",self.frequency,"                       ")
        print("|----------------------------------------------------------------------------|")
        print("|============================================================================|")
    


def start():
    LiDAR_control = LiDAR_Control()
    LiDAR_control.main()


if __name__ == '__main__':
    try:
        start()
        rospy.spin()
    except rospy.ROSInterruptException:

        pass
         
    
