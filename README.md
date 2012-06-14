DoxygenTools
============
This is a installer for Doxygen and the application it uses. Doxygen is a tool for writing software reference documentation.

Installs
--------

* Doxygen (basic tool for autogenerated documentation) 
* MiKTex (Latex format and input to PDF) 
* Graphviz (for autogenerated call graphs) 
* Ghostscript (for rendering PostScript documents)
* MSCgen (For message sequence charts, download extract and update PATH variable)

Requirements
------------

To create the installation file you need to install __NSIS__ available from (http://nsis.sourceforge.net/Main_Page).

Usage
-----

Go to the NSIS folder. Select the file _DoxygenTools.nsi_, right click and choose _Compile NSIS Script_. This will create the DoxygenTools installer. 

If you are using other versions of the Doxygen applications, make sure that you have the right name of the exe-files in 
_DoxygenTools.nsi_.

Installation
------------

You can install DoxygenTools in two ways.

1. Double click on the file DoxygenTools.exe and follow the instructions.
2. Start the DoxygenTools.exe from the command prompt. When doing this you can use option __/S__ for silent installation and 
   option __/D__ to change installation folder.

Example. _"DoxygenTools.exe /S /D=C:\Doxygen\Installation"_

There is a couple of things to consider. One is that even if MikTex has the option __--unattended__ to make a silent installation
it will still show a progress window. This is true even if we use the __/D__ option to install DoxygenTools silently.

Another thing is that MikTex can not be uninstalled through the DoxygenTools uninstaller. The only way to uninstall MikTex
is to remove it from Control Panel->Add/Remove program.

A third thing is that the installation folder is the folder where the uninstaller file for the DoxygenTools will be placed. The other applications in the
installer will be installed in the same default folders as if you should installe them manually.

