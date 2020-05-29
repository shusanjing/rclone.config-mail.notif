# rclone.config-mail.notif
谷歌盘监控并且通知邮箱报错

## 语法选择
* 通过条件匹配提取符合规则的字符串(用来提取rclone.conf中的配置名)
```
#rcloneconf=$(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf | tr "\n" " ") #使用tr命令将文本中的回车转换成空格
#rcloneconf=$(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf) #从文本提取table名称默认为每行一个
#rcloneconf=($(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf | tr "\n" " ")) #包含转成数组语法array=($rcloneconf) 
```
