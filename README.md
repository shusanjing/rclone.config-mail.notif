![image](https://raw.githubusercontent.com/shusanjing/rclone.config-mail.notif/master/示例-收到的邮件.png)

```
邮件正文:
gc[8/8]:

-1 2019-05-29 22:17:20 -1 [Auto]
-1 2019-05-29 20:02:06 -1 [PT]
-1 2019-05-31 05:42:02 -1 [测试用视频]
-1 2019-09-19 00:30:08 -1 【藏·剧集+动画】
-1 2019-09-19 13:30:16 -1 【藏·电影】
-1 2019-09-18 13:30:06 -1 【藏·综艺记录】

Total objects: 35350
Total size: 19.812 TBytes (21783115903930 Bytes)

脚本运行于: 2020-07-02 12:46:24
```

# rclone.config-mail.notif
* 适用谷歌 个人盘 和 团队盘.
* 项目目的:监控谷歌盘是否被删并且通知邮箱报错.
* 实现原理:通过自动提取rclone.conf配置文件,依次rclone size检查,报错或者返回0kb(团队盘刚被删不会立即报错,只是内容变空,返回0kb大小)则发邮件告知报错.
* 脚本:项目有bash和python3两种脚本,功能相同,需要的邮件模块不同,建议使用python脚本搭配yagmail.

## 语法选择
* 通过条件匹配提取符合规则的字符串(用来提取rclone.conf中的配置名)
```
#rcloneconf=$(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf | tr "\n" " ") #使用tr命令将文本中的回车转换成空格
#rcloneconf=$(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf) #从文本提取table名称默认为每行一个
#rcloneconf=($(grep -oP '(?<=\[).*?(?=\])' ./.config/rclone/rclone.conf | tr "\n" " ")) #包含转成数组语法array=($rcloneconf) 
```
