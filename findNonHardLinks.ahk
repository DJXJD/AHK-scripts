#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

if (A_Args.Length() > 0){
	SetWorkingDir, % A_Args[1]
}

RunWait, wsl ls -lRk > recursiveFileList.txt,, Hide

recursiveFileList := FileOpen("recursiveFileList.txt", "r")

recursiveFileList.Seek(0, Origin := 2)
endPos := recursiveFileList.Pos
recursiveFileList.Seek(0, Origin := 0)

folderLinesFound := 0
folderLinesEvaluated := 0
evaluatingLine := ""
potentialGoodLine := ""
totalSize := 0

while (recursiveFileList.Pos < endPos){
	evaluatingLine := recursiveFileList.ReadLine()
	if (InStr(evaluatingLine, "./") != 0){
		folderLinesFound ++
	}
}

recursiveFileList.Seek(0, Origin := 0)

while (folderLinesEvaluated < folderLinesFound){
	evaluatingLine := recursiveFileList.ReadLine()
	if (InStr(evaluatingLine, "./") != 0){
		potentialGoodLine := evaluatingLine
		evaluationPos := recursiveFileList.Pos
		evaluated := 0
		containsFolder := 0
		containsNonFolderWithoutHardlink := 0
		containsNonFolderWithHardlink := 0
		success := 1
		while (evaluated = 0){
			evaluatingLine := recursiveFileList.ReadLine()
			if (RegExMatch(evaluatingLine, "d[-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx] ([1-9]|\d\d\d*) ") != 0){
				containsFolder := 1
			} else if (RegExMatch(evaluatingLine, "[-sl][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx] 1 ") != 0){
				containsNonFolderWithoutHardlink := 1
			} else if (RegExMatch(evaluatingLine, "[-sl][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx][-rwx] ([2-9]|\d\d\d*) ") != 0){
				containsNonFolderWithHardlink := 1
			} else if (InStr(evaluatingLine, "./") != 0 || recursiveFileList.Pos >= endPos){
				if (containsFolder = 1){
					success := 0
				}
				if (containsNonFolderWithoutHardlink = 1){
					success := 1
				}
				if (containsNonFolderWithHardlink = 1){
					success := 0
				}
				if (success = 1){
					recursiveFileList.Pos := evaluationPos
					size := SubStr(recursiveFileList.ReadLine(), 7, -1) / 1024 ** 2
					totalSize += size
					
					FileAppend, % potentialGoodLine, recursiveNonHardlinkDirList.txt
					FileAppend, % "Size: " Round(size, 2) " GB`n`n", recursiveNonHardlinkDirList.txt
				}
				evaluated := 1
			}
		}
		folderLinesEvaluated ++
		recursiveFileList.Pos := evaluationPos
		if (folderLinesEvaluated = folderLinesFound){
			FileAppend, % "Total size: " Round(totalSize, 2) " GB", recursiveNonHardlinkDirList.txt
		}
	}
}