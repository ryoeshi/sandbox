#!/bin/sh

# ログファイル名
LOG=remove_old_files.log

# コンテンツルートディレクトリの設定
EXEC_DIR=/

# ディレクトリ名
CONTENTS_DIR=contents

# ディレクトリ名
SERVICE_DIR=service

##### 関数定義 #####

# 削除後にログを出力
function remove_with_log ()
{
	echo rm -rf $1
	echo "  * $1 removed."
}

# バックアップディレクトリの削除
function delete_old_backup ()
{
	TEMP_DIRS=`find $1 -type d -name '*_back'`
	for TEMP_DIR in $TEMP_DIRS ; do
		remove_with_log $TEMP_DIR
	done
}

# 編集用ディレクトリの削除
function delete_old_edit ()
{
	TEMP_DIRS=`find $1 -type d -name '*_edit'`
	for TEMP_DIR in $TEMP_DIRS ; do
		remove_with_log $TEMP_DIR
	done
}

# 保存用ディレクトリの削除
function delete_old_simple ()
{
	TEMP_DIRS=`find $1 -type d -name '????????simple'`
	for TEMP_DIR in $TEMP_DIRS ; do
		remove_with_log $TEMP_DIR
	done
}

# 削除対象検索
function delete_old_temporary ()
{
	delete_old_backup $1
	delete_old_edit $1
	delete_old_simple $1
}

# SERVICEディレクトリパス検索 
function find_service_directories_with_delete ()
{
	# サービスプロバイダディレクトリ一覧を取得
	TEMP_DIRS=`(find $1/$CONTENTS_DIR -maxdepth 1 -type d | grep -v '^\.$') 2>/dev/null`
	for SP_DIR in $TEMP_DIRS ; do
		TARGET_DIR=$SP_DIR/$SERVICE_DIR
		if [ -e $TARGET_DIR ] ; then
			echo "  - $TARGET_DIR processing."
			delete_old_temporary $TARGET_DIR
#		else
#			echo "  - skipped. [$TARGET_DIR not found.]"
		fi
	done
}

##### 関数定義 #####

cat << MESSAGE
-----------------------------------
以下の設定値をコンテンツの
ルートディレクトリとして
旧一時ファイルを削除します。
$EXEC_DIR

実行する場合は yes と入力後、
エンターキーを押下して下さい。
-----------------------------------
MESSAGE

read INPUT
case "$INPUT" in
yes)
        ;;
*)
        echo "削除処理を中止しました。"
        exit 1;
esac

DATE=`date '+%Y/%m/%d %H:%M:%S'`
echo "=== remove files start. [$DATE] ===" | tee -a $LOG

# # 実行ディレクトリパスのチェック
# if [ "x$EXEC_DIR" == "x" ] ; then
# 	echo "EXEC_DIR setting none."
# 	exit 0
# fi
# 
# # 実行ディレクトリの移動
# cd $EXEC_DIR
# 
# # cd の正否判定
# if [ $? -ne 0 ] ; then
# 	echo "cd failed.[$EXEC_DIR]"
# 	exit 0
# fi

# ディレクトリの一覧を取得(一時ディレクトリは除外)
CP_DIRS=`find $EXEC_DIR -maxdepth 1 -type d -name 'tmp_*' -prune -o -print`
COUNT=`find $EXEC_DIR -maxdepth 1 -type d -name 'tmp_*' -prune -o -print | wc -l`

echo "find [$COUNT] directories." | tee -a $LOG

# 各ディレクトリ内のSERVICEディレクトリに削除対象検索処理を実行
for CP_DIR in $CP_DIRS ; do
	echo " -  $CP_DIR processing." | tee -a $LOG
	(find_service_directories_with_delete $CP_DIR) >> $LOG
done

DATE=`date '+%Y/%m/%d %H:%M:%S'`
echo "=== remove files done. [$DATE] ===" | tee -a $LOG

