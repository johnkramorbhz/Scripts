# Scripts/ROS Toolbox

## Usage

TODO

`ros_tools --compile` It compiles packages in `~/catkin_ws/` if there is no `$HOME/ros_tools.config.json` detected. Otherwise it will be whatever directory you want to go to.

`ros_tools --version` Prints version string

`ros_tools --upgrade` Upgrade this script

`ros_tools --lab1` Test lab1 default setting

`sudo ros_tools --makews` Make a workspace

`ros_tools -gc` Generate a JSON config in your HOME folder e.g. `{'format_level': 1, 'debug': False, 'catkin_path': '$HOME/catkin_ws'}`

## Installation

```bash
sudo wget --no-cache -O /usr/bin/rostools https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.py && sudo chmod 777 /usr/bin/rostools && sudo wget --no-cache -O /usr/bin/ros_bashtools https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.sh && sudo chmod 777 /usr/bin/ros_bashtools
```

## Why bashtools in addition to ros tools

ROS only support bash instead of sh that python uses, so it's required to use bashtools as an interface.

## Purpose

TODO

## Cleanup script

`wget -O setup.sh https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/setup_ros_vm.sh && sudo bash ./setup.sh`