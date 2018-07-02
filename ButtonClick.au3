#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=ButtonClick.exe
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Add waitting the exe window max time-out to be 15S and change all the exit(-1) to exit(1)
#AutoIt3Wrapper_Res_Description=ButtonClick.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.4
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (C) 2018 USI
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Leo

 Script Function:
	Auto click windows GUI button

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

$inifile = StringTrimRight(@ScriptName,4)&".ini"
$tittle = _INIread($inifile,"tittle")
$text = _INIread($inifile,"text")
$Auto_buttonID = _INIread($inifile,"Auto_buttonID")


If $CmdLine[0] >= 1 Then
   local $p
   For $i=1 To $CmdLine[0] Step 1
	  $p = StringSplit($CmdLine[$i],":")
	  ;ConsoleWrite("p1:"&$p[1]&@CRLF)
	  Switch $p[1]
	  Case "tittle"
		 $tittle = $p[2]
		 ConsoleWrite("Get variable  $tittle value: "& $tittle&" from cmdline: "&$CmdLine[$i]&@CRLF)
	  Case "text"
		 $text = $p[2]
		 ConsoleWrite("Get variable $text value: "&$text&" from cmdline: "&$CmdLine[$i]&@CRLF)
	  Case Else
		cmdline_H()
		;MsgBox(0,"Error","Parameter Error!")
		exit(-1)
	  EndSwitch

   Next

EndIf

ConsoleWrite("Waitting for the window with tittle of "&$tittle&" and text of "&$text&"...")
Local $i = 0
Do
   sleep(500)
   $i = $i + 1
   If $i >= 30 Then ExitLoop
Until WinExists($tittle, $text)
If $i >= 30 Then
   ConsoleWrite("Failed"&@CRLF)
   MsgBox(4096, "Error", "Waitting for the window with tittle of "&$tittle&" and text of "&$text & " Time OUT !")
   exit(1)
EndIf
ConsoleWrite("Success(Cost:"&($i*500)&"ms)"&@CRLF)
$handle = WinGetHandle($tittle, $text)
If @error Then
   MsgBox(4096, "Error", "Could not get the handle of the window with tittle of "&$tittle&" and text of "&$text )
   exit(1)
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
	  exit(1)
   EndIf

   WinActivate($tittle)
   $control = ControlGetHandle($handle,"",$buttonID)
   If @error Then
	  MsgBox(4096, "Error", "Could not find the correct buttonID of "&$buttonID )
	  exit(1)
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

Func cmdline_H()
	ConsoleWrite("Parameter Error!"&@CRLF)
	ConsoleWrite("The support cmdline list as below: "&@CRLF)
	ConsoleWrite("tittle:[x] is a tittle string from the GUI your are tring to control"&@CRLF)
	ConsoleWrite("text:[x] x is a visable text from the GUI your are tring to control "&@CRLF)
EndFunc