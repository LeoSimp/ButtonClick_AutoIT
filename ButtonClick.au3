#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Leo

 Script Function:
	Auto click windows GUI button

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#NoTrayIcon
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_icon=

$inifile = StringTrimRight(@ScriptName,4)&".ini"
$tittle = _INIread($inifile,"tittle")
$text = _INIread($inifile,"text")
$Auto_buttonID = _INIread($inifile,"Auto_buttonID")

$handle = WinGetHandle($tittle, $text)
If @error Then
   MsgBox(4096, "Error", "Could not find the correct window with tittle of "&$tittle&" and text of "&$text )
   exit(-1)
Else
   if $Auto_buttonID="1" Then
	  $delims = _INIread($inifile,"delims","Auto_buttonID")
	  $tokens = _INIread($inifile,"tokens","Auto_buttonID")
	  $keyword = _INIread($inifile,"keyword","Auto_buttonID")
	  $sClassList = WinGetClassList($handle)
	  $aClassList = StringSplit($sClassList,@CRLF,2)
	  For $i=0 To UBound($aClassList) -1
		 $aString = StringSplit($aClassList[$i],$delims)
		 if $aString[number($tokens)]=$keyword Then $buttonID = $aClassList[$i]&"1"
		 ;$buttonID = _INIread($inifile,"buttonID")
		 ;why we do not define the $buttonID in ini file, because for some of exe the buttonID is dynamic from PC to PC
		 ExitLoop
	  Next
   Else
	  $buttonID = _INIread($inifile,"buttonID")
   EndIf

   if not IsDeclared ("buttonID") Then
	  MsgBox(4096, "Error", "Not declare the buttonID")
	  exit(-1)
   EndIf

   WinActivate($tittle)
   $control = ControlGetHandle($handle,"",$buttonID)
   If @error Then
	  MsgBox(4096, "Error", "Could not find the correct buttonID of "&$buttonID )
	  exit(-1)
   Else
	  ControlClick($handle, "", $control)
	  exit(0)
   EndIf

EndIf

Func _INIread($x,$y,$z="SET") ;$x=file to read,$y=keyword,$z=section
Local $value
$value = IniRead($x,$z,$y,"Not Find")
If $value="Not Find" Then
	MsgBox(0,"Error","Pls check the "&$x&"'s "&$y&" whether is OK")
	exit(1)
EndIf
Return $value
EndFunc