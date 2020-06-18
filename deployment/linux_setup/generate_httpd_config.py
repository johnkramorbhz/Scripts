import os,sys
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
        #</VirtualHost>
        openfile.write(basic[1]+"\n")
# To use it, you need to provide a text file that contains all domains you want
# sys.argv[1]=file that contains list of domains
if sys.argv[1]=="--bulk" and os.path.exists(sys.argv[2]):
    with open(sys.argv[2],'r') as openfile:
        for lines in openfile:
            raw_domains.append("".join(str(lines).split().strip('\n')))
    for domains_info in raw_domains:
        generate_single_conf(domains_info)
# Bulk mode and file does not exist
elif sys.argv[1]=="--bulk" and not os.path.exists(sys.argv[2]):
    print("ERROR:",sys.argv[2],"does NOT exist.")
# Single server mode
elif sys.argv[1]=="--single" and sys.argv[2]!="":
    generate_single_conf(sys.argv[2])