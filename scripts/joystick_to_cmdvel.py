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
        self.mode_flag = True
        
    def callback(msg):
        rospy.loginfo("publish cmd_vel")
        cmd_vel_pub(msg)

    def cmd_vel_pub(msg):
        if msg.buttons[0] == 1:
            self.mode_flag = not self.mode_flag
        
        if self.mode_flag == True:
            self.joy.linear.x = msg.axes[1]
            self.joy.linear.y = msg.axes[0]
        else:
            self.joy.angular.z = msg.axes[0]
        self.pub.publish(joy)

if __name__=='__main__':
    joy_cmdvel = JoystickToCmdvel()
    rospy.spin()
