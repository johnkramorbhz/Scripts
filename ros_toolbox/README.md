# Scripts/ROS Toolbox

## Usage

TODO

`ros_tools --compile` It compiles packages in `~/catkin_ws/` if there is no `$HOME/ros_tools.config.json` detected. Otherwise it will be whatever directory you want to go to.

`ros_tools --version` Prints version string

`ros_tools --upgrade` Upgrade this script

`ros_tools --lab1` Test lab1 default setting

## Installation

```bash
sudo wget -O /bin/ros_tools https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.py && sudo chmod 777 /bin/ros_tools && sudo wget -O /bin/ros_bashtools https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.sh && sudo chmod 777 /bin/ros_bashtools
```

## Purpose

Why making this? It requires so many unnecessary steps that I believe it can be automated. ROS does NOT actively look for a package after `catkin_make`.

I just don't like the default config that I have to put it in `~/catkin_ws/`