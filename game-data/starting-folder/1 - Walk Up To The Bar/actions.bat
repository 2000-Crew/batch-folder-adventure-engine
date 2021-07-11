@echo off

rem //-- display options -- //
if "%1"=="" (
  echo b - Go back to the lobby.
  goto :EOF
)

rem //-- "b" command --//
if "%2"=="b" ( 
  cd ..  
  goto :EOF
) 

rem //-- exit with error if invalid input is given --//
exit /b 1

