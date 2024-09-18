#!/bin/bash

# N.B.:
# 1) you can kill all the spawned terminals together by right clicking on
# the X icon on the left bar and selecting "Quit"

# echo "usage: ./${0##*/} "

source ../ros_ws/devel/setup.bash

USE_LIVE=1
USE_RVIZ=1   # if you set this to 1, you should also set Viewer.on: 0 in the yaml settings
USE_OCTOMAP=0

# possible dataset 
RGBD_DATASET_FOLDER="$HOME/Work/datasets/rgbd_datasets/d435"
DATASET='office/office.bag'

# ROS_BAG_PLAY_OPTIONS="--rate 0.5"  # comment this to remove rate adjustment

export CAMERA_SETTINGS="../Settings/d435.yaml"

export REMAP_COLOR_TOPIC="/camera/rgb/image_raw:=/camera/color/image_raw"
export REMAP_DEPTH_TOPIC="camera/depth_registered/image_raw:=/camera/aligned_depth_to_color/image_raw"
export REMAP_CAMERA_INFO="/camera/rgb/camera_info:=/camera/aligned_depth_to_color/camera_info"

# export DEBUG_PREFIX="--prefix 'gdb -ex run --args'"  # uncomment this in order to debug with gdb

# ======================================================================

xterm -hold -e "source ~/.bashrc; echo 3 | source /opt/ros/noetic/setup.bash; export ROS_HOSTNAME=192.168.123.162; export ROS_MASTER_URI=http://192.168.123.162:11311; roscore" &
sleep 3

if [ $USE_LIVE -eq 0 ]
then
    sleep 1
fi

# ======================================================================

xterm -hold -e "source ~/.bashrc; echo 3 | source /opt/ros/noetic/setup.bash; export ROS_HOSTNAME=192.168.123.162; export ROS_MASTER_URI=http://192.168.123.162:11311; rosrun $DEBUG_PREFIX plvs RGBD ../Vocabulary/ORBvoc.txt $CAMERA_SETTINGS $REMAP_CAMERA_INFO $REMAP_COLOR_TOPIC $REMAP_DEPTH_TOPIC" &

# ======================================================================

if [ $USE_LIVE -eq 1 ]
then
    xterm -hold -e "source ~/.bashrc; echo 3 | source /opt/ros/noetic/setup.bash; export ROS_HOSTNAME=192.168.123.162; export ROS_MASTER_URI=http://192.168.123.162:11311; roslaunch plvs d435.launch" &
    sleep 1
else
    sleep 1
fi

# ======================================================================

if [ $USE_RVIZ -eq 1 ]
then
    xterm -hold -e "source ~/.bashrc; echo 3 | source /opt/ros/noetic/setup.bash; export ROS_HOSTNAME=192.168.123.162; export ROS_MASTER_URI=http://192.168.123.162:11311; roslaunch plvs rviz_plvs.launch" &
fi

if [ $USE_OCTOMAP -eq 1 ]
then 
    xterm -hold -e "source ~/.bashrc; echo 3 | source /opt/ros/noetic/setup.bash; export ROS_HOSTNAME=192.168.123.162; export ROS_MASTER_URI=http://192.168.123.162:11311; roslaunch octomap_server octomap_server.launch" &
fi

# ======================================================================

echo "DONE"

# record "/camera/rgb/image_rect_color",/camera/depth_registered/sw_registered/image_rect"
