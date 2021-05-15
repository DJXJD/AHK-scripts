#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

inputScanner := InputHook()
inputScanner.KeyOpt("{Space}{Left}{Right}", "N")
inputScanner.OnKeyDown := Func("inputScannerKeyEvent").Bind(1)
inputScanner.OnKeyUp := Func("inputScannerKeyEvent").Bind(0)

global spacePressTime := ""
global leftPressTime := ""
global rightPressTime := ""
global latestPressTime := ""

global spaceCanAct := 1
global leftCanAct := 1
global rightCanAct := 1

global numKeysDown := 0

inputScannerKeyEvent(state, inputHook, vk, sc){
	keyName := GetKeyName(Format("vk{:x}sc{:x}", vk, sc))
	
	if (state = 1 && %keyName%canAct = 1){
		if (latestPressTime != ""){
			FileAppend, % "Time since last press = " (A_TickCount - latestPressTime) / 1000 " seconds`n", KeyLog.txt
		}
		%keyName%PressTime := A_TickCount
		latestPressTime := A_TickCount
		FileAppend, % keyName " down`n", KeyLog.txt
		numKeysDown ++
		%keyName%canAct := 0
	}else if (state = 0){
		FileAppend, % keyName " up after " (A_TickCount - %keyName%PressTime) / 1000 " seconds`n", KeyLog.txt
		if (numKeysDown = 1){
			FileAppend, `n, KeyLog.txt
		}
		numKeysDown --
		%keyName%canAct := 1
	}
}

jump(str, dir := ""){
	send {Space Down}
	switch dir{
		case "L":
			send {Left Down}
		case "R":
			send {Right Down}
	}
	sleep str * 10 ; str is reflected as a percentage. full jump is 1 second of holding space
	send {Space Up}
	switch dir{
		case "L":
			send {Left Up}
		case "R":
			send {Right Up}
	}
}

walk(dur, dir){
	switch dir{
		case "L":
			send {Left Down}
		case "R":
			send {Right Down}
	}
	sleep dur * 1000
	switch dir{
		case "L":
			send {Left Up}
		case "R":
			send {Right Up}
	}
}

wait(dur){
	sleep dur * 1000
}

!Space::
ToolTip, %A_TickCount%
while GetKeyState("{Space}")
	sleep 1
return

!q::
inputScanner.Start()
return

!w::
inputScanner.Stop()
return

!d::
walk(1.2, "L")
jump(100, "L")
wait(1)
jump(100, "R")
wait(1)
walk(.2, "L")
jump(100, "R")
wait(1)
walk(.4, "R")
jump(100, "R")
wait(1)
walk(.7, "L")
jump(100, "L")
wait(1)
jump(100, "R")
wait(1)
walk(.25, "R")
jump(15, "R")
wait(1)
walk(.4, "R")
jump(35, "R")
wait(1)
walk(.3, "L")
jump(35, "L")
wait(1)
walk(.2, "L")
jump(40, "L")
return

!f::
jump(10)
return

!g::
jump(15)
return

!h::
jump(20)
return

!j::
jump(25)
return

!z::
send ^s
Reload
return

!x::
ExitApp
return