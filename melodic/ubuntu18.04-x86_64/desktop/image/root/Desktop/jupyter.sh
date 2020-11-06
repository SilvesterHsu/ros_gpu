#!/bin/bash
su seel <<EOF
cd /notebooks

source /opt/ros/melodic/setup.bash
source /root/catkin_ws/devel/setup.bash

jupyter notebook --ip=0.0.0.0 --allow-root
EOF