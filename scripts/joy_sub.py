#!/usr/bin/env python

import rospy
from sensor_msgs.msg import Joy
from geometry_msgs.msg import Twist

def callback(msg):
    rospy.loginfo("publish cmd_vel!")
    cmd_vel_pub(msg)

def joy_sub():
    rospy.init_node('connect_joy', anonymous=True)
    rospy.Subscriber("joy", Joy, callback)
    rospy.spin()

def cmd_vel_pub(msg):
    pub = rospy.Publisher('cmd_vel', Twist, queue_size=10)
    joy = Twist()
    joy.linear.x = msg.axes[1]
    joy.linear.y = msg.axes[0]
    pub.publish(joy)

if __name__ =='__main__':
    joy_sub()
