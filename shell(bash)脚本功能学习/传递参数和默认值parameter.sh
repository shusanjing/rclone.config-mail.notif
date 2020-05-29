# bash parameter.sh 11 22
#当变量a为null或为空字符串时则var=b  
var1=${1:-aaa}  
var2=${2:-bbb}

echo $1
echo $2
echo
echo $var1
echo $var2

