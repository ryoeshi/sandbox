Option Explicit

'�ۑ���f�B���N�g��
Const SAVEDIR = "\\umenew\share\radio\ades"
Const adSaveCreateOverWrite = 2

Dim oParam
Dim CDO
Dim sDate
Dim sTitle
Dim sUrl
Dim sFilename

'�R�}���h���C�������i�p�����[�^�j�̎擾
Set oParam = WScript.Arguments

'�R�}���h���C���p�����[�^���擾
sUrl = oParam(0)
sTitle = oParam(1)
sDate = oParam(2)

'WScript.echo "sUrl:" + sUrl
'WScript.echo "sTitle:" + sTitle
'WScript.echo "sDate:" + sDate

'�폜
'sUrl = Replace(sUrl, "http://", "")
'sUrl = Replace(sUrl, "?", "")

'�ϊ�
sDate = Replace(sDate, " ", "_")
sDate = Replace(sDate, ":", "_")
sDate = Replace(sDate, "/", "_")
'sUrl = Replace(sUrl, ".", "_")
'sUrl = Replace(sUrl, "/", "_")

'�ۑ��t�@�C���p�X��ݒ�
sFilename = SAVEDIR+"\"+sTitle+"_"+sDate+".mht"

Set CDO = WScript.CreateObject("CDO.Message")
CDO.CreateMHTMLBody sUrl
CDO.GetStream.SaveToFile sFilename,adSaveCreateOverWrite
WScript.echo sUrl + " -> " + sFilename
