#!/bin/sh

cat << MESSAGE
-----------------------------------
実行する場合は yes と入力後、
エンターキーを押下して下さい。
-----------------------------------
MESSAGE

read NUM
case "$NUM" in 
yes)
	;;
*)
	echo "remove not executed."
	exit 1;
esac

echo "start"

