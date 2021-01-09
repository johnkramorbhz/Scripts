#!/usr/bin/python3
import os,sys,json
from os.path import expanduser
branch="main"
major=3
SCRIPT_API_level=1
bug_fixes=1
suffix="development"
if suffix != "":
    version=str(major)+"."+str(SCRIPT_API_level)+"."+str(bug_fixes)+"_"+suffix
else:
    version=str(major)+"."+str(SCRIPT_API_level)+"."+str(bug_fixes)
default_value_of_rostools = {"format_level": 2,
"debug": False,
"generated_from": version,
"no_HW_acceleration": False,
"catkin_path": "$HOME/catkin_ws"
}
home = expanduser("~")
data = default_value_of_rostools
timestamp="2020-10-22 22:00"
#print(default_value_of_rostools)
def print_start():
    print("ROS Tools")
    print("This is a free software that have absolutely NO WARRANTY.\nYou are free to redistribute this software as long as you don\'t disable this startup message.")
    print("Licence: MIT")
    print("Last edited on:",timestamp)
def compile_and_update():
    os.system("ros_bashtools -c")
def install_this_script():
    if os.geteuid()!=0:
        print("ERROR: You must run this script as root or sudo in order to install")
        sys.exit(1)
    else:
        print("Exit code:",os.system("cp " + sys.argv[0] + " /usr/bin/myrostools && chmod 777 /usr/bin/myrostools"))
def run_lab1():
    print("Exit code:",os.system("ros_bashtools --launch-lab1-test"))
def upgrade_this_script():
    if os.geteuid()!=0:
        print("ERROR: You must run this script as root or sudo in order to upgrade")
        sys.exit(1)
    else:
        print("Exit code:",os.system("wget -q --no-cache -O /bin/ros_tools https://raw.githubusercontent.com/johnkramorbhz/ROS_Toolbox/main/ros_tools.py && chmod 777 /bin/ros_tools && echo \"Update ROS Tools successfully\" && wget -O /bin/ros_bashtools --no-cache -q https://raw.githubusercontent.com/johnkramorbhz/ROS_Toolbox/main/ros_tools.sh && chmod 777 /bin/ros_bashtools && echo \"Update Complete!\" ; echo \"ROS Tools version:\" ; ros_tools -v; echo \"ROS Bash Tools version:\"; ros_bashtools -v"))       
def print_help():
    print("ROS Toolbox Help")
    print("Usage can be found on https://github.com/johnkramorbhz/ROS_Toolbox")
def generate_default_config():
    with open(home+'/ros_tools.config.json', 'w+') as json_file:
        json.dump(default_value_of_rostools, json_file,indent=4,sort_keys=True)
def load_user_value(path=home+'/ros_tools.config.json',suppress=False):
    # suppress = True, then NO print statements
    global data
    if not os.path.exists(path):
        if not suppress:
            print("WARNING: You do not have \"ros_tools.config.json\" in your HOME directory")
            print("Using default values")
        return
    with open(path, 'r') as json_file:
        data=json.load(json_file)
    #print(data)
def get_catkin_path():
    return data['catkin_path']
def check_lab2_sf_packages():
    import apt
if len(sys.argv)==1:
    print_start()
    print_help()
    sys.exit(1)
if sys.argv[1]=="--install":
    print_start()
    install_this_script()
elif sys.argv[1]=="--compile-in-legacy-way" or sys.argv[1]=="-cl":
    print_start()
    compile_and_update()
elif sys.argv[1]=="--compile" or sys.argv[1]=="-ccd" or sys.argv[1]=="-c":
    print_start()
    load_user_value()
    print("Exit code:",os.system("ros_bashtools -ccd "+get_catkin_path()))
elif sys.argv[1]=="--lab1-legacy" or sys.argv[1]=="-l1tl":
    print_start()
    run_lab1()
elif sys.argv[1]=="--lab1" or sys.argv[1]=="-l1":
    print_start()
    load_user_value()
    print("Exit code:",os.system("ros_bashtools --launch-lab1 "+get_catkin_path()))
elif sys.argv[1]=="--evader":
    print_start()
    load_user_value()
    print("Exit code:",os.system("ros_bashtools --launch-evader "+get_catkin_path()))
elif sys.argv[1]=="--pursuader-evader" or sys.argv[1]=="-pe":
    print_start()
    load_user_value()
    print("Exit code:",os.system("ros_bashtools --launch-pe "+get_catkin_path()))
elif sys.argv[1]=="--upgrade" or sys.argv[1]=="-u":
    print_start()
    upgrade_this_script()
elif sys.argv[1]=="--version" or sys.argv[1]=="-v":
    print(version)
elif sys.argv[1]=="--generate-config" or sys.argv[1]=="-gc":
    print_start()
    generate_default_config()
elif sys.argv[1]=="--get-catkin-path-clean":
    print_start()
    load_user_value()
    print(get_catkin_path()+"")
elif sys.argv[1]=="--clean":
    print_start()
    os.system("ros_bashtools --clean-log")
elif sys.argv[1]=="--make-workspace" or sys.argv[1]=="--makews":
    print_start()
    if os.geteuid()!=0:
        print("ERROR: You need root or sudo privilege to make workspace")
        sys.exit(1)
    else:
        os.system("ros_bashtools --make-workspace")
elif sys.argv[1]=="--lab2-part1":
    print_start()
    load_user_value()
    no_HW_acc=False
    try:
        no_HW_acc=data['no_HW_acceleration']
    except:
        no_HW_acc=False
    print("Exit code:",os.system("ros_bashtools --launch-perception "+get_catkin_path()+" "+str(no_HW_acc)))
elif sys.argv[1]=="--launch-lab4":
    print_start()
    load_user_value()
    print("Exit code:",os.system("ros_bashtools --launch-lab4 "+get_catkin_path()))
else:
    print_help()
    sys.exit(1)

