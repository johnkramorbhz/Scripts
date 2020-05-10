import os,threading
semester="F19"
semester_full="Fall2019"
useragent='"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36"'
baseLecURL="http://www.cse.buffalo.edu/~lusu/cse4589/"+semester_full+"/ClassNotes/"
baseHWURL="http://www.cse.buffalo.edu/~lusu/cse4589/"+semester_full+"/Homeworks/"
semester_user="cse4589"
semester_password="knox104"
def check_reach(URL):
    if os.system("wget -q -U "+useragent+" --spider "+URL)==0:
        return True
    else:
        return False
def download_file(URL):
    if os.system("wget -U "+useragent+" -q "+URL)==0:
        return True
    else:
        return False
def download_secure_file(URL,username,password):
    if os.system("wget -U "+useragent+" --user "+username+" --password "+password+" -q "+URL)==0:
        return True
    else:
        return False
def dump_all_lecture():
    download_file(baseLecURL+"overview.pdf")
    for x in range(1,6):
        if check_reach(baseLecURL+"Ch"+str(x)+"-"+semester+".pdf") and download_file(baseLecURL+"Ch"+str(x)+"-"+semester+".pdf"):
            print("Ch"+str(x)+"-"+semester+".pdf","downloads successfully")
        else:
            print("Skipping","Ch"+str(x)+"-"+semester+".pdf")
def dump_all_hws():
    for x in range(1,5):
        #print(baseHWURL+"hw"+str(x)+"_2019.pdf")
        if download_secure_file(baseHWURL+"hw"+str(x)+"_2019.pdf",semester_user,semester_password):
            print("hw"+str(x)+"_2019.pdf","downloads successfully")
        else:
            print("Skipping","hw"+str(x)+"_2019.pdf")
        if download_secure_file(baseHWURL+"hw"+str(x)+"_sol_2019.pdf",semester_user,semester_password):
            print("hw"+str(x)+"_sol_2019.pdf","downloads successfully")
        else:
            print("Skipping","hw"+str(x)+"_sol_2019.pdf")
thread1=threading.Thread(target=dump_all_lecture)
thread2=threading.Thread(target=dump_all_hws)
thread1.start()
thread2.start()
thread1.join()
thread2.join()