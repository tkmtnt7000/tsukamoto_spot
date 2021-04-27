#!/usr/bin/env python

import rospy
from sensor_msgs.msg import Joy
from geometry_msgs.msg import Twist

class JoystickToCmdvel:

    def __init__(self):
        rospy.init_node('connect_joy', anonymous=True)
        self.sub = rospy.Subscriber("joy", Joy, self.callback)
        self.pub = rospy.Publisher('cmd_vel', Twist, queue_size=10)
        self.joy = Twist()
        self.mode_flag = True # True -> linear movement, False -> angular movement
        self.message = Joy()
        # initialize
        self.x = 0.0
        self.y = 0.0
        self.yaw = 0.0
        
    def callback(self, msg):
        rospy.loginfo("subscribe joy")
        self.cmd_vel_pub(msg)

    # change the value of cmd_vel
    def cmd_vel_pub(self, msg):
        # joy takes -1.0 to 1.0 value
        # cmd_vel -0.5 to 0.5
        self.x = msg.axes[1] / 2
        self.y = msg.axes[0] / 2
        self.yaw = msg.axes[0] / 2
        
        if msg.buttons[7] == 1:
            self.mode_flag = not self.mode_flag
        '''
        if self.mode_flag == True:
            self.joy.linear.x = self.x #msg.axes[1]
            self.joy.linear.y = self.y #msg.axes[0]
        else:
            self.joy.angular.z = self.yaw #msg.axes[0]
            
        #rospy.loginfo("publish cmd_vel!")
        self.pub.publish(self.joy)
        '''
    # publish cmd_vel always
    def send_msg(self):
        if self.mode_flag == True:
            self.joy.linear.x = self.x
            self.joy.linear.y = self.y
        else:
            self.joy.angular.z = self.yaw
        self.pub.publish(self.joy)
        
def main():
    joy_cmdvel = JoystickToCmdvel()
    #rospy.spin()

    # always publish cmd_vel
    rate = rospy.Rate(40)
    while not rospy.is_shutdown():
        #rospy.loginfo("done")
        joy_cmdvel.send_msg()
        rate.sleep()
        
if __name__=='__main__':
    main()
