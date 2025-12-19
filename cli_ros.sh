#!/bin/bash /bin/zsh
##########################################################
# ros2
##########################################################

alias r2b="colcon build && source install/local_setup.sh"
alias r2r="ros2 run"
alias r2l="ros2 launch"

##########################################################
# pkg
##########################################################

alias r2p="ros2 pkg"
alias r2pls="ros2 pkg list"
alias r2pcrc="ros2 pkg create --build-type ament_cmake"
alias r2pcrpy="ros2 pkg create --build-type ament_python"

##########################################################
# topic
##########################################################

alias r2t="ros2 topic"
alias r2tbw="ros2 topic bw"
alias r2tls="ros2 topic list"
alias r2tif="ros2 topic info"
alias r2te="ros2 topic echo"
alias r2tp="ros2 topic pub"

##########################################################
# service
##########################################################

alias r2s="ros2 service"
alias r2sls="ros2 service list"
alias r2sty="ros2 service type"
alias r2sca="ros2 service call"

##########################################################
# interface
##########################################################

alias r2i="ros2 interface"
alias r2ils="ros2 interface list"
alias r2ish="ros2 interface show"
alias r2ip="ros2 interface package"

##########################################################
# action
##########################################################

alias r2a="ros2 action"
alias r2als="ros2 action list"
alias r2aif="ros2 action info"
alias r2asg="ros2 action send_goal"

##########################################################
# param
##########################################################

alias r2pm="ros2 param"
alias r2pmif="ros2 param describe"
alias r2pms="ros2 param set"
alias r2pmg="ros2 param get"
alias r2pmd="ros2 param dump"
alias r2pml="ros2 param load"
