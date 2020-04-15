# CSE489 Auto Tester Framework

PROVIDED AS IS WITHOUT WARRANTY OR SERVICE.

## Looking for usage?

[Click here for usage](https://github.com/johnkramorbhz/Scripts/blob/master/unit_tests/CSE489/usage.md)

## Installation

Make a soft link for `PA1_test.sh` and `PA2_test.sh` to each directory respectively.

e.g. `PA1_test.sh` goes to `../cse489589_assignment1` and `PA2_test.sh` goes to `../cse489589_assignment2`

Where directory structure is

```
../cse489589_assignment1/
../cse489589_assignment2/
../framework/
```
`../framework/` contains everything else other and it is where these item goes.

## High-level overview

By default the `framework/report` folder will be ignored by the git because this repository only serves as a code base.

Under `framework/report`, there are reports having name of `PAX_Date_Time`, where date is formatted `YYYY-MM-DD` and time is `HH.MM.SS`

`testTemplate.py` is the backend of the `./test.sh` in each Programming Assignment folder

It requires `python3` on CentOS 7 and later(e.g. Ubuntu 18.04 and later). If it is too old, I cannot assure it will work.

```
timberlake {~} > python3 --version
Python 3.4.3
```


## Interpret `.csv` files that are used in the readCSV() function

For PA1, it is 

`author,author,0` means `friendly name, shell command, total grade for this item`

For PA2, it is divided into 3 files as `basic`, `advanced`, and `sanity`

For PA2 experiments, it is divided by PA2 documentation. LOOK CAREFULLY for what it asks. Even though I don't think he will change anything.

## Interpret `experiments.csv` files

"loss","window","binary_name"
