# CSE331 Unit Test Script

**Dropped support as of July 2019.**

Automating test process by compiling once then run `Case 1`, `Case 2`, and `Case 5`. After all test case finish running, it will automatically delete the compiled binary.
### This shell script only works on C++ version of Atri's CSE331 Q1

### If shell is not working, please make sure your endline character is set to `LF`

# How to use this script

To download and run: `wget -O start.sh https://hbai.me/newer331shell && chmod u+x start.sh && ./start.sh`

To run unit tests: `./start.sh`

To replace with a newer version: `./start.sh --update`

Force upgrader to replace this script with whatever is on the GitHub: `./start.sh --force-update`

Check whether you are on a beta or stable `./start.sh --status`

Check your version number `./start.sh --version`

More functionality are coming soon

# How it works
Let me explain how this script will work.
At first, `set -e` will stop the script from running when the exit code is non-zero, e.g. failed to compile.

1. The first `echo` statement will print current date and time in `DD MMM YYYY HH:MM:SS` format. e.g. `21 Dec 2018 12:31:12`

Then `if hash g++ 2>/dev/null` checks if there is C++ compiler presents
* if so->It will print C++ compiler version and continue
* if not->It will print out an error and stop the script from running

2. Then it will check by see if Atri's test cases presents
* If the script can find `testcases/input1.txt`, `testcases/input2.txt`, and `testcases/input5.txt`. Then it will continue. Otherwise, it will stop running since it will break the testing code

3. If there is leftover `a.out`, this script will print out a warning and then delete it.

4. It will start compiling the program

5. Since the line of `set -e` might be disabled, to prevent the system from throwing any errors, I will check once again if `a.out`  presents
* If so->Continue
* If not->Stop

6. (Optional) If you set up the `$customcase` then it will show up and ask whether you want to test it. Unlike `Case 1`, `Case 2`, and `Case 5`. You have to type something to start the script

7. Congratulations! It will start these main tests so it will run starting from 

`******************************************************************`

8. Finally, it will print out the approximated runtime from the binary itself. It is for an approximation purpose, since if you want to make it more precise, you would want to implement it in the test code instead.

9. Lastly, it will delete the `a.out`
