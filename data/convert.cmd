@echo off
:loop
if "%1"=="" goto end
"%~dp0/omconvert.exe" "%~f1" -out "%~dpn1.wav"
shift
goto loop
:end
