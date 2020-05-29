######## 必须修改的变量 ########
mail="admin@qq.com"        	      ###自定义.要发往的邮箱地址
######## 可不修改的变量 ########
svr_name="[rclone配置状态检查]"          	 ###自定义.邮件主体名称
str_time=$(date +"%Y-%m-%d")              #日期变量
title="$svr_name $str_time"               #邮件标题
failedtitle="报错 $svr_name $str_time" 	#执行错误后的邮件标题
succeedtitle="正常 $svr_name $str_time"   #执行正确后的邮件标题
######## 动态变量 ########
#rcloneconf=$(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf) #从文件提取table名称
rcloneconf=$(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf | tr "\n" " ") #使用tr命令将文件中的回车转换成空格
#rcloneconf=($(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf | tr "\n" " ")) #包含转成数组语法array=($rcloneconf) 

array=($rcloneconf) #转成数组
num=${#array[@]} #获取数组数量 
echo "输出rcloneconf:$rcloneconf"
echo "输出array:$array"
echo "输出num总数:$num"
echo "-----------" #换行

for var in ${rcloneconf[@]};	#数组循环
do
    let ++i    				   #i的值递增1
    echo "输出标签:$var[$i/$num]"
#	rclone lsd $var:		   #执行rclone目录查看命令
    rclonelsd=$(rclone lsd $var: 2>&1) #命令结果赋值给变量,默认只会得到命令成功的输出,如果命令执行失败则返回一个空行,这一步是把标准错误写入标准成功的变量.
	if [ $? -ne 0 ]; then		#判断上一条命令执行结果是否0
		echo "failed"
        title=$failedtitle 		#标识错误执行结果作为邮件标题
	else
    	echo "succeed"
        title=$succeedtitle      #标识正常执行结果作为邮件标题     
	fi
###### 发送邮件 #####
	echo -e "输出rclonelsd执行结果:\n${rclonelsd}"
#    echo -e "$var[$i/$num]\n${rclonelsd}" | mutt -s "$title[$num]信尾" $mail   #echo -e使之激活转义字符
 
 
    runinfo=$(time rclone size $var: 2>&1) # ,如果文件数量非常多耗时比较久可以禁用此命令
    echo $runinfo
    echo -e "$var[$i/$num]\n${rclonelsd}\n${runinfo}\n结尾" | mutt -s "$title[$num]信尾" $mail   #echo -e使之激活转义字符        

    echo "邮件发送完毕-----------" #换行
done
