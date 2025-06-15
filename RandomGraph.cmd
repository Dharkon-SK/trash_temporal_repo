@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title %~f0

for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
   set ESC=%%b
)
goto WinMain

:G.ShowGraphs

for /f "tokens=* delims=," %%a in ('echo %~1') do (
   set graph.element_content=%%a
   for %%b in (!graph.element_content!) do (
      set /a graph.elements_count+=1
      set graph.element[!graph.elements_count!]=%%b
   )
)

if /i "%~2" == "clear-console" (cls)

if /i "%~3" == "auto-max" (
   set max=%graph.element[!graph.elements_count!]%
   for /l %%a in (%graph.elements_count%,-1,1) do (
      if !max! lss !graph.element[%%a]! (set max=!graph.element[%%a]!)
   )
   set /a max+=3
)

if /i "%~3" == "define-max" (set max=%~4)

for /l %%a in (%max%,-1,1) do (
   echo %ESC%[97m%ESC%[%%a;3H%%a%ESC%[%%a;5H  ^|
)

set graph.space=5
for /l %%a in (1,1,%graph.elements_count%) do (
   set /a graph.space+=6
   set graph.space[%%a]=!graph.space!
   echo %ESC%[94m%ESC%[!graph.element[%%a]!;!graph.space!H███
)

for /l %%a in (%max%,-1,1) do (
   for /l %%b in (1,1,%graph.elements_count%) do (
   if %%a lss !graph.element[%%b]! (echo %ESC%[94m%ESC%[%%a;!graph.space[%%b]!H███)
   )
)

for /l %%a in (1,1,%graph.elements_count%) do (
   set graph.element[%%a]=
)
set graph.element_content=
set graph.elements_count=

echo %ESC%[0m%ESC%[!max!f
goto :eof

:WinMain
for /l %%a in (1,1,15) do (
set /a rnd[%%a]=!random! %% 15
)
call :G.ShowGraphs "!rnd[1]!,!rnd[2]!,!rnd[3]!,!rnd[4]!,!rnd[5]!,!rnd[6]!,!rnd[7]!,!rnd[8]!,!rnd[9]!,!rnd[10]!,!rnd[11]!,!rnd[12]!,!rnd[13]!,!rnd[14]!,!rnd[15]!" clear-console define-max 25
goto WinMain