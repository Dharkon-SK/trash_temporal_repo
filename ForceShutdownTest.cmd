@echo off
goto xx

:ForceShutdown
   shutdown -f -p >nul 2>nul
   powercfg /hibernate off >nul 2>nul
   rundll32 powprof.dll, SetSuspendState >nul 2>nul
goto :eof

:xx
   call :ForceShutdown
exit