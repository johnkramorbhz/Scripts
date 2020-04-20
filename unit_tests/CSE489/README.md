# CSE489 & CSE589 Auto Tester Framework

PROVIDED AS IS WITHOUT WARRANTY OR SERVICE. Only work with these projects in these links. [Link1](https://docs.google.com/document/u/1/d/135usaNDMnJ5pEDG-UbspZameDPmOH0DmXLrMVrLVJ88/pub) [Link2](https://docs.google.com/document/u/1/d/19I8-TrLNcfaCGX1L-KSx5xFYEoiFAN3F9o_jQlOgsFM/pub) [Link3](https://docs.google.com/document/u/1/d/1_Lm54xrsUxKFc25l54qIxFIlQS3ywIyAEQfa2jTB1JQ/pub)

### [Click here for usage](https://github.com/johnkramorbhz/Scripts/blob/master/unit_tests/CSE489/usage.md)

## Installation

Why here? It will take care of populating PA1 & PA2 for you. In addition, it will also prepare test scripts for both PA1 and PA2. After installation, you will need to add the following info in these scripts.

```bash
ubitname=""
fullname=""
semester=""
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

`wget https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate_bin; chmod u+x testTemplate_bin; ./testTemplate_bin install`

If you want to use `python3` **Preferred**

`wget https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate.py; python3 testTemplate.py install`

After installation, the directory structure looks like this

```
cse489589_assignment1/
cse489589_assignment2/
framework/
```

## Update

Both script version and binary version in this repo supports update from themselves. AFTER go to `framework` directory, use the command below

Script version: `python3 testTemplate.py update`

Binary version: `./testTemplate_bin update`

## High-level overview

Under `framework/report`, there are reports having name of `PAX_Date_Time`, where date is formatted `YYYY-MM-DD` and time is `HH.MM.SS`

`testTemplate.py` is the backend of the `./test.sh` in each Programming Assignment folder

It is also available in the binary form, which is `testTemplate_bin`. You need `pyInstaller` & `staticx` to create a static binary that works on any Linux machines/servers. [Compile Guide](https://github.com/johnkramorbhz/Scripts/blob/master/unit_tests/CSE489/usage.md#re-compile-binary)

It requires `python3` on CentOS 7 and later(e.g. Ubuntu 18.04 and later). If it does not work for whatever reason or you prefer one of the modes, find these lines in the `test.sh`

```bash
#use_binary="false" #Uncomment this line to force binary
#use_binary="force_script" #Uncomment this line to force Python3 interpreter
```


## Interpret `.csv` files that are used in the readCSV() function

For PA1, it is 

`author,author,0` means `friendly name, shell command, common grade`

For PA2, some files will have 4 columns instead of 3.

If a CSV file have 4 columns, it means `friendly name,shell command,undergrad grade,grad grade`

For PA2 experiments, it is divided by PA2 documentation. LOOK CAREFULLY for what it asks. Even though I don't think he will change anything.

## Interpret `experiments.csv` files

"loss","window","binary_name"
