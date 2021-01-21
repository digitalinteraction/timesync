@ECHO OFF
:LOOP
IF "%1"=="" GOTO END
@ECHO ON
..\src\timesync\x64\Release\timesync.exe %1B.wav %1T.wav -out %1T.out.wav -bmp %1.bmp
@ECHO OFF
SHIFT
GOTO LOOP
:END


