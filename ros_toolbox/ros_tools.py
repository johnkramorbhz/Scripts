#!/usr/bin/python3
import os,sys,json
from os.path import expanduser
branch="main"
major=1
SCRIPT_API_level=0
bug_fixes=0
suffix=""
if suffix != "":
    version=str(major)+"."+str(SCRIPT_API_level)+"."+str(bug_fixes)+"_"+suffix
else:
    version=str(major)+"."+str(SCRIPT_API_level)+"."+str(bug_fixes)
default_value_of_rostools = {"format_level": 1,
"debug": False,
"generated_from": version,
"catkin_path": "$HOME/catkin_ws"
}
home = expanduser("~")
data = default_value_of_rostools
#print(default_value_of_rostools)
def compile_and_update():
    os.system("ros_bashtools -c")
def install_this_script():
    if os.geteuid()!=0:
        print("ERROR: You must run this script as root or sudo in order to install")
        sys.exit(1)
    else:
        print("Exit code:",os.system("cp " + sys.argv[0] + " /bin/ros_tools && chmod 777 /bin/ros_tools"))
def run_lab1():
    print("Exit code:",os.system("ros_bashtools --launch-lab1-test"))
def upgrade_this_script():
    if os.geteuid()!=0:
        print("ERROR: You must run this script as root or sudo in order to upgrade")
        sys.exit(1)
    else:
        print("Exit code:",os.system("wget -q --no-cache -O /bin/ros_tools https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.py && chmod 777 /bin/ros_tools && echo \"Update ROS Tools successfully\" && wget -O /bin/ros_bashtools --no-cache -q https://raw.githubusercontent.com/johnkramorbhz/Scripts/main/ros_toolbox/ros_tools.sh && chmod 777 /bin/ros_bashtools && echo \"Update Complete!\" ; echo \"ROS Tools version:\" ; ros_tools -v; echo \"ROS Bash Tools version:\"; ros_bashtools -v"))       
def print_help():
    print("ROS Toolbox Help")
    print("Usage can be found on https://github.com/johnkramorbhz/Scripts/tree/main/ros_toolbox")
def generate_default_config():
    with open(home+'/ros_tools.config.json', 'w+') as json_file:
        json.dump(default_value_of_rostools, json_file,indent=4,sort_keys=True)
def load_user_value(suppress):
    # suppress = True, then NO print statements
    global data
    if not os.path.exists(home+'/ros_tools.config.json'):
        if not suppress:
            print("WARNING: You do not have \"ros_tools.config.json\" in your HOME directory")
            print("Using default values")
        return
    with open(home+'/ros_tools.config.json', 'r') as json_file:
        data=json.load(json_file)
    #print(data)
def get_catkin_path():
    return data['catkin_path']
if len(sys.argv)==1:
    print_help()
    sys.exit(1)
if sys.argv[1]=="--install":
    install_this_script()
elif sys.argv[1]=="--compile-in-legacy-way" or sys.argv[1]=="-cl":
    compile_and_update()
elif sys.argv[1]=="--compile" or sys.argv[1]=="-ccd" or sys.argv[1]=="-c":
    load_user_value(False)
    print("Exit code:",os.system("ros_bashtools -ccd "+get_catkin_path()))
elif sys.argv[1]=="--lab1-legacy" or sys.argv[1]=="-l1tl":
    run_lab1()
elif sys.argv[1]=="--lab1" or sys.argv[1]=="-l1":
    load_user_value(False)
    print("Exit code:",os.system("ros_bashtools --launch-lab1 "+get_catkin_path()))
elif sys.argv[1]=="--evader":
    load_user_value(False)
    print("Exit code:",os.system("ros_bashtools --launch-evader "+get_catkin_path()))
elif sys.argv[1]=="--pursuader-evader" or sys.argv[1]=="-pe":
    load_user_value(False)
    print("Exit code:",os.system("ros_bashtools --launch-pe "+get_catkin_path()))
elif sys.argv[1]=="--upgrade" or sys.argv[1]=="-u":
    upgrade_this_script()
elif sys.argv[1]=="--version" or sys.argv[1]=="-v":
    print(version)
elif sys.argv[1]=="--generate-config" or sys.argv[1]=="-gc":
    generate_default_config()
elif sys.argv[1]=="--get-catkin-path-clean":
    load_user_value(True)
    print(get_catkin_path()+"")
elif sys.argv[1]=="--clean":
    os.system("ros_bashtools --clean-log")
elif sys.argv[1]=="--make-workspace" or sys.argv[1]=="--makews":
    if os.geteuid()!=0:
        print("ERROR: You need root or sudo privilege to make workspace")
        sys.exit(1)
    else:
        os.system("ros_bashtools --make-workspace")
else:
    print_help()
    sys.exit(1)

