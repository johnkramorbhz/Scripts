import sys,os,math,subprocess,copy,time,random,datetime,signal,hashlib,glob,getpass,platform,socket
#Don't modify this section!
sfRequired=['python3','gcc','g++','make']
grade=0.0
passgrade=0.0
partialgrade=0.0
possible_grade=0.0
passed=0
partialPass=0
failed=0
subtractSeconds=0
maximumgrade=0.0
totaltestsrunned=0
count=0
totalRunCount=0
maximumPossibleGrade=0
tests=[]
temp=[]
runneditem=[]
passeditems=[]
faileditems=[]
timedoutitems=[]
partialitems=[]
resultsfortherun=[]
lowerPythonVersion=False
result=[]
global ubitname
version="2.2.9_final_opensource"
# For binary auto-update only, beta features only bump revision number
revision=2
def checkDirs():
    if not os.path.exists("../framework/report"):
        os.makedirs("../framework/report")
        os.makedirs("../framework/report/PA1")
        os.makedirs("../framework/report/PA2")
        os.makedirs("../framework/report/PA2_experiments")
        os.makedirs("../framework/report/PA2_fail")
    if not os.path.exists("../framework/report/PA1"):
        os.makedirs("../framework/report/PA2")
    if not os.path.exists("../framework/report/PA2"):
        os.makedirs("../framework/report/PA2")
    if not os.path.exists("../framework/report/PA2_experiments"):
        os.makedirs("../framework/report/PA2_experiments")
    if not os.path.exists("../framework/report/PA2_fail"):
        os.makedirs("../framework/report/PA2_fail")
if len(sys.argv)>1 and sys.argv[1]=="version":
    print(version)
    #print("revision: "+str(revision))
    sys.exit()
if len(sys.argv)>1 and sys.argv[1]=="revision":
    #print(version)
    print(revision)
    sys.exit()
if len(sys.argv)>1 and sys.argv[1]=="install":
    wget_useragent='"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.92 Safari/537.36"'
    wget_friendly="wget -q -U "+wget_useragent+" "
    # Filenames
    pa1CSV_URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA1.csv;"
    pa2bas_URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_basic.csv;"
    pa2adv_URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_advanced.csv;"
    pa2san_URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_sanity.csv;"
    exp1_10URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_experiment1_10_ds.csv;"
    exp1_50URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_experiment1_50_ds.csv;"
    exp2_02URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_experiment2_0.2_ds.csv;"
    exp2_05URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_experiment2_0.5_ds.csv;"
    exp2_08URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_experiment2_0.8_ds.csv;"
    script_URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate.py;"
    binary_URL=wget_friendly+"https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate_bin;"
    a1_init_sc="https://ubwins.cse.buffalo.edu/cse-489_589/assignment1_init_script.sh; chmod +x assignment1_init_script.sh;"
    a2_init_sc="https://ubwins.cse.buffalo.edu/cse-489_589/pa2/assignment2_init_script.sh; chmod +x assignment2_init_script.sh;"
    pa1_test_s="-O test.sh https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA1_test.sh;"
    pa2_test_s="-O test.sh https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/PA2_test.sh;"
    if not sys.platform.startswith('linux'):
        print("ERROR: Make sure you are running it in Linux")
        sys.exit(1)
    if os.system("wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate.py")!=0:
        print("ERROR: You do NOT have wget installed!")
        sys.exit(1)
    if os.path.exists("framework"):
        print("WARNING: You should NOT run this script unless you want to REPLACE EVERYTHING!!!")
        print("Closing this program for your safety")
        sys.exit(1)
    print("INFO: Populating directories...")
    os.makedirs("cse489589_assignment1")
    os.makedirs("cse489589_assignment2")
    os.makedirs("framework")
    print("INFO: Running PA1 installing script...")
    os.system("cd cse489589_assignment1;"+wget_friendly+pa1_test_s+wget_friendly+a1_init_sc+"./assignment1_init_script.sh")
    print("INFO: Running PA2 installing script...")
    os.system("cd cse489589_assignment2;"+wget_friendly+pa2_test_s+wget_friendly+a2_init_sc+"./assignment2_init_script.sh")
    print("INFO: Populating framework directory")
    os.system("cd framework;"+pa1CSV_URL+pa2bas_URL+pa2adv_URL+pa2san_URL+exp1_10URL+exp1_50URL+exp2_02URL+exp2_05URL+exp2_08URL+script_URL+binary_URL)
    print("INFO: Making sure scripts can be executed")
    os.system("cd framework; chmod u+x testTemplate_bin; mkdir -p report/PA1; mkdir -p report/PA2; mkdir -p report/PA2_experiments; mkdir -p report/PA2_fail")
    os.system("cd cse489589_assignment1; chmod u+x test.sh")
    os.system("cd cse489589_assignment2; chmod u+x test.sh")
    print("INFO: Cleaning up...")
    os.system("rm -rf testTemplate.py testTemplate_bin testTemplate ../framework")
    sys.exit()
if len(sys.argv)>1 and sys.argv[1]=="update":
    if not sys.platform.startswith('linux'):
        print("ERROR: Make sure you are running it in Linux")
        sys.exit(1)
    if os.system("wget -q --spider https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate.py")!=0:
        print("ERROR: You do NOT have wget installed or You do NOT have Internet access!")
        sys.exit(1)
    os.system("rm -rf testTemplate.py testTemplate_bin;wget -O testTemplate.py https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate.py; wget -O testTemplate_bin https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate_bin; chmod u+x testTemplate_bin")
    sys.exit()        
try:
    ubitname=os.environ["ubitname"]
    debug=bool(os.environ["debug"])
    global_timeout=int(os.environ["timeout"])
    quiet=bool(os.environ["quiet"])
    shell_version=os.environ["version_number"]
    personNumber=os.environ["personNumber"]
except:
    print("ERROR: You need to launch this program from shell scripts provided with it!")
    sys.exit(1)
stdoutsOfProgram=[]
experimentsData=[]
unusedVar=[]
fail=False
try:
    suppressHeader=bool(os.environ["suppressHeader"])
except:
    # PA1 does not require this option, so set it to False.
    suppressHeader=False
try:
    gradMode=bool(os.environ["gradMode"])
except:
    # PA1 have same score regardless undergrad and grad, so set it to False.
    # Also ensures compatibility with older version of scripts
    gradMode=False
# End of static section

# item name is the friendly version of command
# command must be the same as the PA description said!
# testsTupleFormat=("item_name","command","total_grade_of_this_test","earned_grade","stdout","execution_time","test_status")
# experimentTupleFormat=("messages","loss","corruption","time","window","binary_name")
hostnamesForGrading=["stones.cse.buffalo.edu","euston.cse.buffalo.edu","embankment.cse.buffalo.edu","underground.cse.buffalo.edu","highgate.cse.buffalo.edu"]
def clearAll():
    global grade,passgrade,partialgrade,possible_grade,passed,partialPass,failed,maximumgrade,totaltestsrunned,maximumPossibleGrade
    tests.clear()
    temp.clear()
    runneditem.clear()
    passeditems.clear()
    faileditems.clear()
    timedoutitems.clear()
    partialitems.clear()
    resultsfortherun.clear()
    grade=0.0
    passgrade=0.0
    partialgrade=0.0
    possible_grade=0.0
    passed=0
    partialPass=0
    failed=0
    maximumPossibleGrade=0.0
    maximumgrade=0.0
    #subtractSeconds=0
    maximumgrade=0.0
    totaltestsrunned=0
# Python program to print 
# coloured text and background 
class colours:
    reset='\033[0m'
    bold='\033[01m'
    disable='\033[02m'
    underline='\033[04m'
    reverse='\033[07m'
    strikethrough='\033[09m'
    invisible='\033[08m'
    class fg: 
        black='\033[30m'
        red='\033[31m'
        green='\033[32m'
        orange='\033[33m'
        blue='\033[34m'
        purple='\033[35m'
        cyan='\033[36m'
        lightgrey='\033[37m'
        darkgrey='\033[90m'
        lightred='\033[91m'
        lightgreen='\033[92m'
        yellow='\033[93m'
        lightblue='\033[94m'
        pink='\033[95m'
        lightcyan='\033[96m'
    class bg: 
        black='\033[40m'
        red='\033[41m'
        green='\033[42m'
        orange='\033[43m'
        blue='\033[44m'
        purple='\033[45m'
        cyan='\033[46m'
        lightgrey='\033[47m'
def printGrade():
    print("Current grade: "+"{:0.4f}".format(grade)+", passes: "+str(passed)+", partially passes: "+str(partialPass)+", fails: "+str(failed))
def validUBITname(ubitname):
    if len(ubitname)>8 or len(ubitname)<3:
        return False
    return True
def print_info(target_string):
    print(colours.fg.blue+"INFO:    "+target_string,colours.reset)
def ifRunningInLinux():
    if not sys.platform.startswith('linux'):
        print(colours.fg.red+"ERROR: Your system is not Linux based OS, which you should NEVER run this test on!",colours.reset)
        print_info("Your OS: "+sys.platform)
        print_info("Refer to the course website for more details!")
        sys.exit(1)

def pass_test(case,score,stdout,exe_time):
    quote='"'
    print(colours.fg.green+"Passed "+quote+case+quote+" and you earned "+str(score)+" points",colours.reset)
    global passed
    passed+=1
    global grade
    global passgrade
    for items in tests:
        if items[1]==case:
            passgrade+=items[2]
            grade+=items[2]
            tempmodule=list(items)
            tempmodule[-1]="pass"
            tempmodule[5]=exe_time
            tempmodule[4]=stdout
            tempmodule[3]=float(score)
            tests.remove(items)
            tests.append(tuple(tempmodule))
            printGrade()
            break              
def pass_partial_test(case,score,stdout,exe_time):
    quote='"'
    print(colours.fg.yellow+"You earned some partial credits in "+quote+case+quote+", which is",score,"out of",getScore(case),colours.reset)
    global partialPass
    global partialgrade
    partialPass+=1
    global grade
    for items in tests:
        if items[1]==case:
            partialgrade+=score
            grade+=score
            tempmodule=list(items)
            tempmodule[-1]="partial"
            tempmodule[5]=exe_time
            tempmodule[4]=stdout
            tempmodule[3]=score
            tests.remove(items)
            tests.append(tuple(tempmodule))
            printGrade()
            break              

def fail_test(case,stdout,exe_time):
    print(colours.fg.red+"Failed",case,colours.reset)
    global failed
    failed+=1
    for items in tests:
        if items[1]==case:
            tempmodule=list(items)
            tempmodule[-1]="fail"
            tempmodule[4]=stdout
            tempmodule[5]=exe_time
            tests.remove(items)
            tests.append(tuple(tempmodule))
            printGrade()
            break    
def item_exist(item):
    for items in tests:
        if items[1]==item:
            return True
    return False
def getScore(case):
    for items in tests:
        if items[1]==case:
            return float(items[2])

def check_result(testcase_input,outputfromshell,PAX,stdout,exe_time):
    if testcase_input=="author" and PAX=="PA1":
        if outputfromshell=="TRUE":
            pass_test(testcase_input,0.0,stdout,exe_time)
        elif outputfromshell=="FALSE":
            fail_test(testcase_input,stdout,exe_time)
        else:
            print("ERROR: Grader failed to return a parseable result for",testcase_input)
            timedoutitems.append(testcase_input)
    elif item_exist(testcase_input) and PAX=="PA1":
        try:
            float(outputfromshell)
            if float(outputfromshell)<getScore(testcase_input) and float(outputfromshell)>0.0:
                pass_partial_test(testcase_input,float(outputfromshell),stdout,exe_time)
            elif float(outputfromshell)==getScore(testcase_input):
                pass_test(testcase_input,float(outputfromshell),stdout,exe_time)
            else:
                fail_test(testcase_input,stdout,exe_time)
        except ValueError:
            print("ERROR: Grader failed to return a parseable result for",testcase_input)
            timedoutitems.append(testcase_input)
    elif item_exist(testcase_input) and PAX=="PA2" or PAX=="PA2_all":
        if len(outputfromshell.split("  "))>1:
            if outputfromshell.split("  ")[1]=="\x1b[91mFAIL\x1b[0m":
                fail_test(testcase_input,stdout,exe_time)
            elif outputfromshell.split("  ")[1]=="\x1b[92mPASS\x1b[0m":
                pass_test(testcase_input,getScore(testcase_input),stdout,exe_time)
            else:
                print(colours.fg.red+"ERROR: Failed to parse test result!",colours.reset)
        else:
            if outputfromshell.split("  ")=="\x1b[92mPASS!\x1b[0m":
                pass_test(testcase_input,getScore(testcase_input),stdout,exe_time)
            else:
                fail_test(testcase_input,stdout,exe_time)
    else:
        print("ERROR: Item does not exist!")
        print("Make sure CSV is loaded before running any tests!")
        print("Inputs: testcase_input'"+testcase_input+"' Output:",outputfromshell,"PAX:",PAX)
        sys.exit(1)
item_failed=""
def signalHandlerPA1(signum, frame):
    print(colours.fg.red+"ERROR: Timed out! Killing this process!",colours.reset)
    report("PA1")
    timedoutitems.append(item_failed)
    # It should move to the next item
    # sys.exit(1)
def callShellCommandsPA1(command,filename,timeouts,PAX):
    for char in command:
        if char == ";":
            print("ERROR: Command input(command) is contaminated where it might cause security hazard.")
            print("Exiting this program for your safety")
            sys.exit(1)
    for char in filename:
        if char == ";":
            print("ERROR: Command input(filename) is contaminated where it might cause security hazard.")
            print("Exiting this program for your safety")
            sys.exit(1)
    if lowerPythonVersion==False:
        signal.signal(signal.SIGALRM, signalHandlerPA1)
        print_info("Calling '"+command+"' into the system shell with "+str(timeouts)+" seconds limit")
        signal.alarm(timeouts)
    else:
        print_info("If this process is running for more than 5 minutes, use [Control] + [C] to kill it")
    item_failed=command
    unusedVar.append(item_failed)
    print("Process started on",str(datetime.date.today())+" "+str(datetime.datetime.now().time()))
    try:
        start_time=time.time()
        results=(subprocess.check_output("../cse489589_assignment1/grader/grader_controller -c ../cse489589_assignment1/grader/grader.cfg -s "+filename+" -t "+command,shell=True)).decode('ascii')
        end_time=time.time()
        if not quiet:
            print(results)
        resultoutput=results.split('\n')
        check_result(command,resultoutput[-2],PAX,results,end_time-start_time)
    except subprocess.CalledProcessError as e:
        print("Dumping info")
        print(e.stdout)
def signalHandlerPA2(signum, frame):
    print(colours.fg.red+"ERROR: Timed out! Killing this process!",colours.reset)
    report("PA2_fail")
    timedoutitems.append(item_failed)
    # It should move to the next item
    # sys.exit(1)
def callShellCommandsPA2(command,filename,timeouts,PAX,testTypes):
    for char in testTypes:
        if char == ";":
            print("ERROR: Command input(testTypes) is contaminated where it might cause security hazard.")
            print("Exiting this program for your safety")
            sys.exit(1)
    for char in filename:
        if char == ";":
            print("ERROR: Command input(filename) is contaminated where it might cause security hazard.")
            print("Exiting this program for your safety")
            sys.exit(1)
    if lowerPythonVersion==False:
        signal.signal(signal.SIGALRM, signalHandlerPA2)
        signal.alarm(timeouts)
        print_info("Calling '"+command+"' into the system shell with "+str(timeouts)+" seconds limit")
    else:
        print_info("If this process is running for more than 5 minutes, use [Control] + [C] to kill it")
        print("Currently running",command,"Timeout:",timeouts)
    item_failed=command
    unusedVar.append(item_failed)
    print("Process started on",str(datetime.date.today())+" "+str(datetime.datetime.now().time()))
    try:
        start_time=time.time()
        results=(subprocess.check_output("../cse489589_assignment2/grader/"+testTypes+"_tests -p "+filename+" -r ../cse489589_assignment2/grader/run_experiments",shell=True)).decode('ascii')
        end_time=time.time()
        if not quiet:
            print(results)
        stdoutsOfProgram.append((command,results))
        resultoutput=results.split('\n')
        if resultoutput[-2]=="\x1b[4mNOTE:\x1b[0m ALL sub-tests should show PASS status for SANITY TESTS to pass." or resultoutput[-2]=="\x1b[4mNOTE:\x1b[0m ALL sub-tests should show PASS status for ADVANCED TESTS to pass." or resultoutput[-2]=="\x1b[4mNOTE:\x1b[0m ALL sub-tests should show PASS status for BASIC TESTS to pass.":
            check_result(command,resultoutput[-3],PAX,results,end_time-start_time)
        else:
            check_result(command,resultoutput[-2],PAX,results,end_time-start_time)
    except subprocess.CalledProcessError as e:
        print(colours.fg.red+"ERROR: Test crashed! Dumping stdout...",colours.reset)
        print(e.stdout.decode('ascii'))
def build_tarPA1(ubitname):
    ifRunningInLinux()
    if os.path.exists("../cse489589_assignment1/"+ubitname+"_pa1.tar"):
        #print_info("File: "+ubitname+"_pa1.tar"+" exists! Deleting...")
        os.remove("../cse489589_assignment1/"+ubitname+"_pa1.tar")
    if not os.path.exists("../cse489589_assignment1/"+ubitname+"/include/logger.h"):
        print("ERROR: logger.h does not exist!")
        sys.exit(1)
    if not os.path.exists("../cse489589_assignment1/"+ubitname+"/src/logger.cpp") and not os.path.exists("../cse489589_assignment1/"+ubitname+"/src/logger.c"):
        print("ERROR: logger.c or logger.cpp does NOT exist")
        sys.exit(1)
    if not os.path.exists("../cse489589_assignment1/"+ubitname+"/src/"+ubitname+"_assignment1.cpp") and not os.path.exists("../cse489589_assignment1/"+ubitname+"/src/"+ubitname+"_assignment1.c"):
        print("ERROR: "+ubitname+"_assignment1.c or "+ubitname+"_assignment1.cpp does not exist!")
        sys.exit(1)
    if os.system("cd ../cse489589_assignment1/"+ubitname+";make >> /dev/null") !=0:
        print(colours.fg.yellow+"WARNING: Your ./assignment1 seems to be unable to compile. Submitting this copy will earn you 0 points!",colours.reset)
        if debug==False:
            print("Since debug mode is disabled, this program will terminate!")
            sys.exit(1)
    if os.system("cd ../cse489589_assignment1/"+ubitname+";make clean >> /dev/null") !=0:
        print("ERROR: make failed to clean!")
        sys.exit(1)
    print_info("Building...")
    if os.system("cd ../cse489589_assignment1/"+ubitname+"/ && tar --exclude='./scripts' -zcf ../"+ubitname+"_pa1.tar *") !=0:
        print("ERROR: Failed to pack up!")
        sys.exit(1)
    else:
        print("INFO: Packing "+ubitname+"_pa1.tar successfully")
def buildPA2(ubitname):
    ifRunningInLinux()
    print("INFO: Compiling... ",end='')
    if not os.path.exists("../cse489589_assignment2/"+ubitname+"/object"):
        os.makedirs("../cse489589_assignment2/"+ubitname+"/object")
    if os.system("cd ../cse489589_assignment2/"+ubitname+"; make clean >> /dev/null; make >> /dev/null")!=0:
        print("fail")
        print("ERROR: Failed to compile!")
        sys.exit(1)
    print("done")
def buildPA1(ubitname):
    ifRunningInLinux()
    print("INFO: Compiling... ",end='')
    if not os.path.exists("../cse489589_assignment1/"+ubitname+"/object"):
        os.makedirs("../cse489589_assignment1/"+ubitname+"/object")
    if os.system("cd ../cse489589_assignment1/"+ubitname+"; make clean >> /dev/null; make >> /dev/null")!=0:
        print("fail")
        print("ERROR: make failed to run!")
        sys.exit(1)
    print("done")
def build_tarPA2(ubitname):
    ifRunningInLinux()
    global fail
    if not validUBITname(ubitname):
        print("ERROR: Your UBITname is invalid!")
        fail=True
    if not os.path.exists("../cse489589_assignment2/"+ubitname):
        print("ERROR: cse489589_assignment2/"+ubitname,"does NOT exist!")
        fail=True
    if not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/gbn.cpp") and not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/gbn.c"):
        print("ERROR: Missing gbn.c or gbn.cpp or file named incorrectly!")
        fail=True
    if not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/abt.cpp") and not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/abt.c"):
        print("ERROR: Missing abt.c or abt.cpp or file named incorrectly!")
        fail=True
    if not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/sr.cpp") and not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/sr.c"):
        print("ERROR: Missing sr.c or sr.cpp or file named incorrectly!")
        fail=True
    if not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/simulator.cpp") and not os.path.exists("../cse489589_assignment2/"+ubitname+"/src/simulator.c"):
        print("ERROR: Missing simulator.c or simulator.cpp or file named incorrectly!")
        fail=True
    if not os.path.exists("../cse489589_assignment2/"+ubitname+"/include/simulator.h"):
        print("ERROR: Missing simulator.h or file named incorrectly!")
        fail=True
    if not os.path.exists("../cse489589_assignment2/"+ubitname+"/Makefile"):
        print("ERROR: Makefile does not exist!")
        fail=True
    if os.system("cd ../cse489589_assignment2/"+ubitname+";make >> /dev/null") !=0:
        print(colours.fg.yellow+"WARNING: Your assignment2 binaries seems to be unable to compile.",colours.reset)
        if debug==False:
            print("Since debug mode is disabled, this program will terminate!")
            fail=True
    if os.path.exists("../cse489589_assignment2/"+ubitname+"_pa2.tar"):
        os.remove("../cse489589_assignment2/"+ubitname+"_pa2.tar")
    if os.system("cd ../cse489589_assignment2/"+ubitname+";make clean >> /dev/null")!=0:
        print("ERROR: make failed to clean!")
        fail=True
    if fail:
        sys.exit(1)
    if os.path.exists("../cse489589_assignment2/"+ubitname+"/Analysis_Assignment2.pdf"):
        if os.system("cd ../cse489589_assignment2/"+ubitname+"/ && tar --exclude='./scripts' -zcf ../"+ubitname+"_pa2.tar *")!=0:
            print("ERROR: Failed to pack up!")
            fail=True
        else:
            print("INFO: Packing "+ubitname+"_pa2.tar successfully")
    else:
        print("ERROR: "+"cse489589_assignment2/"+ubitname+"/Analysis_Assignment2.pdf"+" does NOT exist! Make sure you have this pdf file before continue")
        fail=True
    if fail:
        sys.exit(1)
def readCSV(filename):
    #print_info("Reading: "+filename)
    if len(tests)>0:
        clearAll()
    if not os.path.exists(filename):
        print("ERROR: File",filename,"does not exist!")
        sys.exit(1)
    with open(filename,'r') as openfile:
        for lines in openfile:
            temp.append(str(lines).strip('\n'))
    openfile.close()
    for items in temp:
        # gradMode=False is the old behaviour, which loads undergrad grades
        # gradMode=True  is the new behaviour, which loads grad grades 
        if not gradMode:
            tests.append((items.split(",")[0],items.split(",")[1],float(items.split(",")[2]),0.0,"",0.0,"---"))
        else:
            try:
                tests.append((items.split(",")[0],items.split(",")[1],float(items.split(",")[3]),0.0,"",0.0,"---"))
            except:
                if debug:
                    print("DEBUG: Using undergrad grade for",items.split(",")[0])
                tests.append((items.split(",")[0],items.split(",")[1],float(items.split(",")[2]),0.0,"",0.0,"---"))
    #print("INFO: Reading",filename,"complete")
    for item in temp:
        for char in item[1]:
            if char == ";":
                print("ERROR:",filename,"has been contaminated where it might trick this program to run extra commands!")
                print("Exiting this program for your safety")
                sys.exit(1)
    #print("INFO: Input sanity check complete")

def getFileChecksum(filename):
    if not os.path.exists(filename):
        print("ERROR: File",filename,"does not exist!")
        sys.exit(1)
    with open(filename,'rb') as openfile:
        bytesFile = openfile.read()
        readable_hashSHA256 = hashlib.sha256(bytesFile).hexdigest()
        readable_hashMD5= hashlib.md5(bytesFile).hexdigest()
        return (readable_hashSHA256,readable_hashMD5)
def generateReportInText(fileToExport,PAX):
    checkDirs()
    print_info("Writing: "+fileToExport)
    with open(fileToExport,'w+') as openfile:
        if PAX=="PA1":
            openfile.write(ubitname+"_pa1.tar"+" SHA256:"+getFileChecksum("../cse489589_assignment1/"+ubitname+"_pa1.tar")[0]+"\n")
        elif PAX=="PA2":
            openfile.write("ABT binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/abt")[0]+"\n")
            openfile.write("GBN binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/gbn")[0]+"\n")
            openfile.write("SR  binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/sr")[0]+"\n")
        openfile.write("\nHere is the summary of this report generated on "+str(datetime.date.today())+" "+str(datetime.datetime.now().time())+"\n")
        openfile.write("Overall grade: "+str(round(grade,4))+" out of "+str(maximumgrade)+" possible, passes: "+str(passed)+", partially passes "+str(partialPass)+", fails: "+str(failed)+", skipped: "+str(len(timedoutitems))+"\n")
        openfile.write("Percentage: "+str((grade/maximumgrade)*100)+"%"+" Max: "+str((maximumPossibleGrade/maximumgrade)*100)+"%\n")
        openfile.write("Total tests executed "+str(totaltestsrunned)+", out of maximum of "+str(len(tests))+". Coverage: "+str((totaltestsrunned/len(tests))*100)+"%"+"\n")
        if len(faileditems)>0:
            openfile.write("Failed items: "+str(len(faileditems))+"\n")
            for items in faileditems:
                openfile.write(str(items[1])+"\n")
            openfile.write("*********************************\n**End of failed items\n\n")
        if len(partialitems)>0:
            openfile.write("Partially passed items: "+str(len(partialitems))+", scored: "+str(partialgrade)+"\n")
            for items in partialitems:
                openfile.write(""+str(items[1])+" scored: "+str(items[3])+" out of "+str(items[2])+"\n")
            openfile.write("*********************************\n**End of partially passed items\n\n")
        if len(passeditems)>0:
            openfile.write("Passed items: "+str(len(passeditems))+", scored: "+str(passgrade)+"\n")
            for items in passeditems:
                openfile.write(str(items[1])+"\n")
    openfile.close()

def generateReportInTextPA2ALL(fileToExport):
    checkDirs()
    print_info("Writing: "+fileToExport)
    global maximumgrade, maximumPossibleGrade, totaltestsrunned,grade,passgrade
    if "PA2_all"=="PA2_all":
        global maximumgrade, maximumPossibleGrade, totaltestsrunned,grade,passgrade
        with open(fileToExport,'w+') as openfile:
            openfile.write("ABT binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/abt")[0]+"\n")
            openfile.write("GBN binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/gbn")[0]+"\n")
            openfile.write("SR  binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/sr")[0]+"\n")
            openfile.write("\nHere is the summary of this report generated on "+str(datetime.date.today())+" "+str(datetime.datetime.now().time())+"\n")
            for x in range(len(result)):
                testName=""
                if x==0:
                    openfile.write("This section is basic tests\n*********************************\n")
                    testName="basic"
                    readCSV("../framework/PA2_basic.csv")
                elif x==1:
                    openfile.write("This section is advanced tests\n*********************************\n")
                    testName="advanced"
                    readCSV("../framework/PA2_advanced.csv")
                elif x==2:
                    openfile.write("This section is sanity tests\n*********************************\n")
                    testName="sanity"
                    readCSV("../framework/PA2_sanity.csv")
                for items in result[x]:
                    if items[1]!="bonus":
                        maximumgrade+=items[2]
                    maximumPossibleGrade+=items[2]
                    if items[-1]=="pass":
                        passeditems.append(items)
                        grade+=getScore(items[1])
                        passgrade+=getScore(items[1])
                    elif items[-1]=="partial":
                        partialitems.append(items)
                        grade+=getScore(items[1])
                        partialgrade+=getScore(items[1])
                    elif items[-1]=="fail":
                        faileditems.append(items)
                totaltestsrunned=len(passeditems)+len(faileditems)+len(partialitems)
                
                if len(faileditems)>0:
                    openfile.write("Failed items: "+str(len(faileditems))+"\n")
                    for items in faileditems:
                        openfile.write(str(items[1])+"\n")
                        with open("../framework/report/PA2/"+str(items[1])+"_"+testName+"_error_message_"+str(datetime.date.today())+"_"+str(time.strftime("%H.%M.%S"))+".txt",'w+') as openerror:
                            openerror.write(items[4])
                    openfile.write("**End of failed items\n\n")
                if len(partialitems)>0:
                    openfile.write("Partially passed items: "+str(len(partialitems))+", scored: "+str(partialgrade)+"\n")
                    for items in partialitems:
                        openfile.write(""+str(items[1])+" scored: "+str(items[3])+" out of "+str(items[2])+"\n")
                    openfile.write("**End of partially passed items\n\n")
                if len(passeditems)>0:
                    openfile.write("Passed items: "+str(len(passeditems))+", scored: "+str(passgrade)+"\n")
                    for items in passeditems:
                        openfile.write(str(items[1])+"\n")
                if x==0:
                    openfile.write("*********************************\n**End of basic tests\n")
                elif x==1:
                    openfile.write("*********************************\n**End of advanced tests\n")
                elif x==2:
                    openfile.write("*********************************\n**End of sanity tests\n")
                    #openfile.write("RAW: "+str(result)+"\n")
def report(PAX):
    global maximumgrade, maximumPossibleGrade, totaltestsrunned,grade,passgrade,partialgrade
    if PAX=="PA2_all":
        global maximumgrade, maximumPossibleGrade, totaltestsrunned,grade,passgrade
        print(colours.fg.yellow+"*********************************",colours.reset)
        print("ABT binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/abt")[0])
        print("GBN binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/gbn")[0])
        print("SR  binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+ubitname+"/sr")[0]+"\n")
        print("Here is the summary of this report generated on",datetime.date.today(),datetime.datetime.now().time())
        for x in range(len(result)):
            if x==0:
                print(colours.bg.purple+"This section is basic tests",colours.reset)
                print(colours.fg.cyan+"*********************************",colours.reset)
                readCSV("../framework/PA2_basic.csv")
            elif x==1:
                print(colours.bg.purple+"This section is advanced tests",colours.reset)
                print(colours.fg.cyan+"*********************************",colours.reset)
                readCSV("../framework/PA2_advanced.csv")
            elif x==2:
                print(colours.bg.purple+"This section is sanity tests",colours.reset)
                print(colours.fg.cyan+"*********************************",colours.reset)
                readCSV("../framework/PA2_sanity.csv")
            for items in result[x]:
                if items[1]!="bonus":
                    maximumgrade+=items[2]
                maximumPossibleGrade+=items[2]
                if items[-1]=="pass":
                    passeditems.append(items)
                    grade+=getScore(items[1])
                    passgrade+=getScore(items[1])
                elif items[-1]=="partial":
                    partialitems.append(items)
                    grade+=getScore(items[1])
                    partialgrade+=getScore(items[1])
                elif items[-1]=="fail":
                    faileditems.append(items)
            totaltestsrunned=len(passeditems)+len(faileditems)+len(partialitems)
            print("Overall grade: "+str(round(grade,4))+" out of "+str(maximumgrade)+" possible, passes: "+str(len(passeditems))+", partially passes "+str(len(partialitems))+", fails: "+str(len(faileditems))+", skipped: "+str(len(timedoutitems)))
            print("Percentage: "+str((grade/maximumgrade)*100)+"%"+" Max: "+str((maximumPossibleGrade/maximumgrade)*100)+"%")
            print("Total tests executed "+str(totaltestsrunned)+", out of maximum of "+str(len(result[x]))+". Coverage: "+str((totaltestsrunned/len(result[x]))*100)+"%")
            print("")
            if len(passeditems)!=0:
                print(colours.fg.green+"Passed tests:",str(len(passeditems))+", total score:",passgrade,colours.reset)
                for items in passeditems:
                    print(colours.fg.green+str(items[1]),colours.reset,"Execution time(in seconds):",items[5])
                print("")
    
            if len(partialitems)!=0:
                print(colours.fg.yellow+"Partially passed tests:",str(len(partialitems))+", total score:",partialgrade,colours.reset)
                for items in partialitems:
                    print(colours.fg.yellow+str(items[3]),"out of",str(items[2]),colours.reset,str(items[1]),"Execution time(in seconds):",items[5])
                print("")

            if len(faileditems)!=0:
                print(colours.fg.red+"Failed tests:",len(faileditems),colours.reset)
                for items in faileditems:
                    print(colours.fg.red+str(items[1])+colours.reset+", scores:",str(items[2]),"Execution time(in seconds):",items[5])
                    #print("stdout of this item")
                    #print(items[4])
            if len(timedoutitems)!=0:
                print(colours.fg.lightblue+"Skipped tests:",len(timedoutitems),colours.reset)
                for items in timedoutitems:
                    print(colours.fg.red+str(items[1])+colours.reset+", scores:",str(getScore(items)))
            clearAll()
            if x!=len(result):
                print("")
        #print(result)

        generateReportInTextPA2ALL("../framework/report/PA2/"+PAX+"_"+str(datetime.date.today())+"_"+str(time.strftime("%H.%M.%S"))+".txt")
    else:
        print(colours.fg.cyan+"*********************************",colours.reset)
        print("Here is the summary of this report generated on",datetime.date.today(),datetime.datetime.now().time())
        for items in tests:
            if items[1]!="bonus":
                maximumgrade+=items[2]
            maximumPossibleGrade+=items[2]
            if items[-1]=="pass":
                passeditems.append(items)
            elif items[-1]=="partial":
                partialitems.append(items)
            elif items[-1]=="fail":
                faileditems.append(items)
        totaltestsrunned=len(passeditems)+len(faileditems)+len(partialitems)
        print("Overall grade: "+str(round(grade,4))+" out of "+str(maximumgrade)+" possible, passes: "+str(passed)+", partially passes "+str(partialPass)+", fails: "+str(failed)+", skipped: "+str(len(timedoutitems)))
        print("Percentage: "+str((grade/maximumgrade)*100)+"%"+" Max: "+str((maximumPossibleGrade/maximumgrade)*100)+"%")
        print("Total tests executed "+str(totaltestsrunned)+", out of maximum of "+str(len(tests))+". Coverage: "+str((totaltestsrunned/len(tests))*100)+"%")
        print("")
        if len(passeditems)!=0:
            print(colours.fg.green+"Passed tests:",str(len(passeditems))+", total score:",passgrade,colours.reset)
            for items in passeditems:
                print(colours.fg.green+str(items[1]),colours.reset,"Execution time(in seconds):",items[5])
            print("")
    
        if len(partialitems)!=0:
            print(colours.fg.yellow+"Partially passed tests:",str(len(partialitems))+", total score:",partialgrade,colours.reset)
            for items in partialitems:
                print(colours.fg.yellow+str(items[3]),"out of",str(items[2]),colours.reset,str(items[1]),"Execution time(in seconds):",items[5])
            print("")

        if len(faileditems)!=0:
            print(colours.fg.red+"Failed tests:",len(faileditems),colours.reset)
            for items in faileditems:
                print(colours.fg.red+str(items[1])+colours.reset+", scores:",str(items[2]),"Execution time(in seconds):",items[5])
        if len(timedoutitems)!=0:
            print(colours.fg.lightblue+"Skipped tests:",len(timedoutitems),colours.reset)
            for items in timedoutitems:
                print(colours.fg.red+str(items[1])+colours.reset+", scores:",str(getScore(items)))
        generateReportInText("../framework/report/"+PAX+"/"+PAX+"_"+str(datetime.date.today())+"_"+str(time.strftime("%H.%M.%S"))+".txt",PAX)

def run_individual_testPA1(filename_csv,ubitname,testcase,mode,PAX):
    ifRunningInLinux()
    readCSV(filename_csv)
    if not os.path.exists("../cse489589_assignment1/"+ubitname+"_pa1.tar"):
        build_tarPA1(ubitname)
    callShellCommandsPA1(testcase,"../cse489589_assignment1/"+ubitname+"_pa1.tar",global_timeout,PAX)
    if len(timedoutitems)>0:
        for items in timedoutitems:
            callShellCommandsPA1(items,"../cse489589_assignment1/"+ubitname+"_pa1.tar",global_timeout,PAX)
    report(PAX)
def run_individual_testPA2(filename_csv,ubitname,testcase,testType,PAX):
    ifRunningInLinux()
    if len(tests)==0:
        readCSV(filename_csv)
    buildPA2(ubitname)
    callShellCommandsPA2(testcase,"../cse489589_assignment2/"+ubitname+"/"+testcase.lower(),global_timeout,PAX,testType)
    report(PAX)

def run_all_testsPA1(filename_csv,ubitname,PAX):
    ifRunningInLinux()
    global subtractSeconds
    print_info("Running all tests defined in the csv file.")
    readCSV(filename_csv)
    temp_lists=copy.deepcopy(tests)
    build_tarPA1(ubitname)
    counter=0
    for indv_item in temp_lists:
        counter+=1
        print_info("Running test for "+str(indv_item[0])+".")
        if count>0:
            print("Progress: "+str(counter)+" out of "+str(len(tests))+". Running "+str(count)+", out of total of "+str(totalRunCount))
        else:
            print("Progress: "+str(counter)+" out of "+str(len(tests)))
        sleep_sec=random.randint(2,10)
        subtractSeconds+=sleep_sec
        print("Waiting",sleep_sec,"(s)")
        time.sleep(sleep_sec)
        process_start = time.perf_counter()
        callShellCommandsPA1(indv_item[1],"../cse489589_assignment1/"+ubitname+"_pa1.tar",global_timeout,PAX)
        process_end = time.perf_counter()
        print("This item ran",process_end-process_start,"(s)")
    runningTimedOutItems=copy.deepcopy(timedoutitems)
    if len(timedoutitems)>0:
        for items in runningTimedOutItems:
            timedoutitems.remove(items)
            callShellCommandsPA1(items,"../cse489589_assignment1/"+ubitname+"_pa1.tar",global_timeout,PAX)    
    report(PAX)
def run_file_testPA2(ubitnames,testcase,PAX):
    #print("ubitname:",ubitname,"case:",testcase,"PAX:",PAX)
    ifRunningInLinux()
    buildPA2(ubitname)
    filenames=[("../framework/PA2_basic.csv","basic"),("../framework/PA2_advanced.csv","advanced"),("../framework/PA2_sanity.csv","sanity")]
    #filenames=[("../framework/PA2_basic.csv","basic")]
    for currentTest in filenames:
        readCSV(currentTest[0])
        temp_lists=copy.deepcopy(tests)
        for indv_item in temp_lists:
            if indv_item[1]==testcase:
                callShellCommandsPA2(indv_item[1],"../cse489589_assignment2/"+ubitname+"/"+indv_item[1].lower(),global_timeout,PAX,currentTest[1])
        result.append(copy.deepcopy(tests))
        clearAll()
    report("PA2_all")

def test_all_PA2(ubitname,testType,PAX):
    ifRunningInLinux()
    buildPA2(ubitname)
    filenames=[("../framework/PA2_basic.csv","basic"),("../framework/PA2_advanced.csv","advanced"),("../framework/PA2_sanity.csv","sanity")]
    #filenames=[("../framework/PA2_basic.csv","basic")]
    for currentTest in filenames:
        readCSV(currentTest[0])
        temp_lists=copy.deepcopy(tests)
        for indv_item in temp_lists:
            callShellCommandsPA2(indv_item[1],"../cse489589_assignment2/"+ubitname+"/"+indv_item[1].lower(),global_timeout,PAX,currentTest[1])
        result.append(copy.deepcopy(tests))
        clearAll()
    report("PA2_all")

def isHostReachable():
    ifRunningInLinux()
    exitCodeSum=0
    for hosts in hostnamesForGrading:
        exitCodeSum+=os.system("ping -c 1 " + hosts+" >> /dev/null")
    if exitCodeSum>0:
        print(colours.fg.red+"ERROR: It seems that at least one of the host is not reachable",colours.reset)
        sys.exit(1)
def ifFileExecutesPA1(ubitname):
    ifRunningInLinux()
    os.system("cd ../cse489589_assignment1/"+ubitname+";make;./assignment1 c AUTHOR")
def getSumOfRunTime():
    length=0.0
    for items in tests:
        length+=items[5]
    return length

def repeatTest(filename_csv,ubitname,testcase,times,PAX):
    global subtractSeconds
    try:
        int(times)
    except:
        print("Integer only!")
        sys.exit(1)
    if int(times)>0:
        for x in range(0,int(times)):
            t1_instance_start=time.perf_counter()
            print("Running",x+1,"time(s)","out of",times,"times.")
            sleep_sec=random.randint(2,10)
            subtractSeconds+=sleep_sec
            print("Waiting",sleep_sec,"(s)")
            time.sleep(sleep_sec)
            build_tarPA1(ubitname)
            run_individual_testPA1(filename_csv,ubitname,testcase,"repeat",PAX)
            print("It takes",time.perf_counter()-t1_instance_start,"(s) in order to finish this script, where running programs takes",str(getSumOfRunTime())+"(s)")
            clearAll()
    else:
        print("'times' must be more than 0 in order to run!")
def readGeneratedCSV(fileToExport):
    print_info("Reading: "+fileToExport)
def prompt():
    if int(sys.version_info[0])>=3 and int(sys.version_info[1])>=4:
        if not gradMode:
            print("CSE489 Auto Test Program")
        else:
            print("CSE589 Auto Test Program")
        print("Program Version:",version)
        print("Shell Code Version:",shell_version)
        print("Copyright sxht4 under MIT Licence")
        print("Welcome,",os.environ["fullname"]+"!")
        if debug:
            print("Running in debug mode\n")
            print("Python version: "+str(sys.version_info[0])+"."+str(sys.version_info[1])+"."+str(sys.version_info[2])+"_"+str(sys.version_info[3]))
            print("Platform:",platform.platform())
            print("Architecture:",platform.machine())
            print("User:",getpass.getuser())
            print("Hostname:",platform.node())
            print("IP:",socket.gethostbyname(socket.gethostname()))
            print("UBITname:",os.environ["ubitname"])
            if sys.platform.startswith('linux'):
                if not int(sys.version_info[0])>3 or not int(sys.version_info[0])==3 and not int(sys.version_info[1])>=8:
                    os.system("lsb_release -a")
                    #print("OS:",platform.linux_distribution()[0],platform.linux_distribution()[1])
            print()
    else:
        if int(sys.version_info[0])==2:
            sys.exit(1)
        global lowerPythonVersion
        lowerPythonVersion=True
        if not gradMode:
            print("CSE489 Auto Test Program in COMPATIBILITY MODE")
        else:
            print("CSE589 Auto Test Program in COMPATIBILITY MODE")
        print("Program Version:",version)
        print("Shell Code Version:",shell_version)
        print("Copyright sxht4 under MIT Licence")
        print("Welcome,",os.environ["fullname"]+"!")
        if debug:
            print("Running in debug mode\n")
            print("Python version: "+str(sys.version_info[0])+"."+str(sys.version_info[1])+"."+str(sys.version_info[2])+"_"+str(sys.version_info[3]))
            print("Platform:",platform.platform())
            print("Architecture:",platform.machine())
            print("User:",getpass.getuser())
            print("Hostname:",platform.node())
            print("IP:",socket.gethostbyname(socket.gethostname()))
            print("UBITname:",os.environ["ubitname"])
            if sys.platform.startswith('linux'):
                if not int(sys.version_info[0])>3 or not int(sys.version_info[0])==3 and not int(sys.version_info[1])>=8:
                    os.system("lsb_release -a")
                    #print("OS:",platform.linux_distribution()[0],platform.linux_distribution()[1])
            print()
def getCheckSum(filename):
    if not os.path.exists(filename):
        print(colours.fg.red+"ERROR: file'"+filename+"' does not exist!",colours.reset)
        print("Exiting...")
        sys.exit(1)
    print(colours.fg.lightblue+"Reading: '"+filename+"'",colours.reset)
    with open(filename,'rb') as openfile:
        bytesFile = openfile.read()
        readable_hashSHA256 = hashlib.sha256(bytesFile).hexdigest()
        readable_hashMD5= hashlib.md5(bytesFile).hexdigest()
        print("MD5:",readable_hashMD5)
        print("SHA256:",readable_hashSHA256)
        with open("checksum.txt",'w+') as openfileCheckSum:
            openfileCheckSum.write(readable_hashMD5+"\n"+readable_hashSHA256)
        openfile.close()
        openfileCheckSum.close()
def verify(filenameOfSourceFile,filenameOfChecksumFile):
    if not os.path.exists(filenameOfChecksumFile):
        print(colours.fg.red+"ERROR: file'"+filenameOfChecksumFile+"' does not exist!",colours.reset)
        print("Exiting...")
        sys.exit(1)
    if not os.path.exists(filenameOfSourceFile):
        print(colours.fg.red+"ERROR: file'"+filenameOfSourceFile+"' does not exist!",colours.reset)
        print("Exiting...")
        sys.exit(1)
    with open(filenameOfSourceFile,'rb') as openfile:
        bytesFile = openfile.read()
        readable_hashSHA256 = hashlib.sha256(bytesFile).hexdigest()
        readable_hashMD5= hashlib.md5(bytesFile).hexdigest()
        checksums=[]
        checksums.append(readable_hashMD5)
        checksums.append(readable_hashSHA256)
        with open(filenameOfSourceFile,'rb') as openCheckSum:
            temp.clear()
            for lines in openCheckSum:
                temp.append(str(lines).strip('\n'))
        if temp[0]==checksums[0] and temp[1]==checksums[1]:
            print(colours.fg.green+"Verification successful",colours.reset)
            openfile.close()
            openCheckSum.close()
            sys.exit()
        else:
            print(colours.fg.red+"Verification Failed!",colours.reset)
            print("Submission file MD5:",readable_hashMD5)
            print("Correct MD5:",checksums[0])
            print("Submission file SHA256:",readable_hashSHA256)
            print("Correct SHA256:",checksums[1])
            openfile.close()
            openCheckSum.close()
            sys.exit(1)
def run_experiments(messages,loss,corruption,time,window,binary,outputfile,supressHeader,ubitname):
    checkDirs()
    if supressHeader==True:
        if os.system("../cse489589_assignment2/grader/run_experiments -m "+str(messages)+" -l "+str(loss)+" -c "+str(corruption)+" -t "+str(time)+" -w "+str(window)+" -p ../cse489589_assignment2/"+str(ubitname)+"/"+str(binary)+" -o ../framework/report/PA2_experiments/"+str(outputfile)+" -n") !=0:
            print(colours.fg.red+"ERROR: ./run_experiments returned a non-zero exit code!",colours.reset)
            print("For your safety, this program will terminate!")
            sys.exit(1)
    else:
        if os.system("../cse489589_assignment2/grader/run_experiments -m "+str(messages)+" -l "+str(loss)+" -c "+str(corruption)+" -t "+str(time)+" -w "+str(window)+" -p ../cse489589_assignment2/"+str(ubitname)+"/"+str(binary)+" -o ../framework/report/PA2_experiments/"+str(outputfile)) !=0:
            print(colours.fg.red+"ERROR: ./run_experiments returned a non-zero exit code!",colours.reset)
            print("For your safety, this program will terminate!")
            sys.exit(1)
def check_software_installed_ubuntu():
    import apt
    sfNotInstalled=[]
    cache = apt.cache.Cache()
    for sf in sfRequired:
        try:
            if not cache[sf].is_installed:
                sfNotInstalled.append(sf)
        except:
            sfNotInstalled.append(sf)
    if len(sfNotInstalled)!=0:
        print("Packages required but not installed",sfNotInstalled)
        print("Install missing software by using command below:\nsudo apt install ",end='')
        for sf in sfNotInstalled:
            print(sf+" ",end='')
        print()
        sys.exit(1)
def check_software_installed_redhat_centos():
    sys.exit()
def checkAIStatement():
    print("TODO")
#Launcher portion
if len(sys.argv)<2:
    prompt()
    print("Usage can be found in https://github.com/johnkramorbhz/Scripts/blob/master/unit_tests/CSE489/usage.md")
    sys.exit(1)
if sys.argv[1]=="test-indv-PA1":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(sys.argv)!=5:
        print("ERROR: Arguments incorrect for test-indv!")
        print("Usage: ./test.sh --test-indv test_case")
        sys.exit(1)
    t1_start = time.perf_counter()
    readCSV(sys.argv[2])
    #ubitname=sys.argv[3]
    if item_exist(sys.argv[4]):
        isHostReachable()
        run_individual_testPA1(sys.argv[2],sys.argv[3],sys.argv[4],"fresh","PA1")
        t1_end = time.perf_counter()
        print("It takes",str(t1_end-t1_start-float(subtractSeconds))+"(s) to finish this script, where program total runtime is",str(getSumOfRunTime())+"(s)")
    else:
        print(colours.fg.red+"ERROR: Cannot find",sys.argv[4],"in the",sys.argv[2],colours.reset)
elif sys.argv[1]=="test-all-PA1":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    # Changes needs to be made here since PAX need to select appropriate test functions
    if len(sys.argv)!=5:
        print("ERROR: Arguments incorrect for test-all!")
        print("Usage: ./test.sh --test-all")
        sys.exit(1)
    t1_start = time.perf_counter() 
    isHostReachable()
    #ubitname=sys.argv[3]
    # sys.argv[2]= csvlocation [3]=ubitname [4]=PAX
    run_all_testsPA1(sys.argv[2],sys.argv[3],sys.argv[4])
    t1_end = time.perf_counter()
    print("It takes",str(t1_end-t1_start-float(subtractSeconds))+"(s) to finish this script, where program total runtime is",str(getSumOfRunTime())+"(s)")
elif sys.argv[1]=="repeat-PA1":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(sys.argv)!=7:
        print("ERROR: Arguments incorrect for repeat!")
        print("Arguments are ./test.sh --repeat test_case times")
        sys.exit(1)
    t1_start = time.perf_counter()
    readCSV(sys.argv[2])
    #ubitname=sys.argv[3]
    repeatTest(sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5],sys.argv[6])
    t1_end = time.perf_counter()
    print("It takes",str(t1_end-t1_start-float(subtractSeconds))+"(s) to finish this script, where program total runtime is",str(getSumOfRunTime())+"(s)")
elif sys.argv[1]=="repeat-test-all-PA1":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    # Changes needs to be made here since PAX need to select appropriate test functions
    if len(sys.argv)!=6:
        print("ERROR: Arguments incorrect for test-all!")
        print("Usage: ./test.sh --repeat-all times")
        sys.exit(1)
    #ubitname=sys.argv[3]
    try:
        totalRunCount=int(sys.argv[5])
    except:
        print("ERROR: times arg must be an integer!")
        print("e.g. ./test.sh --repeat-all 1")

    t1_start = time.perf_counter() 
    isHostReachable()
    if int(sys.argv[5])<=0:
        print("Enter an integer that is more than 0")
        sys.exit(1)
    # sys.argv[2]= csvlocation [3]=ubitname [4]=PAX [5]=times
    
    for x in range(0,int(sys.argv[5])):
        count+=1
        print("Overall progress:",count,"out of",int(sys.argv[5]))
        run_all_testsPA1(sys.argv[2],sys.argv[3],sys.argv[4])
        clearAll()
    t1_end = time.perf_counter()
    print("It takes",str(t1_end-t1_start-float(subtractSeconds))+"(s) to finish this script, where program total runtime is",str(getSumOfRunTime())+"(s)")
elif sys.argv[1]=="build-PA1":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(sys.argv)!=3 or len(sys.argv[2])==0 or len(sys.argv[2])>8:
        print(colours.fg.red+"ERROR: Arguments incorrect for build-PA1!",colours.reset)
        print("Make sure UBITname is configured properly!")
        sys.exit(1)
    build_tarPA1(sys.argv[2])
elif sys.argv[1]=="build-PA2":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(sys.argv)!=3 or len(sys.argv[2])==0 or len(sys.argv[2])>8:
        print(colours.fg.red+"ERROR: Arguments incorrect for build-PA2!",colours.reset)
        print("Make sure UBITname is configured properly!")
        sys.exit(1)
    build_tarPA2(sys.argv[2])
elif sys.argv[1]=="compile-PA2":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(sys.argv)!=3 or len(sys.argv[2])==0 or len(sys.argv[2])>8:
        print(colours.fg.red+"ERROR: Arguments incorrect for build-PA2!",colours.reset)
        print("Make sure UBITname is configured properly!")
        sys.exit(1)
    buildPA2(sys.argv[2])
    #ubitname=sys.argv[2]
elif sys.argv[1]=="test-all-PA2":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    # Changes needs to be made here since PAX need to select appropriate test functions
    t1_start = time.perf_counter() 
    isHostReachable()
    # sys.argv[2]=ubitname [3]=PAX
    #ubitname=sys.argv[2]
    test_all_PA2(sys.argv[2],sys.argv[3],"PA2_all")
    t1_end = time.perf_counter()
    print("It takes",str(t1_end-t1_start-float(subtractSeconds))+"(s) to finish this script")
elif sys.argv[1]=="test-file-PA2":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    t1_start = time.perf_counter()
    isHostReachable()
    #run_individual_testPA2(filename_csv,ubitname,testcase,testType,PAX)
    run_file_testPA2(sys.argv[2],sys.argv[3],"PA2")
    t1_end = time.perf_counter()
    print("It takes",str(t1_end-t1_start-float(subtractSeconds))+"(s) to finish this script")
elif sys.argv[1]=="test-indv-PA2":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(sys.argv)!=6:
        print("ERROR: Arguments incorrect for test-indv!")
        print("Usage: ./test.sh --test-indv category test_case")
        sys.exit(1)
    t1_start = time.perf_counter()
    readCSV(sys.argv[2])
    if item_exist(sys.argv[4]):
        #isHostReachable()
        #run_individual_testPA2(filename_csv,ubitname,testcase,testType,PAX)
        run_individual_testPA2(sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5],"PA2")
        t1_end = time.perf_counter()
        print("It takes",str(t1_end-t1_start-float(subtractSeconds))+"(s) to finish this script, where program total runtime is",str(getSumOfRunTime())+"(s)")
    else:
        print(colours.fg.red+"ERROR: Cannot find",sys.argv[4],"in the",sys.argv[2],colours.reset)
elif sys.argv[1]=="checksum":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    getCheckSum(sys.argv[2])
elif sys.argv[1]=="verify":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    verify(sys.argv[2],sys.argv[3])
elif sys.argv[1]=="getHost":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if int(sys.argv[2]) % 5 == 0:
        print("embankment.cse.buffalo.edu")
    elif int(sys.argv[2]) % 5 == 1:
        print("euston.cse.buffalo.edu")
    elif int(sys.argv[2]) % 5 == 2:
        print("highgate.cse.buffalo.edu")
    elif int(sys.argv[2]) % 5 == 3:
        print("stones.cse.buffalo.edu")
    elif int(sys.argv[2]) % 5 == 4:
        print("underground.cse.buffalo.edu")
elif sys.argv[1]=="check-parameter-PA2":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(os.environ["ubitname"])>8 or len(os.environ["ubitname"])<2:
        print("UBITname error!")
        sys.exit(1)
    if len(os.environ["semester"])==0:
        print("semester cannot be blank!")
        sys.exit(1)
    if len(str(sys.argv[4]))<8:
        print("Person number cannot be blank!")
        sys.exit(1)
elif sys.argv[1]=="check-parameter-PA1":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(os.environ["ubitname"])>8 or len(os.environ["ubitname"])<2:
        print("UBITname error!")
        sys.exit(1)
    if len(os.environ["semester"])==0:
        print("semester cannot be blank!")
        sys.exit(1)
elif sys.argv[1]=="run-experiments-batch":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    suppressHeader=bool(os.environ["suppressHeader"])
    buildPA2(os.environ["ubitname"])
    print("ABT binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+os.environ["ubitname"]+"/abt")[0])
    print("GBN binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+os.environ["ubitname"]+"/gbn")[0])
    print("SR  binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+os.environ["ubitname"]+"/sr")[0])
    print()
    count=0
    with open(sys.argv[2],'r') as openfile:
        for lines in openfile:
            temp.append(str(lines).strip('\n'))
        openfile.close()
        for items in temp:
            experimentsData.append((items.split(",")[0],items.split(",")[1],items.split(",")[2]))
        for line in experimentsData:
            count+=1
            print(colours.fg.lightgreen+"Running",count,"out of",len(experimentsData),colours.reset)
            if sys.argv[4]=="1":
                print("./run_experiments -m",1000,"-l",line[0],"-c",0.2,"-t",50,"-w",line[1],"-p",line[2])
                print("*********************************")
                run_experiments(1000,line[0],0.2,50,line[1],line[2],str(line[2])+"_"+str(line[1])+"_experiment1.csv",suppressHeader,sys.argv[3])
            elif sys.argv[4]=="2":
                print("./run_experiments -m",1000,"-l",line[0],"-c",0.2,"-t",50,"-w",line[1],"-p",line[2])
                print("*********************************")
                #run_experiments(messages,loss,corruption,time,window,binary,outputfile,supressHeader,ubitname):
                run_experiments(1000,line[0],0.2,50,line[1],line[2],str(line[2])+"_"+str(line[0])+"_experiment2.csv",suppressHeader,sys.argv[3])
elif sys.argv[1]=="test-experiment-one":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    buildPA2(sys.argv[2])
    print("ABT binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+sys.argv[2]+"/abt")[0])
    print("GBN binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+sys.argv[2]+"/gbn")[0])
    print("SR  binary SHA256:"+getFileChecksum("../cse489589_assignment2/"+sys.argv[2]+"/sr")[0])
    print()
    run_experiments(1000,0.1,0.2,50,10,"sr","result_sr.csv",suppressHeader,sys.argv[2])   
elif sys.argv[1]=="trim-all-reports":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    #print(glob.glob("../framework/report/PA2_experiments/*.csv"))
    listoffiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/*.csv"))
    if os.path.exists("../framework/report/PA2_experiments/old"):
        listofOldFiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/old/*.csv"))
        for files in listofOldFiles:
            listoffiles.append(files)
    if os.path.exists("../framework/report/PA2_experiments/v2"):
        listofNewerFiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/v2/*.csv"))
        for files in listofNewerFiles:
            listoffiles.append(files)
    notFirstLine=False
    #Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput
    for files in listoffiles:
        with open(files,'r') as openfile:
            for lines in openfile:
                if lines=="Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput\n" and notFirstLine==False:
                    notFirstLine=True
                    #print("First occurance")
                    temp.append(str(lines).strip('\n'))
                if lines!="Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput\n":
                    temp.append(str(lines).strip('\n'))
            openfile.close()
        with open(files,'w') as openfile:
            for lines in temp:
                openfile.write(lines+"\n")
            openfile.close()
        #print(temp)
        temp.clear()
        notFirstLine=False       
elif sys.argv[1]=="trim-all-headers":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    #print(glob.glob("../framework/report/PA2_experiments/*.csv"))
    listoffiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/*.csv"))
    if os.path.exists("../framework/report/PA2_experiments/old"):
        listofOldFiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/old/*.csv"))
        for files in listofOldFiles:
            listoffiles.append(files)
    if os.path.exists("../framework/report/PA2_experiments/v2"):
        listofNewerFiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/v2/*.csv"))
        for files in listofNewerFiles:
            listoffiles.append(files)
    notFirstLine=False
    #Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput
    for files in listoffiles:
        with open(files,'r') as openfile:
            for lines in openfile:
                if lines!="Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput\n":
                    temp.append(str(lines).strip('\n'))
            openfile.close()
        with open(files,'w') as openfile:
            for lines in temp:
                openfile.write(lines+"\n")
            openfile.close()
        #print(temp)
        temp.clear()
        notFirstLine=False
elif sys.argv[1]=="add-headers-to-all-files":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    #print(glob.glob("../framework/report/PA2_experiments/*.csv"))
    listoffiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/*.csv"))
    if os.path.exists("../framework/report/PA2_experiments/old"):
        listofOldFiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/old/*.csv"))
        for files in listofOldFiles:
            listoffiles.append(files)
    if os.path.exists("../framework/report/PA2_experiments/v2"):
        listofNewerFiles=copy.deepcopy(glob.glob("../framework/report/PA2_experiments/v2/*.csv"))
        for files in listofNewerFiles:
            listoffiles.append(files)
    notFirstLine=False
    #Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput
    for files in listoffiles:
        with open(files,'r') as openfile:
            for lines in openfile:
                if lines!="Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput\n":
                    temp.append(str(lines).strip('\n'))
            openfile.close()
        with open(files,'w') as openfile:
            openfile.write("Run,Messages,Loss,Corruption,Time_bw_messages,Application_A,Transport_A,Transport_B,Application_B,Total_time,Throughput\n")
            for lines in temp:
                openfile.write(lines+"\n")
            openfile.close()
        #print(temp)
        temp.clear()
        notFirstLine=False                         
elif sys.argv[1]=="self-check":
    print(sys.argv[-1])
elif sys.argv[1]=="clean-all-binaries":
    validUBITname(ubitname)
    if os.path.exists("../cse489589_assignment1/"+ubitname+"_pa1.tar"):
        os.remove("../cse489589_assignment1/"+ubitname+"_pa1.tar")
    if os.path.exists("../cse489589_assignment2/"+ubitname+"_pa2.tar"):
        os.remove("../cse489589_assignment2/"+ubitname+"_pa2.tar")
    if os.path.exists("../cse489589_assignment2/"+ubitname+"/Makefile"):
        os.system("cd ../cse489589_assignment2/"+ubitname+"; make clean >> /dev/null")
    if os.path.exists("../cse489589_assignment1/"+ubitname+"/Makefile"):
        os.system("cd ../cse489589_assignment1/"+ubitname+"; make clean >> /dev/null")
elif sys.argv[1]=="compile-PA1":
    if sys.argv[-1]=="test":
        print(sys.argv)
        sys.exit()
    if len(sys.argv)!=3 or len(sys.argv[2])==0 or len(sys.argv[2])>8:
        print(colours.fg.red+"ERROR: Arguments incorrect for compile-PA1!",colours.reset)
        print("Make sure UBITname is configured properly!")
        sys.exit(1)
    buildPA1(sys.argv[2])
# elif sys.argv[1]=="version":
#     print(version)
elif sys.argv[1]=="pre-auth":
    sys.exit(0)
elif sys.argv[1]=="check-PA1-grader-cfg":
    failedHostCheck=False
    with open("../cse489589_assignment1/grader/grader.cfg",'r') as openfile:
        for lines in openfile:
            temp.append(str(lines).strip('\n'))
        openfile.close()
    for lines in temp:
        if len(lines)>2 and lines.split(" ")[0]=="port:":
            try:
                port_cfg=int(lines.split(" ")[1])
            except:
                print("ERROR: grader.cfg is not configured for port field!")
                sys.exit(1)
            if port_cfg<=0:
                print("ERROR: Port is not valid!")
                sys.exit(1)
            print('INFO: "grader.cfg" configuration OK')
            for hosts in hostnamesForGrading:
                if os.system("nc -zv "+hosts+" "+str(port_cfg)+" >> /dev/null 2>&1")!=0:
                    print("ERROR: Port",port_cfg,"on",hosts,"is unreachable!")
                    failedHostCheck=True
            if failedHostCheck:
                sys.exit(1)
            print("INFO: Port check OK")
elif sys.argv[1]=="check-PA3-grader-cfg":
    with open("../cse489589_assignment3/grader/grader.cfg",'r') as openfile:
        for lines in openfile:
            temp.append(str(lines).strip('\n'))
        openfile.close()
    for lines in temp:
        if len(lines)>2 and lines.split(" ")[0]=="user:":
            try:
                lines.split(" ")[1]
            except:
                print("ERROR: grader.cfg is not configured for user field!")
                fail=True
        if len(lines)>2 and lines.split(" ")[0]=="id:":
            try:
                lines.split(" ")[1]
            except:
                print("ERROR: grader.cfg is not configured for id field!")
                fail=True
    if fail:
            sys.exit(1)
elif sys.argv[1]=="check-software-installed-ubuntu":
    check_software_installed_ubuntu()
elif sys.argv[1]=="check-software-installed-redhat-centos":
    check_software_installed_redhat_centos()
elif sys.argv[1]=="check-required-software":
    output = subprocess.check_output("lsb_release -i -s", shell=True)
    if output=="Ubuntu":
        check_software_installed_ubuntu()
    elif output=="CentOS Linux":
        check_software_installed_redhat_centos()
elif sys.argv[1]=="update-PA1-grader":
    os.system("cd ../cse489589_assignment1/grader/;rm -rf grader_controller;wget https://ubwins.cse.buffalo.edu/cse-489_589/grader/grader_controller")
elif sys.argv[1]=="update-PA2-grader":
    os.system("cd ../cse489589_assignment2/grader/;wget --no-check-certificate -r --no-parent -nH --cut-dirs=3 -R index.html https://ubwins.cse.buffalo.edu/cse-489_589/pa2/grader/")
elif sys.argv[1]=="retrieve-sys-info":
    print(os.environ["ubitname"])
elif sys.argv[1]=="prompt":
    prompt()
elif sys.argv[1]=="autocompile":
    print("Recompiling this script as a blob")
    try:
        #import pyinstaller
        os.system("pyinstaller -F ../framework/testTemplate.py && staticx dist/testTemplate ../framework/testTemplate_bin && rm -rf build dist testTemplate testTemplate.spec ../framework/__pycache__")
    except:
        print("pyinstaller is NOT installed!")
        sys.exit(1)
elif sys.argv[1]=="determine-whether-binary-is-needed":
    if int(sys.version_info[0])>=3 and int(sys.version_info[1])>=4:
        print("True")
    else:
        print("false")
elif sys.argv[1]=="test-category-PA2":
    #print("ubitname:",ubitname,"case:",testcase,"PAX:",PAX)
    ifRunningInLinux()
    buildPA2(ubitname)
    filenames=[("../framework/PA2_basic.csv","basic"),("../framework/PA2_advanced.csv","advanced"),("../framework/PA2_sanity.csv","sanity")]
    #filenames=[("../framework/PA2_basic.csv","basic")]
    for currentTest in filenames:
        if currentTest[1]==sys.argv[2]:
            readCSV(currentTest[0])
            temp_lists=copy.deepcopy(tests)
            for indv_item in temp_lists:
                callShellCommandsPA2(indv_item[1],"../cse489589_assignment2/"+ubitname+"/"+indv_item[1].lower(),global_timeout,"PA2",sys.argv[2])
    report("PA2")    
else:
    print("ERROR: Backend cannot understand your request!")
