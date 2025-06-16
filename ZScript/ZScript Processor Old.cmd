@echo off
setlocal enabledelayedexpansion
title %cd%
if exist "%~dp0\ADZP 20 Complex.sys" (
rundll32 "%~dp0\ADZP 20 Complex.sys"
set ValidateZScript=true
) else (
set ValidateZScript=false
)

for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
set zscript[system{esc}]=%%b
)

set ShutdownPrivilege=false

whoami /groups | find "S-1-16-12288" >nul
if not errorlevel 1 (
set ScriptPrivilege=Elevated
) else (
set ScriptPrivilege=Basic
)

if exist "%~1" (call :ProcessFile "%~1")

color 0f
:Starting
echo Procesador de lenguaje ZScript [Version 3.75]
echo Aplicacion creada por Dharkon SK.
:Start
title %~f0
echo.
set /p input="[COMANDO] >>> "
call :Process %input%
goto Start

:ProcessFile
set ValidateZScript=false
set ZSC_FILE_PATH=%~f1
set ZSC_FILE_NAME=%~nx1
set ZSC_WORK_RUTE=%~dp1
title !ZSC_FILE_PATH!
for /f "usebackq delims=" %%a in ("!ZSC_FILE_PATH!") do (call :Process %%a)
exit

:ProcessFileH
set ValidateZScript=false
for /f "usebackq delims=" %%a in ("%~1") do (call :Process %%a)
goto :eof

:Process
if /i "%~1" == "@Config.Lib" (
if /i "%~2" == "-include" (
if /i "%~3" == "ADZP 20 Complex.sys" (
set ValidateZScript=true
if exist "%~dp0\ADZP 20 Complex.sys" (RunDll32 "%~dp0\ADZP 20 Complex.sys") else (exit)
)
if exist "%~3" (
call :ProcessFileH "%~3"
goto :eof
)
)
)
if /i "%ValidateZScript%" == "false" (exit)
if /i "%~1" == "$ZScript.ShellExecute" (
call :RunApp "%~2" "%~3"
goto :eof
)
if /i "%~1" == "$ZScript.SleepTime" (
timeout /nobreak %~2 >nul
goto :eof
)
if /i "%~1" == "$ZScript.ConsoleSubProcess" (
if /i "%~3" == "" (
call :ImportSubProcess "%~2"
goto :eof
)
if /i "%~3" == "{NULL}" (
call :ImportSubProcess "%~2" >NUL 2>NUL
goto :eof
)
if /i "%~4" == "{NULL}" (
call :ImportSubProcess "%~2" "%~3" >NUL 2>NUL
goto :eof
)
call :ImportSubProcess "%~2" "%~3"
goto :eof
)
if /i "%~1" == "$ZScript.WriteLine" (
if /i "%~2" == "" (echo.&goto :eof)
if /i "%~3" == "" (echo %~2&goto :eof)
if /i "%~3" == "-HexColor" (if /i "%~4" == "" (echo %~2) else (echo %zscript[system{esc}]%[%~4m%~2%zscript[system{esc}]%[%~5m))
goto :eof
)
if /i "%~1" == "$ZScript.MsgBox" (
call :ShowMsgBox %~2 "%~3" "%~4" %~5
goto :eof
)
if /i "%~1" == "$ZScript.DeleteFile" (
del /f /q "%~2" >nul 2>nul
goto :eof
)
if /i "%~1" == "#Plc.AdminProcess" (
if /i "%~2" == "[KILL_PROCESS]" (
taskkill %~3 "%~4" /f >nul 2>nul
goto :eof
)
)
if /i "%~1" == "@Config.Window" (
if /i "%~2" == "ChangeColor" (color %~3)
if /i "%~2" == "HideConsole" (call "%~dp0\HideConsoleWindow.exe")
if /i "%~2" == "ShowConsole" (call "%~dp0\ShowConsoleWindow.exe")
if /i "%~2" == "AdjustConsole" (mode con: cols=%~3 lines=%~4)
if /i "%~2" == "DefineTitle" (title %~3)
if /i "%~2" == "ClearConsole" (cls)
goto :eof
)
if /i "%~1" == "$ZScript.EncodeFile" (
if /i "%~2" == "-base64" (set encode_type=-encode)
if /i "%~2" == "-hex" (set encode_type=-encodehex)
if /i "%~2" == "-decode64" (set encode_type=-decode)
if /i "%~2" == "-decodehex" (set encode_type=-decodehex)
call :EncodeFile "%~3" "%~4"
goto :eof
)
if /i "%~1" == "$ZScript.PlaySoundFile" (
if /i "%~2" == "/AudioType" (
if /i "%~3" == "Static[FILE_NAME]" (
if not exist "%~4" (goto :eof)
if /i "%~5" == "{StopDuringMedia}" (
PowerShell -Command "(New-Object Media.SoundPlayer '%~4').PlaySync()" >nul 2>nul
goto :eof
)
)
)
)
if /i "%~1" == "#Zwh.DefineVariable" (
if /i "%~2" == "/Input" (
set /p %~3="%~4"
goto :eof
)
if /i "%~2" == "/FileSelectionBox" (
call :FileSelectBox %~3
goto :eof
)
if /i "%~2" == "/AritmeticsFunctions" (
set /a %~3=%~4
goto :eof
)
set %~2=%~3
goto :eof
)
if /i "%~1" == "#Zwh.FindDirectory" (
cd /d "%~2" >nul 2>nul
goto :eof
)
if /i "%~1" == "$ZScript.RegEdit" (
if /i "%~2" == "-add" (reg add "%~3" /v "%~4" /t %~5 /d "%~6" /f >NUL 2>NUL)
if /i "%~2" == "-delete" (reg delete "%~3" /v "%~4" /f >NUL 2>NUL)
goto :eof
)
if /i "%~1" == "#For" (
call :ForCommand "%~2" "%~3" "%~4" "%~5" "%~6" "%~7"
goto :eof
)
if /i "%~1" == "$ZScript.NetworkProcessing" (
if /i "%~2" == "Download-File" (certutil -urlcache -split -f "%~3" "%~4" >NUL 2>NUL)
if /i "%~2" == "Execute-Ping" (ping %~3 -t -l %~4 >NUL 2>NUL)
goto :eof
)
if /i "%~1" == "$ZScript.CreateFile" (
call :CreateFileCommand "%~1" "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8"
goto :eof
)
if /i "%~1" == "$ZScript.CreateDirectory" (
md "%~2" >NUL 2>NUL
goto :eof
)
if /i "%~1" == "$ZScript.NtRaiseHardError" (
if /i "%~2" == "-StopCode" (
if /i "%~4" == "0" (goto :eof)
if /i "%~4" == "1" (call :NtRaiseHardError %~3)
)
goto :eof
)
if /i "%~1" == "$ZScript.WriteFile" (
if /i "%~2" == "" (goto Error1)
if /i "%~2" == "-Array" (
for /f "delims=:" %%e in ('findstr /n /c:"%~3.OpenFile@{" "%ZSC_FILE_PATH%"') do (
if /i "%~5" == "#NW" (
call :WriteArray "%%e" "%~3" "%~4"
goto :eof
)
if /i "%~5" == "#OV" (
call :OverWriteArray "%%e" "%~3" "%~4"
goto :eof
)
)
)
if /i "%~4" == "#NW" (
echo %~3>>"%~2"
goto :eof
)
if /i "%~4" == "#OV" (
del /f /q "%~2" >NUL 2>NUL
echo %~3>>"%~2"
goto :eof
)
)
if /i "%~1" == "#If" (
call :IfConditional "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8"
goto :eof
)
if /i "%~1" == "$ZScript.Pause" (
pause >nul
goto :eof
)
if /i "%~1" == "$ZScript.RunDll" (
if /i "%~2" == "/Invoke" (
if not exist "%~3" (goto :eof)
if /i "%~4" == "$WINAPI" (
if /i "%~6" == "{NULL}" (
rundll32 "%~3", %~5
goto :eof
)
set zsc[dll_params]=%~6
set zsc[dll_params]=!zsc[dll_params]:'="!
rundll32 "%~3", %~5 !zsc[dll_params]!
goto :eof
) else (goto :eof)
)
rundll32 %~2
goto :eof
)
if /i "%~1" == "$ZScript.ElevPrivilege" (
if /i "%~2" == "ADMINISTRATOR_PRIVILEGE_LEVEL" (
if /i "%~3" == "0" (goto :eof)
if /i "%~3" == "1" (
whoami /groups | find "S-1-16-12288" >nul
if not errorlevel 1 (goto :eof) else (
PowerShell -Command "Start-Process 'cmd.exe' -ArgumentList '/c', '%ZSC_FILE_PATH%' -Verb runAs" >NUL
goto :eof
)
)
)
if /i "%~2" == "SE_SHUTDOWN_PRIVILEGE_LEVEL" (
if /i "%~3" == "0" (goto :eof)
if /i "%~3" == "1" (
set ShutdownPrivilege=true
goto :eof
)
)
)
if /i "%~1" == "$ZScript.ReturnBucle" (
for /f "delims=:" %%e in ('findstr /n /c:"(%~2)" "%ZSC_FILE_PATH%"') do (
call :RepeatSequence %%e
)
goto :eof
)
if /i "%~1" == "#Plc.CallFunction" (
for /f "tokens=3,4,5,6,7" %%a in ('findstr /n /c:"void -%~2-" "%ZSC_FILE_PATH%"') do (
if /i not "%%a" == "" (set %%a=%~3)
if /i not "%%b" == "" (set %%b=%~4)
if /i not "%%c" == "" (set %%c=%~5)
if /i not "%%d" == "" (set %%d=%~6)
if /i not "%%e" == "" (set %%e=%~7)
if /i not "%%f" == "" (set %%f=%~8)
if /i not "%%g" == "" (set %%g=%~9)
)
for /f "delims=:" %%e in ('findstr /n /c:"void -%~2-" "%ZSC_FILE_PATH%"') do (
call :RepeatSequenceA %%e
)
goto :eof
)
if /i "%~1" == "#Plc.ShutdownWindows" (
if /i "%ShutdownPrivilege%" == "false" (goto :eof)
for /f "tokens=2 delims=[]" %%a in ('echo %~2') do (
if /i "%~3" == "-time" (
if /i "%~5" == "#comment" (shutdown -%%a -t %~4 -c "%~6" >NUL 2>NUL)
shutdown -%%a -t %~4 >NUL 2>NUL
)
shutdown -%%a >NUL 2>NUL
)
goto :eof
)
if /i "%~1" == "#Zwh.GetSystemData" (
call :SysGet %~2 %~3 >NUL 2>NUL
goto :eof
)
if /i "%~1" == "#Zwh.CopyFile" (
if /i "%~2" == "-c" (type "%~3" >> "%~4")
if /i "%~2" == "-b" (copy /b "%~3" "%~4" >nul 2>nul)
goto :eof
)
if /i "%~1" == "$ZScript.End" (
exit
)
goto :eof

@rem ----------------------------------------------------------------------------------------------------------------------------------------------------------------

:SysGet
if /i "%~1" == "AVAILABLE-PHYSICAL-RAM-MEMORY" (for /f "tokens=2 delims==" %%a in ('wmic os get freephysicalmemory /value') do (set %~2=%%a) & goto :eof)
if /i "%~1" == "HORIZONTAL-SCREEN-RESOLUTION" (for /f "tokens=2 delims==" %%a in ('wmic path Win32_VideoController get CurrentHorizontalResolution /value') do (set %~2=%%a) & goto :eof)
if /i "%~1" == "VERTICAL-SCREEN-RESOLUTION" (for /f "tokens=2 delims==" %%a in ('wmic path Win32_VideoController get CurrentVerticalResolution /value') do (set %~2=%%a) & goto :eof)
if /i "%~1" == "CPU-INTERNAL-LABEL" (for /f "tokens=2 delims==" %%a in ('wmic path Win32_Processor get Name /value') do (set %~2=%%a) & goto :eof)
if /i "%~1" == "CPU-THERMAL-ZONE-TEMPERATURE" (
whoami /groups | find "S-1-16-12288" >nul
if errorlevel 1 (goto :eof)
for /f "tokens=2 delims==" %%a in ('wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature /value') do (set /a %~2=%%a / 10 - 273)
if /i "!%~2!" == "" (set %~2=Incompatible)
goto :eof
)
goto :eof

:RunApp
set AppName=%~1
set Params=%~2
set Params=!Params:'="!
if exist "!AppName!" (
if /i "!Params!" == "" (start "" "!AppName!") else (start "" "!AppName!" !Params!)
)
endlocal
goto :eof

:ForCommand
for /f "delims=:" %%e in ('findstr /n /c:"ScriptingBucle.(%~2)" "%ZSC_FILE_PATH%"') do (
set "zsc[line]=%%e"
)
if /i "%~3" == "/f" (
for /f %%a in (%~1) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
if /i "%~3" == "/l" (
for /l %%a in (%~1) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
if /i "%~3" == "/r" (
for /r "%~1" %%a in (%~5) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
if /i "%~3" == "/d" (
for /d %%a in (%~1) do (
set %~4=%%a
call :RepeatSequenceB !zsc[line]!
)
)
goto :eof

:CreateFileCommand
if /i "%~2" == "[CREATE_NEW]" (
if not exist "%~1" (
echo off>"%~1"
)
)
if /i "%~2" == "[MODIFY_ATTRIBUTES]" (
if not exist "%~1" (
attrib %~3 %~4 %~5 %~6 %~7 "%~1" >nul 2>nul
)
)
if /i "%~2" == "[RENAME_FILE]" (
ren "%~1" "%~3" >NUL 2>NUL
)
)
if /i "%~2" == "[ZERO_BYTES]" (
if exist "%~1" (
echo off>"%~1"
)
)
goto :eof

:ShowMsgBox
for /f "tokens=*" %%i in ('PowerShell -Command "Add-Type -AssemblyName 'System.Windows.Forms'; [System.Windows.Forms.MessageBox]::Show('%~2', '%~3', [System.Windows.Forms.MessageBoxButtons]::%~4, [System.Windows.Forms.MessageBoxIcon]::%~1)"') do (set MsgBoxResult=Zsc%%i)
goto :eof

:EncodeFile
if not exist "%~1" (goto :eof)
certutil %encode_type% "%~1" "%~2" >nul 2>nul
goto :eof

:RepeatSequence
for /f "usebackq skip=%~1 delims=" %%i in ("%ZSC_FILE_PATH%") do (
call :Process %%i
)
goto :eof

:RepeatSequenceA
for /f "usebackq skip=%~1 delims=" %%i in ("%ZSC_FILE_PATH%") do (
if /i "%%i" == "@System.EndSub" (goto :eof)
call :Process %%i
)
goto :eof

:RepeatSequenceB
for /f "usebackq skip=%~1 delims=" %%i in ("%ZSC_FILE_PATH%") do (
if /i "%%i" == "@System.EndBuc" (goto :eof)
call :Process %%i
)
goto :eof

:ImportSubProcess
set ExecutableFileName=%~1
set Params=%~2
if "!Params!" == "" rem else (set Params=!Params:'="!)
if exist "!ExecutableFileName!" (
if /i "!Params!" == "" (call "!ExecutableFileName!") else (call "!ExecutableFileName!" !Params!)
) else (goto :eof)
endlocal
goto :eof

:WriteArray
for /f "skip=%~1 delims=" %%i in (%ZSC_FILE_PATH%) do (
if /i "%%i" == "}@%~2.CloseFile" (goto :eof)
if /i "%%i" == "" (echo. >>"%~3") else (echo %%i>>"%~3")
)
goto :eof

:OverWriteArray
echo off>"%~3"
for /f "skip=%~1 delims=" %%i in (%ZSC_FILE_PATH%) do (
if /i "%%i" == "}@%~2.CloseFile" (goto :eof)
if /i "%%i" == "" (echo. >>"%~3") else (echo %%i>>"%~3")
)
goto :eof

:IfConditional
if /i "%~1" == "File.Exists" (
if exist "%~2" (
if /i "%~3" == "then" (
for /f "delims=" %%a in ("%~4") do (
set line=%%a
set line=!line:'="!
call :Process !line!
goto :eof
)
)
) else (goto :eof)
goto :eof
)
if /i "%~1" == "File.NoExists" (
if not exist "%~2" (
if /i "%~3" == "then" (
for /f "delims=" %%a in ("%~4") do (
set line=%%a
set line=!line:'="!
call :Process !line!
goto :eof
)
)
) else (goto :eof)
goto :eof
)
if /i "%~1" == "/s" (
if /i "%~2" %~3 "%~4" (
if /i "%~5" == "then" (
for /f "delims=" %%a in ("%~6") do (
set line=%%a
set line=!line:'="!
call :Process !line!
goto :eof
)
) else (goto :eof)
)
goto :eof
)
if /i "%~1" == "/n" (
if %~2 %~3 %~4 (
if /i "%~5" == "then" (
for /f "delims=" %%a in ("%~6") do (
set line=%%a
set line=!line:'="!
call :Process !line!
goto :eof
)
) else (goto :eof)
)
goto :eof
)
goto :eof

:NtRaiseHardError
if /i "%ShutdownPrivilege%" == "false" (goto :eof)
PowerShell -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class BSOD { [DllImport(\"ntdll.dll\")] public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue); [DllImport(\"ntdll.dll\")] public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response); public static void TriggerBSOD() { bool tmp1; uint tmp2; RtlAdjustPrivilege(19, true, false, out tmp1); NtRaiseHardError(%~1, 0, 0, IntPtr.Zero, 6, out tmp2); } }' ; [BSOD]::TriggerBSOD()"
goto :eof

:FileSelectBox
for /f "tokens=*" %%a in ('PowerShell -Command "Add-Type -AssemblyName 'System.Windows.Forms'; $dialog=New-Object Windows.Forms.OpenFileDialog; $dialog.ShowDialog() | Out-Null; $dialog.FileName"') do (set %~1=%%a)
goto :eof