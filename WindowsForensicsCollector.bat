@echo off
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +                          CC BY-SA 4.0 - D4rk5t0rM                               +
echo +                          https://github.com/D4rk5t0rM                           +
echo +                 https://creativecommons.org/licenses/by-sa/4.0/                 +
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo + This tool was made for copying all forensics relevant data from a windows disk. +
echo + This tool WILL NOT copy any data in memory, only data from Disk.                +
echo + This only copies those files to a folder on your desktop.                       +
echo + You'll need to use other tools to actually extract data from these files.       +
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +                                   How to use:                                   +
echo + When asked for a disk: Just type ONLY the drive letter of the disk to analyse   +
echo + Run this script as ADMINISTRATOR, if not some files can't be copied             +
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo.
set "disk=c"
set /P disk="What is your suspect's disk? (eg. c): "
set disk=%disk%:
cls

echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +                          CC BY-SA 4.0 - D4rk5t0rM                               +
echo +                          https://github.com/D4rk5t0rM                           +
echo +                 https://creativecommons.org/licenses/by-sa/4.0/                 +
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo Suspect's disk: %disk%
echo.
echo.

echo Copying hive files...
mkdir C:\Users\%USERNAME%\Desktop\RegFiles
copy %disk%\Boot\BCD C:\Users\%USERNAME%\Desktop\RegFiles\BCD
copy %disk%\Windows\System32\Config\SAM C:\Users\%USERNAME%\Desktop\RegFiles\SAM
copy %disk%\Windows\System32\Config\SECURITY C:\Users\%USERNAME%\Desktop\RegFiles\SECURITY
copy %disk%\Windows\System32\Config\Software C:\Users\%USERNAME%\Desktop\RegFiles\Software
copy %disk%\Windows\System32\Config\System C:\Users\%USERNAME%\Desktop\RegFiles\System
copy %disk%\Windows\System32\Config\Default C:\Users\%USERNAME%\Desktop\RegFiles\Default

for /D %%u in (%disk%\Users\*) do mkdir C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_NTUSER\ & echo F | xcopy /h %disk%\Users\%%~nu\ntuser* C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_NTUSER\


echo Done!
echo.
echo Copying shellbag files...
mkdir C:\Users\%USERNAME%\Desktop\RegFiles\Shellbag
for /D %%u in (%disk%\Users\*) do echo F | xcopy /h %disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\UsrClass.dat C:\Users\%USERNAME%\Desktop\RegFiles\Shellbag\%%~nu_usrClass.dat


echo Done!
echo.
echo Copying LNK files...
for /D %%u in (%disk%\Users\*) do mkdir C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_LNK & XCopy %disk%\Users\%%~nu\AppData\Roaming\Microsoft\Windows\Recent C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_LNK\ 


echo Done!
echo.
echo Copying JumpLists...
for /D %%u in (%disk%\Users\*) do mkdir C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_JumpLists & XCopy %disk%\Users\%%~nu\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_JumpLists


echo Done!
echo.
echo Copying Prefetch files...
mkdir C:\Users\%USERNAME%\Desktop\RegFiles\Prefetch
xcopy %disk%\Windows\Prefetch C:\Users\%USERNAME%\Desktop\RegFiles\Prefetch


echo Done!
echo. 
echo Copying SRUM files...
mkdir C:\Users\%USERNAME%\Desktop\RegFiles\SRUM
echo F | xcopy /h %disk%\Windows\System32\sru\SRUDB.dat C:\Users\%USERNAME%\Desktop\RegFiles\SRUM\SRUDB.dat



echo Done!
echo.
echo Copying Recycle Bin files...
echo -------------
echo Still To do
echo -------------



echo Done!
echo.
echo Copying Event Logs...
mkdir C:\Users\%USERNAME%\Desktop\RegFiles\EventLogs
xcopy %disk%\Windows\System32\winevt\Logs C:\Users\%USERNAME%\Desktop\RegFiles\EventLogs


echo Done!
echo.
echo Copying RDP cache...
for /D %%u in (%disk%\Users\*) do mkdir C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_RDPCache & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Terminal Server Client" C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_RDPCache


echo Done!
echo.
echo Copying Thumbcache...
for /D %%u in (%disk%\Users\*) do mkdir C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_Thumbcache & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\Explorer" C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_Thumbcache


echo Done!
echo.
echo.
echo.

echo.
echo.
echo.
echo Copying Downloadcache...
for /D %%u in (%disk%\Users\*) do mkdir C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_Webcache & echo F | xcopy /h "%disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\WebCache\*.dat" C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_Webcache
for /D %%u in (%disk%\Users\*) do mkdir C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_Mailcache & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\Outlook" C:\Users\%USERNAME%\Desktop\RegFiles\%%~nu_Mailcache


echo Done!
echo.
echo.
echo.
echo +++++++++++++++++++++++++++++
echo Cleaning up empty direcotries
echo +++++++++++++++++++++++++++++
for /d %%d in (C:\Users\%USERNAME%\Desktop\RegFiles\*) do rd "%%d"


echo Done!
echo.
echo.
echo.
echo +++++++++++++++++++++++
echo Where to look for what.
echo +++++++++++++++++++++++
echo.
echo Evidence of Download...
echo ---------------------------------------------------------------
echo + Webcache:           \RegFiles\<username>_Webcache           +
echo + Emailcache:         \RegFiles\<username>_Mailcache          +
echo + Don't forget to look at the NTUSER.DAT File                 +
echo + Don't forget to look at the ADS Zone.Identifer Files        +
echo + Don't forget to look at the SRUDB.dat File                  +
echo + example codefor SRUM files:                                 +
echo + srum_dump.exe -i SRUDB.dat -r SOFTWARE -o output_report.xls +
echo ---------------------------------------------------------------


echo.
echo.
echo Evidence of Program Execution...
echo ------------------------------------------------------
echo + User Assist:        NTUSER.DAT                     +
echo + Last-Visited MRU:   NTUSER.DAT                     +  
echo + Run MRU:            NTUSER.DAT                     +
echo + Recent Apps:        NTUSER.DAT                     +
echo + Jump Lists:         \RegFiles\<username>_Jumplists +
echo + Prefetch:           \RegFiles\Prefetch             +
echo ------------------------------------------------------


echo.
echo.
echo Evidence of File/Folder Opening...
echo ------------------------------------------------------
echo + Open/Save:          NTUSER.DAT                     +
echo + Open/Save:          NTUSER.DAT                     +
echo + Last-Visited MRU:   NTUSER.DAT                     +
echo + Recent Files:       NTUSER.DAT                     +
echo + Shell Bags:         NTUSER.DAT                     +
echo + shell Bags:         \RegFiles\<username>_Shellbag  +
echo + Jump Lists:         \RegFiles\<username>_Jumplists +
echo + LNK Files:          \RegFiles\<username>_LNK       +
echo + Prefetch:           \RegFiles\Prefetch             +
echo ------------------------------------------------------



echo.
echo.
echo.
echo ----------------------------------
echo Please don't forget to check the Volume Shadow Service (VSS) - aka previous versions of files (afaik this can't be automated)
echo ----------------------------------
echo.
echo.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +                          CC BY-SA 4.0 - D4rk5t0rM                               +
echo +                          https://github.com/D4rk5t0rM                           +
echo +                 https://creativecommons.org/licenses/by-sa/4.0/                 +
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pause