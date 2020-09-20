# Scripts/ROS Toolbox

## Usage

`ros_tools --compile` It compiles packages in `~/catkin_ws/`

`ros_tools --version` Prints version string

`ros_tools --upgrade` Upgrade this script

## Installation

```bash
sudo wget -O /bin/ros_tools https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.py && sudo chmod 777 /bin/ros_tools && sudo wget -O /bin/ros_bashtools https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.sh && sudo chmod 777 /bin/ros_bashtools
```

## Purpose

Why making this? It requires so many unnecessary steps that I believe it can be automated. ROS does NOT actively look for a package after `catkin_make`.

I just don't like the default config that I have to put it in `~/catkin_ws/`