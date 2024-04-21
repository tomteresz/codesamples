@ECHO OFF
REM V0.1

for /f "tokens=3" %%x in ('reg query "HKLM\Software\Microsoft\Net Framework Setup\NDP\v4\Full\1033" /v Release') do set REGkey=%%x
SET FILESRV=\\fileserver.local\deploy\check-netframework-ver\lognetver.txt

Echo Computername : %COMPUTERNAME% : .NET Framework version : %REGkey% >> %FILESRV%
REM Echo\ >> %FILESRV%


timeout 1
REM If testing from the commandline, change the %%x to %x instead.