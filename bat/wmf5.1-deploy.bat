@echo off
REM v0.2

SET FILESRV=fileserver.local
SET SHARE61="\\%FILESRV%\Deploy\bin\Win7AndW2K8R2-KB3191566-x64.msu"
SET SHARE63="\\%FILESRV%\Deploy\bin\Win8.1AndW2K12R2-KB3191564-x64.msu"
SET KBnr61=KB3191566
SET KBnr63=KB3191564

for /f "tokens=2* delims= " %%k in ('wmic qfe list brief ^| findstr "%KBnr61%"') do set KBstatus61=%%k
for /f "tokens=2* delims= " %%l in ('wmic qfe list brief ^| findstr "%KBnr63%"') do set KBstatus63=%%l
for /f "tokens=4-5 delims=. " %%i in ('ver') do set OSVER=%%i.%%j


IF "%OSVER%" == "6.1" (
    goto 6.1
) ELSE (
    IF "%OSVER%" == "6.3" (
	goto 6.3	
    ) ELSE (
    goto notfound
    )
)

:6.1
Echo\
echo Start Time: %TIME%
echo Detected OS: Windows 2008R2-SP1
echo ComputerName: %COMPUTERNAME%
REM Echo Check .NET Framework ver: 
REM wmic product get description | findstr /C:.NET
Echo\
IF "%KBstatus61%" == "%KBnr61%" (
  echo KB is already installed.
) ELSE (
  Echo Installing Software...
  wusa.exe %SHARE61% /quiet /forcerestart
)
echo Finish time: %TIME%
echo\
goto End

:6.3
Echo\
echo Start Time: %TIME%
echo Detected OS: Windows 2012R2
echo ComputerName: %COMPUTERNAME%
REM Echo Check .NET Framework ver: 
REM wmic product get description | findstr /C:.NET
Echo\
IF "%KBstatus63%" == "%KBnr63%" (
  echo KB is already installed.
) ELSE (
  Echo Installing Software...
  wusa.exe %SHARE63% /quiet /forcerestart
)
echo Finish time: %TIME%
echo\
goto End

:notfound
echo OS Not found
goto End
	
:End
