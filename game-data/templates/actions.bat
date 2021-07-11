@echo off

rem //-- display custom options -- //
if "%1"=="" (

  echo o - custom action
  
  exit /b 0
)

rem //-- "o" command --//
if "%2"=="o" (
  
  echo You did a custom action
  exit /b 0
) 

rem //-- exit with error if invalid input is given --//
exit /b 1

