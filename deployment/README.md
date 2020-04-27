# Deployment Scripts
`linux_setup` is where I setup those coding environment in Linux environments

`management` is where I save the common diagnostic script for my Ubuntu setup.

It only supports Ubuntu LTS releases for auto setup. Currently, it supports `18.04` and `20.04` is in beta support.

**If shell is not working, please make sure your endline character is set to `LF`**

# How to run this script
Intel and AMD Display Adapter `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/master/deployment/entry.sh && chmod u+x entry.sh && sudo ./entry.sh`

NVIDIA Display Adapter `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/master/deployment/entry.sh && chmod u+x entry.sh && sudo ./entry.sh --nvidia`

WSL & WSL2 `wget -O entry.sh https://github.com/johnkramorbhz/Scripts/raw/master/deployment/entry.sh && chmod u+x entry.sh && sudo ./entry.sh --no-GUI`
