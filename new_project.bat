@echo off
color F0
title "New project"

:: ---------------------------------------------------- V A R

:: ------------------[ EDITABLE ]-------------------------------------------

:: write the default path of parents folder of your projects
set defaultPath="C:\xampp\htdocs"

:: Set TRUE if you want that the program open a cmd in your folder project
:: Set FALSE if you want that the program close at end
set keepOpen="TRUE"

:: -------------------------------------------------------------------------

:: Defines Date
::for /f "tokens=1,2,3 delims=/ " %%a in ('date /t') do set maDate=%%a-%%b-%%c
for /f "delims=/ tokens=1,2,3" %%a in ('date /t') do set day=%%a
for /f "delims=/ tokens=1,2,3" %%a in ('date /t') do set month=%%b
for /f "delims=/ tokens=1,2,3" %%a in ('date /t') do set year=%%c
set year=%year:~0,4%

:: define hours 
for /f "tokens=1,2,3 delims=:" %%a in ('time /t') do set heure=%%a
if "%heure:~0,1%" == " " set heure=0%heure:~0,1%

:: define minutes
set minute=%time:~3,2%

:: define secondes
set seconde=%time:~6,2%

:: define secondes
set miliseconde=%time:~9,2%

:: If you don't give a project name, it will be this by default
set DefaultProjetcName=Project_%day%%month%%year%_%heure%%minute%%seconde%%miliseconde%

:: Just a space for display
set space=  

:: Equal 1 if the folder already exist
set alreadyExistFolder=0

:: ---------------------------------------------------- P R O G R A M

echo %space%Press any key to start
pause >nul
cd %defaultPath%
cls

:: Restart here if your project name already exist

:NameFolder
IF %alreadyExistFolder% == 1 (
    cls
    color c
    echo.
    echo %space%%space%%space%%space%--- The project name you put is already used ---
)

:: --- Show default path and existing project

echo.
echo %space%Default project path : %cd%
echo.
echo %space%Your existing projects (in your default path) :
echo.
dir /B
echo.
echo ------------------------------------------
echo.

:: --- Ask some informations
set /p "DOSSIER=%space%Change the path of parent folder : "
set /p "NAME=%space%Name your project (else, default name) : "

:: --- Test
set alreadyExistFolder=0

IF "%DOSSIER%" == "" (set DOSSIER=%defaultPath%)
IF "%NAME%" == "" (set NAME=%DefaultProjetcName%)
IF EXIST "%DOSSIER%" ( 
    set alreadyExistFolder=1
    goto :NameFolder
)

color F0
cls
echo.

::----------------------------------
echo %space%Redirection to %DOSSIER%
cd "%DOSSIER%"

::---------------------------------
echo %space%Creation of the folder "%NAME%"
mkdir "%NAME%"

::-------------------------------
echo %space%Redirection to "%NAME%"
cd "%NAME%"


::------[ Create folder ]---------------------------------------------
echo.
echo --- FOLDERS ---
echo.

call :newFolder elements
call :newFolder styles
call :newFolder script
call :newFolder images

::------[ create files ]---------------------------------------------
echo.
echo --- FILES ---
echo.

call :newFile index.php
call :newFile robots.txt
call :newFile sitemap.xml
call :newFile styles/style.css
call :newFile script/script.js
call :newFile elements/header.php
call :newFile elements/footer.php

echo # Do not remove this line, otherwise mod_rewrite rules will stop working >> .htacces
echo RewriteBase / >> .htacces
echo %space%[Files Created] : .htacces

::-------------------------

IF %keepOpen% == "TRUE" (
    echo.
    echo Press any key to go to cmd
    pause>nul   
    color 07
    cls
    cmd.exe
) else (
    echo.
    echo Press any key to quit
    pause>nul
    exit
)


:: ---------------------------------------------------- F O N C T I O N

:: content fileName.extension
:newFile <arg1>
echo. >> %1
echo %space%[Files Created] : %1
goto :eof

:: folderName
:newFolder <arg1>
mkdir %1
echo %space%[Folder Created] : %1
goto :eof