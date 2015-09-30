@echo off
echo This simple program will be able to retrieve the password 
echo of any wifi network you have connected to.
pause
IF EXIST .\config.txt GOTO ResetDir
:InpDir
cls
echo Please set a directory for your password files now.
echo (i.e. C:\Windows\InternetPasswords\)
echo If the directory does not exist, it will be created.
echo If left blank, the password directory will be put in the current
echo folder.
set /P "Directory="
mkdir %Directory%
IF EXIST %Directory% GOTO NewDir
echo You have either chosen to leave the directory blank or your
echo stated directory is not valid. Try again?
echo (Y/n)
set /P "retry="
IF %retry% == n GOTO DefaultDir
GOTO InpDir
:NewDir
cls
echo Your password directory has been created, and the settings have been
echo saved to this directory's config.txt. If you wish to change your
echo directory in the future, simply delete config.txt.
pause
:DirectWrite
echo %Directory% > config.txt
GOTO InpPoint
:DefaultDir
mkdir .\InternetPasswords\
echo .\InternetPasswords\ > config.txt
GOTO InpPoint
:ResetDir
for /f %%L in (config.txt) do set Directory=%%L
:InpPoint
cls
netsh wlan show profile
echo Please type the name of the access point you desire now.
set /P "Access="
netsh wlan show profile %Access% key=clear > tempkeycheck.txt
findstr /I "Key content:" tempkeycheck.txt > %Access%_pass.txt
del tempkeycheck.txt
pause
cls
echo A text file has been created named %Access%_pass.txt. It will be moved
echo to the Internet Passwords directory now.
echo This file will provide you with your password. It will also be
echo displayed here.
type %Access%_pass.txt
IF EXIST .\InternetPasswords\ GOTO DefaultWrite
move /-y "%Access%_pass.txt" "%Directory%"
pause
goto:eof 
:DefaultWrite
move /-y "%Access%_pass.txt" ".\InternetPasswords\" 
pause
