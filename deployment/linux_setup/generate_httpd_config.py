import os,sys,string
# If needed, add your email address in webmaster variable so ServerAdmin is not blank. 
webmaster=""

# Copyright (c) 2020 johnkramorbhz

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
raw_domains=[]
basic=["<VirtualHost *:80>","</VirtualHost>"]
centos_config_absolute_path_prefix="/etc/httpd/conf.d/"
ubuntu_config_absolute_path_prefix="/etc/apache2/sites-available/"
html_folder_prefix="/var/www/"
if len(sys.argv)<2:
    print("ERROR: No arguments provided!!!")
    sys.exit(1)
try:
    if sys.argv[3]=="":
        print("ERROR: No distribution info provided!!!")
        sys.exit(1)   
except:
    print("ERROR: No distribution info provided!!!")
    sys.exit(1)
def generate_single_conf(domain):
    if sys.argv[3]=="centos":
        full_path=centos_config_absolute_path_prefix+domain+".conf"
    elif sys.argv[3]=="Ubuntu":
        full_path=ubuntu_config_absolute_path_prefix+domain+".conf"
    else:
        print("ERROR: Not supported!!!")
        sys.exit(1)
    html_full_path=html_folder_prefix+domain+"/"
    if not os.path.exists(html_full_path):
        os.mkdir(html_full_path)
    with open(full_path,'w+') as openfile:
        #<VirtualHost *:80>
        openfile.write(basic[0]+"\n")
        openfile.write("ServerName "+domain+"\n")
        openfile.write("DocumentRoot "+html_full_path+"\n")
        if webmaster!="":
            openfile.write("ServerAdmin "+webmaster+"\n")
        #</VirtualHost>
        openfile.write(basic[1]+"\n")
# To use it, you need to provide a text file that contains all domains you want
# sys.argv[1]=file that contains list of domains
if sys.argv[1]=="--bulk" and os.path.exists(sys.argv[2]):
    with open(sys.argv[2],'r') as openfile:
        for lines in openfile:
            # Get rid of newline character and also whitespace
            raw_domains.append(lines.translate({ord(c): None for c in string.whitespace}))
    for domains_info in raw_domains:
        generate_single_conf(domains_info)
# Bulk mode and file does not exist
elif sys.argv[1]=="--bulk" and not os.path.exists(sys.argv[2]):
    print("ERROR:",sys.argv[2],"does NOT exist.")
# Single server mode
elif sys.argv[1]=="--single" and sys.argv[2]!="":
    generate_single_conf(sys.argv[2])