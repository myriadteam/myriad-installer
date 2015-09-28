;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  
  !define VERSION "0.9.2.16"
  !define ARCH "64"
  
  ;Name and file
  Name "Myriad"
  OutFile "output\MyriadSetup-${VERSION}-win${ARCH}.exe"
  
  ;Default installation folder
  InstallDir "$PROGRAMFILES64\Myriad"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "Software\Myriad" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel highest
  
  ; Change icons to use Myriad's
  !define MUI_ICON "resources\myriad.ico"
  !define MUI_UNICON "resources\myriad.ico"
  
  ; use LZMA compression to shrink as small as possible
  SetCompressor /SOLID LZMA
  
  VIAddVersionKey "ProductName" "Myriad"
  VIAddVersionKey "FileVersion" "${VERSION}"
  VIAddVersionKey "FileDescription" "Myriad ${ARCH}-bit Installer"
  VIProductVersion "${VERSION}"
  VIFileVersion "${VERSION}"
  
;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages
  !define MUI_WELCOMEPAGE_TITLE "Myriad ${VERSION} ${ARCH}-bit Installer"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "resources\license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Graphical Interface" SecGUI

  SetOutPath "$INSTDIR"
  
  ;ADD YOUR OWN FILES HERE...
  
  File "resources\${VERSION}\${ARCH}-bit\myriadcoin-qt.exe"
  File "resources\myriad.ico"
  
  ; shortcuts
  SetShellVarContext all
  CreateShortcut "$SMPROGRAMS\Myriad.lnk" "$INSTDIR\myriadcoin-qt.exe"
  
  MessageBox MB_YESNO|MB_ICONQUESTION "Do you want to create a shortcut on the desktop?" IDYES true IDNO false
  true:
	CreateShortcut "$DESKTOP\Myriad.lnk" "$INSTDIR\myriadcoin-qt.exe"
  false:
  
  ;Store installation folder
  WriteRegStr HKCU "Software\Myriad" "" $INSTDIR

  Call Uninstaller
  
SectionEnd

Section "Daemon & Command Line" SecCMD

  SetOutPath "$INSTDIR"
  
  ;ADD YOUR OWN FILES HERE...
  
  File "resources\${VERSION}\${ARCH}-bit\myriadcoind.exe"
  File "resources\${VERSION}\${ARCH}-bit\myriadcoin-cli.exe"
  File "resources\myriad.ico"

  ;Store installation folder
  WriteRegStr HKCU "Software\Myriad" "" $INSTDIR
  
  Call Uninstaller
  
SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecGUI ${LANG_ENGLISH} "Graphical Wallet."
  LangString DESC_SecCMD ${LANG_ENGLISH} "Wallet daemon and command line tool."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecGUI} $(DESC_SecGUI)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecCMD} $(DESC_SecCMD)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

  Delete "$INSTDIR\myriadcoin-qt.exe"
  Delete "$INSTDIR\myriadcoind.exe"
  Delete "$INSTDIR\myriadcoin-cli.exe"
  SetShellVarContext all
  Delete "$SMPROGRAMS\Myriad.lnk"
  Delete "$DESKTOP\Myriad.lnk"
  
  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

  DeleteRegKey /ifempty HKCU "Software\Myriad"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad"
  
SectionEnd

Function Uninstaller

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  ;Add uninstaller to Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad" "DisplayName" "Myriad"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad" "DisplayIcon" "$INSTDIR\myriad.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad" "DisplayVersion" "${VERSION}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Myriad" "NoRepair" 1

FunctionEnd