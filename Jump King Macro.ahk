#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileAppend, SendMode Input`n`n, KeyLog.ahk

inputScanner := InputHook("V") 
inputScanner.KeyOpt("{Space}{Left}{Right}", "N")
inputScanner.OnKeyDown := Func("inputScannerKeyEvent").Bind(1)
inputScanner.OnKeyUp := Func("inputScannerKeyEvent").Bind(0)

global latestActionTime := ""

global spaceCanAct := 1
global leftCanAct := 1
global rightCanAct := 1

global numKeysDown := 0

inputScannerKeyEvent(state, inputHook, vk, sc){
	keyName := GetKeyName(Format("vk{:x}sc{:x}", vk, sc))
	
	if (state = 1 && %keyName%canAct = 1){
		if (latestActionTime != ""){
			FileAppend, % "Sleep " A_TickCount - latestActionTime "`n", KeyLog.ahk
		}
		latestActionTime := A_TickCount
		FileAppend, % "Send {" keyName " down}`n", KeyLog.ahk
		numKeysDown ++
		%keyName%canAct := 0
	}else if (state = 0){
		FileAppend, % "Sleep " A_TickCount - latestActionTime "`n", KeyLog.ahk
		latestActionTime := A_TickCount
		FileAppend, % "Send {" keyName " up}`n", KeyLog.ahk
		if (numKeysDown = 1){
			FileAppend, `n, KeyLog.ahk
		}
		numKeysDown --
		%keyName%canAct := 1
	}
}

!t::
RunWait, KeyLog.ahk
return

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
latestActionTime := A_TickCount
return

!w::
inputScanner.Stop()
latestActionTime := A_TickCount
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