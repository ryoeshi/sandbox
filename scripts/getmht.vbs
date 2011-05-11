Option Explicit

'保存先ディレクトリ
Const SAVEDIR = "\\umenew\share\radio\ades"
Const adSaveCreateOverWrite = 2

Dim oParam
Dim CDO
Dim sDate
Dim sTitle
Dim sUrl
Dim sFilename

'コマンドライン引数（パラメータ）の取得
Set oParam = WScript.Arguments

'コマンドラインパラメータを取得
sUrl = oParam(0)
sTitle = oParam(1)
sDate = oParam(2)

'WScript.echo "sUrl:" + sUrl
'WScript.echo "sTitle:" + sTitle
'WScript.echo "sDate:" + sDate

'削除
'sUrl = Replace(sUrl, "http://", "")
'sUrl = Replace(sUrl, "?", "")

'変換
sDate = Replace(sDate, " ", "_")
sDate = Replace(sDate, ":", "_")
sDate = Replace(sDate, "/", "_")
'sUrl = Replace(sUrl, ".", "_")
'sUrl = Replace(sUrl, "/", "_")

'保存ファイルパスを設定
sFilename = SAVEDIR+"\"+sTitle+"_"+sDate+".mht"

Set CDO = WScript.CreateObject("CDO.Message")
CDO.CreateMHTMLBody sUrl
CDO.GetStream.SaveToFile sFilename,adSaveCreateOverWrite
WScript.echo sUrl + " -> " + sFilename
