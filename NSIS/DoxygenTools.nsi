
;#####################################################################################
;
; Doxygen Tools Script written in NSIS
;
; This script installs programs used by Doxygen.
;	* Doxygen
;	* GraphViz
;	* MikTex
;	* Mscgen
;	* GhostScript
;
; Make sure that if you want to install new versions of the
; applications mentioned above, then you must make sure that
; the right names of the executable  files are used in the installation code below.
;#####################################################################################
!include "MUI.nsh"
!include "EnvVarUpdate.nsh"

;--------------------------------------
; General/Interface Settings
;--------------------------------
!define PRODUCT "DoxygenTools" 
!define MUI_BRANDINGTEXT "Copyright 2012"
!define MUI_ABORTWARNING
!define INSTALL_NAME "Doxygen tools"
CRCCheck On
XPSTYLE on 

  Name "Doxygen tools" ;Display name for installer
  OutFile "${PRODUCT}.exe"

  ;--------------------------------
  ; Define Installer Pages
  ;--------------------------------
  !define MUI_PAGE_WELCOME
  !define MUI_PAGE_DIRECTORY
  !define MUI_PAGE_STARTMENU $STARTMENU_FOLDER
  !define MUI_PAGE_INSTFILES
  !define MUI_PAGE_FINISH  

  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE
  !define MUI_DIRECTORYPAGE_VERIFYONLEAVE
  !define TEMP1 $R0

  !define MUI_STARTMENUPAGE_TEXT_TOP "${INSTALL_NAME}"
  !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${INSTALL_NAME}"
  
  ;--------------------------------
  ; Run Installer Pages
  ;--------------------------------
  Var STARTMENU_FOLDER
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_STARTMENU "${PRODUCT}" $STARTMENU_FOLDER
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH


  ;--------------------------------
  ; Define Uninstaller Pages
  ;--------------------------------
  !define MUI_UNPAGE_WELCOME
  !define MUI_UNPAGE_CONFIRM
  !define MUI_UNPAGE_DIRECTORY
  !define MUI_UNPAGE_INSTFILES
  !define MUI_UNPAGE_FINISH
  
  ;--------------------------------
  ; Run Uninstaller Pages
  ;--------------------------------
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_DIRECTORY
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

  ;--------------------------------
  ;Language
  ;--------------------------------
  !insertmacro MUI_LANGUAGE "English"
  ;--------------------------------
  
  ;Language Strings
  ;--------------------------------
  LangString DESC_SecCopyUI ${LANG_ENGLISH} "Installs the ${PRODUCT} Application"
  
  ;--------------------------------
  ;Folder-selection page
  ;--------------------------------
  InstallDir "$PROGRAMFILES\${PRODUCT}"


;-------------------------------------------
; onInit
;
; This function is the first to be executed when the installation program starts
;
;-------------------------------------------
Function .onInit

  Push "ThunderRT6Main"
  Push "${PRODUCT}"
  Call FindWindowClose

  ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" \
  "UninstallString"
  StrCmp $R0 "" done
 
  MessageBox MB_OKCANCEL|MB_ICONINFORMATION \
  "${PRODUCT} is already installed in this computer.$\n$\nClick 'OK' to proceed with the installation." \
  IDOK done
  Abort
  
done:
 
FunctionEnd


;-------------------------------------------
; FindWindowClose
;
; Use by passing the window class and title on the stack.
; You must pass both even if one is empty (i.e. "").
;
; Usage: 
;   Push ThunderRT6FormDC
;   Push "Visual Basic Form Name"
;   Call FindWindowClose
;
;-------------------------------------------
Function FindWindowClose
    Exch $0
    Exch
    Exch $1
    Push $2
    Push $3
    find:
        FindWindow $2 $1 $0
        IntCmp $2 0 nowindow
            MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "An instance of the program is running. Please close it and press OK to continue." \
	    IDOK find
	    Abort
    nowindow:
    Pop $3
    Pop $2
    Pop $1
    Pop $0
FunctionEnd


;--------------------------------
;Installer Sections
;--------------------------------
Section "${PRODUCT} main application" SecCopyUI

 ;Write the uninstall keys for Windows for Add/Remove programs.
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayName" "${PRODUCT} (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString" "$INSTDIR\uninstall.exe"
  
  SetOutPath "$INSTDIR"
  
  ;--------------------------------------
  ;Put file there that should be included under the installation directory
  ;--------------------------------------
  
  ;Doxygen.
  File "..\Installation\doxygen-1.8.1-setup.exe"
  ExecWait '"doxygen-1.8.1-setup.exe" /VERYSILENT'
  Sleep 1000
  Delete "$INSTDIR\doxygen-1.8.1-setup.exe"
  
  ;MikTex. Displays a progress window during installation.
  ;Can only delete the installation from Control Panel-Add/Remowe program.
  File "..\Installation\basic-miktex-2.9.4407.exe"
  ExecWait '"basic-miktex-2.9.4407.exe" --unattended'
  Sleep 1000  
  Delete "$INSTDIR\basic-miktex-2.9.4407.exe"
  
  ;Ghostscript
  File "..\Installation\gs905w32.exe"
  ExecWait '"gs905w32.exe" /S'
  Sleep 1000
  Delete "$INSTDIR\gs905w32.exe"
  
  ;Set environment variable.
  ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$PROGRAMFILES\gs\gs9.05\bin"
 
  ;Graphviz
  File "..\Installation\graphviz-2.28.0.msi"
  ExecWait '"msiexec" /i "graphviz-2.28.0.msi" /quiet' 
  Sleep 1000
  Delete "$INSTDIR\graphviz-2.28.0.msi"
  
  ;Mscgen.
  File "..\Installation\mscgen_0.20.exe"
  ExecWait '"mscgen_0.20.exe" /S'
  Sleep 1000
  Delete "$INSTDIR\mscgen_0.20.exe"

  ;Create menu shortcut for uninstall.
  !insertmacro MUI_STARTMENU_WRITE_BEGIN "${PRODUCT}"  	
	CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
  	CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
	
  	;Write shortcut location to the registry (for Uninstaller)
  	WriteRegStr HKCU "Software\${PRODUCT}" "Start Menu Folder" "${INSTALL_NAME}"
  !insertmacro MUI_STARTMENU_WRITE_END

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section
;--------------------------------
Section "Uninstall"

  ;Remove Doxygen.
  ExecWait '"$PROGRAMFILES\Doxygen\System\unins000.exe" /VERYSILENT'
  Sleep 1000
  RMDir "$PROGRAMFILES\Doxygen"
  
  ;Remove Ghostscript.
  ExecWait '"$PROGRAMFILES\gs\gs9.05\uninstgs.exe" /S'
  Sleep 1000  
  RMDir "$PROGRAMFILES\gs"
  
  ;Remove Ghostscript environment variable.
  ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "C:\Program Files\gs\gs9.05\bin"
  
  ;Can only remove MikTex from Control Panel with Add/Remove program.
  
  ;Remove Graphviz.
  File "..\Installation\graphviz-2.28.0.msi"
  ExecWait '"msiexec" /x "$INSTDIR\graphviz-2.28.0.msi" /quiet' 
  Sleep 1000  
  
  ;Remove Mscgen.
  ExecWait '"$PROGRAMFILES\mscgen\uninstall.exe" /S'
  Sleep 1000  
  RMDir "$PROGRAMFILES\mscgen"
    
  ;Get shortcut location of the uninstaller.
  ReadRegStr ${TEMP1} HKCU "Software\${PRODUCT}" "Start Menu Folder"
 
  ;Jump if no shortcut location.
  StrCmp ${TEMP1} "" noshortcuts
  
  ;Delete uninstaller.
  Delete "$SMPROGRAMS\${TEMP1}\Uninstall.lnk"  
  RMDir "$SMPROGRAMS\${TEMP1}" 
  
  noshortcuts:

  ;Delete installation directory.
  Delete "$INSTDIR\*"  
  RMDir "$INSTDIR"

  ;Remove registry keys for menu folder.
  DeleteRegValue HKCU "Software\${PRODUCT}" "Start Menu Folder"
  DeleteRegKey HKCU "SOFTWARE\${PRODUCT}"

  ; Remove registry keys for Add/Remove program.
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
  DeleteRegKey HKLM "SOFTWARE\${PRODUCT}"
SectionEnd
