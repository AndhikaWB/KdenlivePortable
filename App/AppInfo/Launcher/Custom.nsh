${SegmentFile}

Var CmdPath
Var PythonDir

${SegmentPre}
	; Command prompt executable for creating junction
	ExpandEnvStrings "$CmdPath" "%COMSPEC%"

	; The launcher directory (can be used in KdenlivePortable.ini)
	${SetEnvironmentVariablesPath} "PAL:LauncherDir" "$EXEDIR"

	; The parent directory of the launcher directory
	${SetEnvironmentVariablesPath} "PAL:PortableAppsDir" "$PortableAppsDirectory"
	${SetEnvironmentVariablesPath} "PAL:CommonFilesDir" "$PortableAppsDirectory\CommonFiles"

	; Get Python directory from KdenlivePortable.ini
	${ReadLauncherConfig} "$PythonDir" "Misc" "PortablePythonDir"
	ExpandEnvStrings "$PythonDir" "$PythonDir"

	${If} ${FileExists} "$PythonDir\python.exe"
		; Prepend PATH (instead of append) to workaround app execution aliases
		${SetEnvironmentVariablesPath} "PATH" "$PythonDir;$PythonDir\scripts;$PathEnv"
	${EndIf}
!macroend

${SegmentPreExec}
	; Delete the junctions in case of unclean app exit
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$LOCALAPPDATA\Kdenlive\Venv""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\whisper""'

	; Create the junction for Python virtual environment
	; Must be outside the "kdenlive" directory to avoid getting copied
	CreateDirectory "$EXEDIR\Data\Venv"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$LOCALAPPDATA\Kdenlive\Venv" "$EXEDIR\Data\Venv""'

	; Create the junction for Whisper speech models
	CreateDirectory "$EXEDIR\Data\.cache\whisper"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$PROFILE\.cache\whisper" "$EXEDIR\Data\.cache\whisper""'
!macroend

${SegmentPost}
	; Delete the junctions again on app exit
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$LOCALAPPDATA\Kdenlive\Venv""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\whisper""'
!macroend
