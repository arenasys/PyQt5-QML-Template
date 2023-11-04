### PyQt5 QML Template
--------
Foundation for a standalone PyQt5 QML application thats distributed from a Git Repo for updates. Primarily handles the launch chain but also has other miscellaneous features required by most GUI programs.
![example](https://github.com/arenasys/PyQt5-QML-Template/raw/master/screenshot.png)

```
launcher.exe
- Downloads a standalone Python and PyQt5, creates a venv and installs PyQt5.
- Registers the application with the windows taskbar (So users can pin).
- Activates the venv and cleans up environmental variables.
- Hands off to main.py

launch.py (an alternative to the exe)
- Ensures a venv is active, building one and/or relaunching if nessesary.
- Installs PyQt5 if its missing.
- Activates the venv and cleans up environmental variables.
- Hands off to main.py

main.py
- Registers a global exception hook, logging errors to crash.log.
    - Fatal errors are handed back to launcher.exe which shows them to the user.
- Configures Qt window, registers with windows, computes scaling factor, etc.
- Starts the QML engine with just Splash.qml directly from disk.
- Compiles QML sources, icons, fonts, etc into qml_rc.py then loads it.
- Checks requirements.txt is satisfied, otherwise switches to Installer.qml.
- Finally the GUI object in gui.py is built and Main.qml is loaded.

gui.py
- Constructs the in-memory SQL database & in-memory thumbnail database.
- Ensures the git repo is active, otherwise creating it.
- Your program starts here.

See qDiffusion for reference.
```