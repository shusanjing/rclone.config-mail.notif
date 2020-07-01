#! python3
##如果共享盘被删除,rclone并不会报错而是返回(0, 'Total objects: 0\nTotal size: 0 Bytes (0 Bytes)')
import yagmail #需要pip额外安装yagmail
import subprocess
import re
import os
from datetime import datetime
mailsmtp = 'smtp.qq.com'
mailuser = 'aaa@qq.com'
mailpassword = 'bbb'
mailto = ['ccc@qq.com'] #发往邮箱
date = datetime.now().strftime('%Y-%m-%d') #本地日期.字符串格式化
time = datetime.now().strftime(' %H:%M:%S') #本地时间.字符串格式化
file_object = open("/root/.config/rclone/rclone.conf") #rclone配置文件的路径
try:
    all_the_text = file_object.read()
    ## print(all_the_text)
    table = re.findall(r"\[(.+?)\]", all_the_text) #提取rclone配置名.正则匹配[]中的字符串
    sum = '['+str(len(table))+']' #获取列表数量.字符串化
    print ('List个数:',sum) #py3
finally:
    file_object.close() #关闭文件
    print ('提取的名单List:',table)
    # ----循环list---- #
    i = 0
    ##for var in table:        #正序
    for var in table[::-1]:    #倒序
        print('--------------')
        i=i+1   #
        num = '['+str(i)+'/'+str(len(table))+']'
        print ('List当前元素:','('+str(i)+")"+'/'+sum,var) #str(i)将数字i转成字符才可以用+和字符串连起来
        ##指令明说:subprocess.getstatusoutput('df -lh')返回shell命令的stdout和stderr(为元组类型:下标0执行状态,下标1标准输出)
        ##rcls = subprocess.getstatusoutput('rclone lsf '+var+':') #返回元组类型.包含文件和目录
        rcls = subprocess.getstatusoutput('rclone lsd '+var+':') #返回元组类型.只包含目录
        print('开始计算网盘已使用大小......')
        rcsize = subprocess.getstatusoutput('rclone size '+var+':') #查询网盘占用体积.返回元组类型
        print("查询类型:subprocess.getstatusoutput返回类型为:",type(rcls)) #查询类型
        print("命令执行返回元组数据:",rcls)
        print("命令执行返回标准输出:\n",rcls[1]) #输出命令返回标准输出和标准错误
        print('开始判断是否网盘正常....')
        if os.system('rclone lsd '+var+':')  !=0: #返回0和非0的执行状态
            print ('print: failed') #py3
            state = ('报错')
        elif rcls[1]=='':#共享盘被删除返回空值
            print ('print: 共享盘lsd空值可能被删除') #py3
            state = ('空值')
        else:
            print ('print: succed') #py3
            state = ('正常')
        print('命令执行状态为:'+state)
        # ------ 发送邮件提醒-需要安装yagmail模块 ------#   
        yag = yagmail.SMTP(user=mailuser,password=mailpassword,host=mailsmtp)
        yag.send(mailto,state+'[rclone配置状态检查]'+date+sum,"邮件正文:\n"+var+num+':\n\n'+rcls[1]+'\n\n'+rcsize[1]+'\n\n脚本运行于: '+date+time)
        print("已发送邮件:",state+'[rclone配置状态检查]'+sum)
    print("=======脚本END=======")

