# Kdenlive Portable

Kdenlive in PortableApps.com Format.

Always run the app via `KdenlivePortable.exe` to make it portable, not `kdenlive.exe` directly.

I may not actively update the portable installer, but you can simply replace the files on `App\Kdenlive` with a newer Kdenlive release to update it. Feel free to open an issue too, I will update the installer if you need it.

Windows blocking the portable installer? Right click the file, select "Properties", then "Unblock".

## Compatibility

|App|Supported|
|-|-|
|Kdenlive (non-portable)|No|
|Python|Yes|
|Glaxnimate|Partially|

See the details below.

### With Non-Portable Kdenlive

Copying the speech models and Python libraries will take a long time due to the big size. As a workaround, instead of copying files, Kdenlive Portable will create junctions (similar to symlink) for these directories:

|Link|Target|
|-|-|
|`$PROFILE\.cache\whisper`|`$EXEDIR\Data\.cache\whisper`|
|`%LOCALAPPDATA%\kdenlive\venv`|`$EXEDIR\Data\Venv`|

The logic behind this can be seen in the `Custom.nsh` file.

However, a junction can't be created if there is already a directory of the same name. Since I'm using `Custom.nsh` directly (instead of `KdenlivePortable.ini`), the directory backup mechanism is too much a hassle for me to implement manually.

To simplify things, the launcher will just delete the conflicting directories if they existed, hence you SHOULD NOT use it together with a non-portable version of Kdenlive (unless you're okay with redownloading the files).

### With Python

Portable Python can be detected by editing the `PortablePythonDir` in `App\AppInfo\Launcher\KdenlivePortable.ini`. By default, this will point to `%PAL:CommonFilesDir%\Python`, which can be translated as `$EXEDIR\..\CommonFiles\Python`. This directory must contain `python.exe` directly in order to be recognized. You can download Portable Python from [WinPython](https://winpython.github.io/) (preferably the dot variant).

Kdenlive will create a virtual environment when downloading the Python dependencies, this will be saved on `$EXEDIR\Data\Venv`. If the virtual environment suddenly can't be detected by Kdenlive (e.g. because you're running on a different PC), try changing the path in `$EXEDIR\Data\Venv\pyenv.cfg` file manually.

### With Glaxnimate

Kdenlive [recommends](https://docs.kdenlive.org/en/getting_started/configure_kdenlive/configuration_environment.html#default-apps) using Krita, Audacity, and Glaxnimate as the default editor apps for Kdenlive. Krita and Audacity portable are already officially supported by PortableApps.com, but not Glaxnimate.

Download Glaxnimate manually from the [official site](https://glaxnimate.mattbas.org/download/) (the zip version), and configure the path using the Kdenlive in-app settings directly. Alternatively, you can uncomment the last few lines in `App\AppInfo\Launcher\KdenlivePortable.ini` file (this assumes you placed Glaxnimate on `%PAL:CommonFilesDir%\Glaxnimate`).

You should only run Glaxnimate when Kdenlive Portable is running. If you do this correctly, Glaxnimate settings will also be moved to `$EXEDIR\Data\AppData\Roaming\Glaxnimate` when you close Kdenlive Portable.

## License

The launcher is licensed under the GPL-v2 license.
