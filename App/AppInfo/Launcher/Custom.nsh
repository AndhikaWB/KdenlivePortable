Var CmdPath
Var PythonDir

!macro ForceCreateJunction link target
	; Will delete existing directory if the junction can't be created
	; Some directories are backed up on KdenlivePortable.ini first
	nsExec::Exec '"$CmdPath" /C "rmdir /S /Q "${link}""'
	CreateDirectory "${target}"
	nsExec::Exec '"$CmdPath" /C "mklink /J "${link}" "${target}""'
!macroend

!macro RemoveJunction link
	nsExec::Exec '"$CmdPath" /C "rmdir "${link}""'
!macroend

!define ForceCreateJunction "!insertmacro ForceCreateJunction"
!define RemoveJunction "!insertmacro RemoveJunction"

${SegmentFile}

${SegmentPrePrimary}
	; Command prompt executable for creating junction
	ExpandEnvStrings "$CmdPath" "%COMSPEC%"

	; The launcher executable directory
	${SetEnvironmentVariablesPath} "PAL:LauncherDir" "$EXEDIR"

	; The parent directory of the launcher directory
	${SetEnvironmentVariablesPath} "PAL:PortableAppsDir" "$PortableAppsDirectory"
	${SetEnvironmentVariablesPath} "PAL:CommonFilesDir" "$PortableAppsDirectory\CommonFiles"

	; Get Python directory from KdenlivePortable.ini
	${ReadLauncherConfig} "$PythonDir" "Misc" "PortablePythonDir"
	ExpandEnvStrings "$PythonDir" "$PythonDir"
	${If} ${FileExists} "$PythonDir\python.exe"
		${SetEnvironmentVariablesPath} "PATH" "$PythonDir;$PythonDir\scripts;$PathEnv"
	${EndIf}
!macroend

${SegmentPreExecPrimary}
	; Create junction for Python virtual environments and pip cache
	${ForceCreateJunction} "$LOCALAPPDATA\kdenlive\venv" "$EXEDIR\Data\Link\AppData\Local\kdenlive\venv"
	${ForceCreateJunction} "$LOCALAPPDATA\kdenlive\venv-sam" "$EXEDIR\Data\Link\AppData\Local\kdenlive\venv-sam"
	${ForceCreateJunction} "$PROFILE\.cache\pip-kdenlive-tmp-folder" "$EXEDIR\Data\Link\.cache\pip-kdenlive-tmp-folder"

	; Create junction for Kdenlive roaming models
	${ForceCreateJunction} "$APPDATA\kdenlive\opencvmodels" "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\opencvmodels"
	${ForceCreateJunction} "$APPDATA\kdenlive\speechmodels" "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\speechmodels"
	${ForceCreateJunction} "$APPDATA\kdenlive\sam2models" "$EXEDIR\Data\Link\AppData\Roaming\kdenlive\sam2models"

	; Create junction for Whisper speech models
	${ForceCreateJunction} "$PROFILE\.cache\whisper" "$EXEDIR\Data\Link\.cache\whisper"

	; Create junction for Hugging Face models
	${ForceCreateJunction} "$PROFILE\.cache\huggingface" "$EXEDIR\Data\Link\.cache\huggingface"
!macroend

${SegmentPostPrimary}
	; Safely delete the junction again
	${RemoveJunction} "$LOCALAPPDATA\kdenlive\venv"
	${RemoveJunction} "$LOCALAPPDATA\kdenlive\venv-sam"
	${RemoveJunction} "$PROFILE\.cache\pip-kdenlive-tmp-folder"

	${RemoveJunction} "$APPDATA\kdenlive\opencvmodels"
	${RemoveJunction} "$APPDATA\kdenlive\speechmodels"
	${RemoveJunction} "$APPDATA\kdenlive\sam2models"

	${RemoveJunction} "$PROFILE\.cache\whisper"
	${RemoveJunction} "$PROFILE\.cache\huggingface"
!macroend
