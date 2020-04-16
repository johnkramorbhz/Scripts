# CSE489 Auto Tester Framework

PROVIDED AS IS WITHOUT WARRANTY OR SERVICE.

## Looking for usage?

[Click here for usage](https://github.com/johnkramorbhz/Scripts/blob/master/unit_tests/CSE489/usage.md)

## Installation

If you do not want to use `python3`

`wget https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate_bin; chmod u+x testTemplate_bin; ./testTemplate_bin install`

If you want to use `python3`

`wget https://github.com/johnkramorbhz/Scripts/raw/master/unit_tests/CSE489/testTemplate.py; python3 testTemplate.py install`

After installation, the directory structure looks like this

```
cse489589_assignment1/
cse489589_assignment2/
framework/
```

## High-level overview

Under `framework/report`, there are reports having name of `PAX_Date_Time`, where date is formatted `YYYY-MM-DD` and time is `HH.MM.SS`

`testTemplate.py` is the backend of the `./test.sh` in each Programming Assignment folder

It is also available in the binary form, which is `testTemplate_bin`. I will manually update `testTemplate_bin` because `pyInstaller` does not create a static binary. 

It requires `python3` on CentOS 7 and later(e.g. Ubuntu 18.04 and later). If it does not work for whatever reason or you prefer one of the modes, find these lines in the `test.sh`

```bash
#use_binary="false" #This line allows a static python library to be used. Hence, no need to worry about the python version
#use_binary="force_script" #Uncomment this line to force Python3 interpreter
```


## Interpret `.csv` files that are used in the readCSV() function

For PA1, it is 

`author,author,0` means `friendly name, shell command, total grade for this item`

For PA2, it is divided into 3 files as `basic`, `advanced`, and `sanity`

For PA2 experiments, it is divided by PA2 documentation. LOOK CAREFULLY for what it asks. Even though I don't think he will change anything.

## Interpret `experiments.csv` files

"loss","window","binary_name"
