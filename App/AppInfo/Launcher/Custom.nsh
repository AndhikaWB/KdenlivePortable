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
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$LOCALAPPDATA\kdenlive\venv""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$LOCALAPPDATA\kdenlive\venv-sam""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\pip-kdenlive-tmp-folder""'

	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$APPDATA\kdenlive\opencvmodels""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$APPDATA\kdenlive\speechmodels""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$APPDATA\kdenlive\sam2models""'

	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\whisper""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\huggingface""'

	; Create the junction for Python virtual environments and pip cache
	CreateDirectory "$EXEDIR\Data\Link\AppData\Local\kdenlive\venv"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$LOCALAPPDATA\kdenlive\venv" "$EXEDIR\Data\Link\AppData\Local\kdenlive\venv""'

	CreateDirectory "$EXEDIR\Data\Link\AppData\Local\kdenlive\venv-sam"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$LOCALAPPDATA\kdenlive\venv-sam" "$EXEDIR\Data\Link\AppData\Local\kdenlive\venv-sam""'

	CreateDirectory "$EXEDIR\Data\Link\.cache\pip-kdenlive-tmp-folder"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$PROFILE\.cache\pip-kdenlive-tmp-folder" "$EXEDIR\Data\Link\.cache\pip-kdenlive-tmp-folder""'

	; Create the junction for Kdenlive roaming models
	CreateDirectory "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\opencvmodels"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$APPDATA\kdenlive\opencvmodels" "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\opencvmodels""'

	CreateDirectory "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\speechmodels"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$APPDATA\kdenlive\speechmodels" "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\speechmodels""'

	CreateDirectory "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\sam2models"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$APPDATA\kdenlive\sam2models" "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\sam2models""'

	; Create the junction for Whisper speech models
	CreateDirectory "$EXEDIR\Data\Link\.cache\whisper"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$PROFILE\.cache\whisper" "$EXEDIR\Data\Link\.cache\whisper""'

	; Create the junction for Hugging Face models
	CreateDirectory "$EXEDIR\Data\Link\.cache\huggingface"
	nsExec::Exec '"$CmdPath" /C "mklink /J "$PROFILE\.cache\huggingface" "$EXEDIR\Data\Link\.cache\huggingface""'
!macroend

${SegmentPost}
	; Delete the junctions again on app exit
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$LOCALAPPDATA\kdenlive\venv""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$LOCALAPPDATA\kdenlive\venv-sam""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\pip-kdenlive-tmp-folder""'

	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$APPDATA\kdenlive\opencvmodels""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$APPDATA\kdenlive\speechmodels""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$APPDATA\kdenlive\sam2models""'

	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\whisper""'
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "$PROFILE\.cache\huggingface""'
!macroend
