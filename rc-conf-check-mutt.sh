######## 邮件目的地变量 ########
mail=${1:-"mail@qq.com"} #自定义.修改mail@qq.com成要发往的邮箱地址;同时支持传递脚本参数(第一个参数是$1)。"语法:bash rc-mail.sh 8888@qq.com"
echo "传入参数:$@"
echo "mail变量:$mail"
######## 邮件标题变量 ########
svr_name="[rclone配置状态检查]" ###自定义.邮件主体名称
str_time=$(date +"%Y-%m-%d") #日期变量
title="$svr_name $str_time" #邮件标题
failedtitle="报错 $svr_name $str_time" #执行错误后的邮件标题
succeedtitle="正常 $svr_name $str_time" #执行正确后的邮件标题
######## rclone配置提取成数组变量 ######## "rclone config file查看配置文件的路径"
rcloneconf=$(grep -oP '(?<=\[).*?(?=\])' /root/.config/rclone/rclone.conf | tr "\n" " ") #使用tr命令将文本中的回车转换成空格
array=($rcloneconf) #转成数组
num=${#array[@]} #获取数组数量 
echo "输出rcloneconf:$rcloneconf"
echo "输出array:$array"
echo "输出num总数:$num"
echo "-----------" #换行

################ 数组循环 ################ 
for var in ${rcloneconf[@]};   
do
    let ++i #i的值递增1
    echo "输出标签:$var[$i/$num]"
    rclonelsd=$(rclone lsd $var: 2>&1) #命令结果赋值给变量,默认只会得到命令成功的输出,如果命令执行失败则返回一个空行,这一步是把标准错误写入标准成功的变量.
 if [ $? -ne 0 ]; then #判断上一条命令执行结果是否0
  echo "failed"
        title=$failedtitle #标识错误执行结果作为邮件标题
 else
     echo "succeed"
        title=$succeedtitle #标识正常执行结果作为邮件标题     
 fi
    echo -e "输出rclonelsd执行结果:\n${rclonelsd}"

 #### 发送邮件 ####
    runinfo=$(time rclone size $var: 2>&1) #查询目录占用体积,如果文件数量非常多耗时比较久可以禁用此命令
    echo $runinfo
    echo -e "$var[$i/$num]\n${rclonelsd}\n${runinfo}\n结尾" | mutt -s "$title[$num]信尾" $mail #echo -e使之激活转义字符        
    echo "邮件发送完毕-----------" #换行
done
