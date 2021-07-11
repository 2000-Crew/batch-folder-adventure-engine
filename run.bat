@echo off
setlocal enabledelayedexpansion

rem // ensure the game-data folder is available
if not exist game-data (
	mkdir game-data
)

rem // ensure the game-data folder is available
if not exist game-data\starting-folder (
	mkdir game-data\starting-folder
)

rem // load default settings 
call :set-default-settings

rem // load game settings file
call :load-settings game-data\game-settings.ini

rem // remember what folder we're in for when we exit 
pushd .

cd game-data
pushd .

rem // set default colors  
cls
color 7

rem // output startup.txt  
if exist %startup-text-file% call :draw-file %startup-text-file%

rem // run startup.bat  
if exist %startup-script% call %startup-script%

rem // reset the game-over environment  
set game-over=false


rem //begin the game in the starting folder 
cd starting-folder

rem // draw the game
call :draw-current-folder

rem // begin the main game loop
goto :command-prompt


:command-prompt
@echo off

rem // prompt user for input 
SET /P user-input=!prompt-text!

rem // reject empty lines
if "!user-input!"=="" goto command-prompt

rem // respond to exit commands
for %%c in (%exit-commands%) do if "!user-input!"=="%%c" goto game-over

rem // look command redraws
if "!user-input!"=="look" call :draw-current-folder

rem // clear errorlevel and found-directory 
ver > nul
set found-directory=

rem // check if the user input matches a directory
rem // hack note: we cannot put a comment between these two lines
dir !user-input!* /ad-s-h /b >nul 2>&1 && set found-directory=1
if "%found-directory%"=="1" (

	rem // go to the folder of the number you typed 
	cd !user-input!*
	
	rem // draw a seperator
	echo.
	
	rem // begin again from the new folder 
	call :draw-current-folder

) else (
	
	call :try-action

)

rem // loop back to input prompt  
goto command-prompt

:try-action
@echo off

if exist %area-actions-file-name% (	
	
	rem // clear errorlevel  
	ver > nul
	
	rem // call actions.bat with answer set 
	rem // detect invalid commands 	
	rem // hack note: we cannot put a comment between these two lines
	call %area-actions-file-name% answer %user-input%
		
	if NOT ERRORLEVEL 1 (
	
		rem // command was successful, draw the current folder again
		echo .
		call :draw-current-folder

		rem // return immediately
		exit /b
		
	)
)

rem // nothing caught the command, it's invalid
call :invalid-command 
		
rem // return
exit /b

:draw-current-folder
@echo off



rem // draw readme.txt and run files 
if exist %area-description-file-name% call :draw-file %area-description-file-name%
if exist %area-script-file-name% call %area-script-file-name%
if exist %area-music-file-name% start %area-music-file-name%
if exist %area-html-file-name% start %area-html-file-name%

rem // draw blank line
echo.

rem // draw some standard text before the options are displayed
echo [%options-text-color%m!options-text! [0m

rem // change the color to the command color  
echo [%command-color%m

rem // draw folder list (common actions that change directory)
dir /AD-S-H /B

rem // draw extra actions from actions.bat 
if exist %area-actions-file-name% call %area-actions-file-name%

rem // draw special exit action 
echo %exit-command-description%

rem //return to normal formatting 
echo [0m

rem //return
exit /b

:load-settings
@echo off

rem // load a settings ini file
rem // %1 - file name

if exist %1 (
	rem // run set on every line in the file
	for /F "tokens=*" %%i in (%1) do (
		set %%i
	)
)

rem // return
exit /b

:draw-file
@echo off

rem // draw the content of a file with ANSI escape codes enabled
rem // %1 - file name

for /F tokens^=^* %%i in ('type %1 ^>con:') do (	
	rem //run echo on every line in the file
	echo [%adventure-color%m%%i[0m 
)

rem // return
exit /b

:invalid-command
@echo off

rem // draw the invalid command message
echo [%invalid-color%m%invalid-command-text%[0m

rem // return
exit /b

:set-default-settings
@echo off

rem // colour options
set adventure-color=37
set command-color=32
set invalid-color=31
set options-text-color=37

rem // prompts and text
set invalid-command-text=Invalid command
set options-text=Type one of the following...
set prompt-text=^>
set exit-command-description=q - quit the game

rem // exit commands
set exit-commands=quit q e exit end

rem // global files
set game-over-script=game-over.bat
set game-over-text-file=game-over.txt
set startup-script=startup.bat
set startup-text-file=startup.txt

rem // folder file names
set area-description-file-name=readme.txt
set area-actions-file-name=actions.bat
set area-music-file-name=music.mp3
set area-script-file-name=runme.bat
set area-html-file-name=index.html

rem // return
exit /b

:game-over
@echo off

rem // go back to the game folder  and remember where we were again  
popd
 
rem // draw a seperator
echo.

rem // show game-over.txt if it exists 
if exist %game-over-text-file% call :draw-file %game-over-text-file%

rem //execute clean up files  
if exist %game-over-script% call %game-over-script%

rem // finally go back to the original folder we were in  
popd

rem // return to command prompt  
exit /b