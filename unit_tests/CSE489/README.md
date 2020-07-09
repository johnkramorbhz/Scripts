# CSE489 & CSE589 Auto Tester Framework

**Dropped support as of 8 May 2020.**

PROVIDED AS IS WITHOUT WARRANTY OR SERVICE. You may fork this project and continue on your own. However, I will not push any more changes unless it is a bugfix. Only work with these projects in these links. [Link1](https://docs.google.com/document/u/1/d/135usaNDMnJ5pEDG-UbspZameDPmOH0DmXLrMVrLVJ88/pub) [Link2](https://docs.google.com/document/u/1/d/19I8-TrLNcfaCGX1L-KSx5xFYEoiFAN3F9o_jQlOgsFM/pub)

### [Click here for usage](https://github.com/johnkramorbhz/Scripts/blob/main/unit_tests/CSE489/usage.md)

## Please Note

Even though the static binary is built from Ubuntu 20.04, running in Ubuntu 20.04 is not formally tested.

To reduce the problem of dynamically linked binary(if you have a newer build system than the target system, it will not run), I require `staticx` in addition to the `pyinstaller`. This is a 64-bit binary, which only works on 64-bit Linux OSes. By running `file testTemplate_bin`, here is the output:

```bash
testTemplate_bin: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, not stripped
```

SHA256 checksum by running `sha256sum testTemplate_bin`:

`6d402509fb18eeff9a22b54b6c22220599c32f464451f57ca3f37dc351159742  testTemplate_bin`

*If you have Ubuntu version higher than 18.04, it is not guaranteed that the python script version will work correctly, since python is an interpreted programming language. Even though I patched the python 3.8 deprecated function, I have not test anything else. In this case, you might need to use the binary instead if the outcome is incorrect, and you might need to link them to the script by yourself.*

You can use an older shell script with the new python script or binary but not the other way around. If you have the pre-opensource version, you will have to manually replace all scripts as there are many changes implemented.

## Installation

Why here? It will take care of populating PA1 & PA2 for you. In addition, it will also prepare test scripts for both PA1 and PA2. After installation, you will need to add the following info in these scripts.

```bash
ubitname=""
fullname=""
semester="" #e.g. semester="Spring_2020"
personNumber=""
#PA2 only
suppressHeader="" # Put anything inside "" to set it to be true
#End of PA2 only
```

For PA2, if you are grad student, add the following

```bash
gradMode="" # Put anything inside "" to set it to be true
```

If you do not want to use `python3` (A backup solution)

`wget https://github.com/johnkramorbhz/Scripts/raw/main/unit_tests/CSE489/testTemplate_bin && chmod u+x testTemplate_bin && ./testTemplate_bin install`

If you want to use `python3` **Preferred**

`wget https://github.com/johnkramorbhz/Scripts/raw/main/unit_tests/CSE489/testTemplate.py && python3 testTemplate.py install`

After installation, the directory structure looks like this

```
cse489589_assignment1/
cse489589_assignment2/
framework/
```

It requires `python3` on CentOS 7 and later(e.g. Ubuntu 18.04 and later). If it does not work for whatever reason or you prefer one of the modes, find these lines in the `test.sh`

```bash
#use_binary="false" #Uncomment this line to force binary
#use_binary="force_script" #Uncomment this line to force Python3 interpreter
```

## Update

Both script version and binary version in this repo supports update from themselves. AFTER go to `framework` directory, use the command below

Script version: `python3 testTemplate.py update`

Binary version: `./testTemplate_bin update`

## High-level overview

Under `framework/report`, there are reports having name of `PAX_Date_Time`, where date is formatted `YYYY-MM-DD` and time is `HH.MM.SS`

`testTemplate.py` is the backend of the `./test.sh` in each Programming Assignment folder

It is also available in the binary form, which is `testTemplate_bin`. You need `pyInstaller` & `staticx` to create a static binary that works on any Linux machines/servers. [Compile Guide](https://github.com/johnkramorbhz/Scripts/blob/main/unit_tests/CSE489/usage.md#re-compile-binary)

## Interpret `.csv` files that are used in the readCSV() function

For PA1, it is 

`author,author,0` means `friendly name, shell command, common grade`

For PA2, some files will have 4 columns instead of 3.

If a CSV file have 4 columns, it means `friendly name,shell command,undergrad grade,grad grade`

For PA2 experiments, it is divided by PA2 documentation. LOOK CAREFULLY for what it asks. Even though I don't think he will change anything.

## Interpret `experiments.csv` files

"loss","window","binary_name"

e.g.

`0.1,10,sr`

## High Level Design of This Framework

The `test.sh` in each Programming Assignment directory is a high level abstraction of the python script, because python scripts have many differnt arguments depending on its tasks.

The python script is unified instead of dividing it into each individual PA test script, because the enhancement will benefit both PAs.

The main goal of this script is to save time for debugging, and have some estimation of final grade.

## Run Experiments Code Example

```python
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
```

Invoke part(Python)

```python
#Experiment 1
run_experiments(1000,line[0],0.2,50,line[1],line[2],str(line[2])+"_"+str(line[1])+"_experiment1.csv",suppressHeader,sys.argv[3])
#Experiment 2
run_experiments(1000,line[0],0.2,50,line[1],line[2],str(line[2])+"_"+str(line[0])+"_experiment2.csv",suppressHeader,sys.argv[3])
```

Invoke part(bash)

```bash
python3 $pathofpythonscript run-experiments-batch "../framework/PA2_experiment2_0.2_ds.csv" $ubitname 2
```