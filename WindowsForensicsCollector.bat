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

:: ----- External Tools -----
echo Running dfirt.ps1...  - https://github.com/mamun-sec/dfirt
powershell -ep bypass Start-Process -WindowStyle hidden PowerShell -Argument .\.scripts\dfirt.ps1



:: ----- End External Tools -----

echo Copying hive files...
mkdir .\RegFiles
copy %disk%\Boot\BCD .\RegFiles\BCD
copy %disk%\Windows\System32\Config\SAM .\RegFiles\SAM
copy %disk%\Windows\System32\Config\SECURITY .\RegFiles\SECURITY
copy %disk%\Windows\System32\Config\Software .\RegFiles\Software
copy %disk%\Windows\System32\Config\System .\RegFiles\System
copy %disk%\Windows\System32\Config\Default .\RegFiles\Default

for /D %%u in (%disk%\Users\*) do mkdir .\RegFiles\%%~nu_NTUSER\ & echo F | xcopy /h/E %disk%\Users\%%~nu\ntuser* .\RegFiles\%%~nu_NTUSER\


echo Done!
echo.
echo Copying shellbag files...
mkdir .\RegFiles\Shellbag
for /D %%u in (%disk%\Users\*) do echo F | xcopy /h/E %disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\UsrClass.dat .\RegFiles\Shellbag\%%~nu_usrClass.dat


echo Done!
echo.
echo Copying LNK files...
for /D %%u in (%disk%\Users\*) do mkdir .\RegFiles\%%~nu_LNK & XCopy %disk%\Users\%%~nu\AppData\Roaming\Microsoft\Windows\Recent .\RegFiles\%%~nu_LNK\ 


echo Done!
echo.
echo Copying JumpLists...
for /D %%u in (%disk%\Users\*) do mkdir .\RegFiles\%%~nu_JumpLists & XCopy %disk%\Users\%%~nu\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations .\RegFiles\%%~nu_JumpLists


echo Done!
echo.
echo Copying Prefetch files...
mkdir .\RegFiles\Prefetch
xcopy %disk%\Windows\Prefetch .\RegFiles\Prefetch


echo Done!
echo. 
echo Copying SRUM files...
mkdir .\RegFiles\SRUM
echo F | xcopy /h %disk%\Windows\System32\sru\SRUDB.dat .\RegFiles\SRUM\SRUDB.dat


echo Done!
echo.
echo Copying Recycle Bin files...
echo -------------
echo Still To do
echo -------------


echo Done!
echo.
echo Copying Browser files...
echo ================================
mkdir .\Browser_Files
echo -----------
echo + Firefox +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_FirefoxRoaming & XCopy %disk%\Users\%%~nu\AppData\Roaming\Mozilla\Firefox\Profiles\ .\Browser_Files\%%~nu_FirefoxRoaming /E/H/C/I/Q
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_FirefoxLocal & XCopy %disk%\Users\%%~nu\AppData\Local\Mozilla\Firefox\Profiles\ .\Browser_Files\%%~nu_FirefoxLocal /E/H/C/I/Q
echo -----------
echo + Chrome +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_ChromeDefault & XCopy "%disk%\Users\%%~nu\AppData\Local\Google\Chrome\User Data\Default" .\Browser_Files\%%~nu_ChromeDefault /E/H/C/I/Q
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_ChromeDefaultData & XCopy "%disk%\Users\%%~nu\AppData\Local\Google\Chrome\User Data\ChromeDefaultData" .\Browser_Files\%%~nu_ChromeDefaultData /E/H/C/I/Q
echo -----------
echo + Edge +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_EdgeESEdb & XCopy "%disk%\Users\%%~nu\AppData\Local\Packages\Microsoft.MicrosoftEdge*\AC\MicrosoftEdge\User\Default\DataStore\Data\nouser1\*\DBStore\" .\Browser_Files\%%~nu_EdgeESEdb /E/H/C/I/Q
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_EdgeCache & XCopy "%disk%\Users\%%~nu\AppData\Local\Packages\Microsoft.MicrosoftEdge*\AC\::!001\MicrosoftEdge\Cache\" .\Browser_Files\%%~nu_EdgeCache /E/H/C/I/Q
echo -----------
echo + InternetExplorer +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_InternetExplorer & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\WebCache" .\Browser_Files\%%~nu_InternetExplorer /E/H/C/I/Q
echo ================================


echo Done!
echo.
echo Copying Event Logs...
mkdir .\RegFiles\EventLogs
xcopy %disk%\Windows\System32\winevt\Logs .\RegFiles\EventLogs


echo Done!
echo.
echo Copying RDP cache...
for /D %%u in (%disk%\Users\*) do mkdir .\RegFiles\%%~nu_RDPCache & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Terminal Server Client" .\RegFiles\%%~nu_RDPCache

echo.
echo Copying RDPcache... - https://raw.githubusercontent.com/Viralmaniar/Remote-Desktop-Caching-/master/rdpcache.ps1
echo script is not working correctly yet; 
echo skipping...
::mkdir .\RDP
::for /D %%u in (%disk%\Users\*) do mkdir .\RDP\%%~nu_RDPcache & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Terminal Server Client\Cache" .\RegFiles\%%~nu_RDPcache
::powershell -ep bypass Start-Process -WindowStyle hidden PowerShell -Argument .\.scrips\extractRDP.ps1


echo Done!
echo.
echo Copying Thumbcache...
for /D %%u in (%disk%\Users\*) do mkdir .\RegFiles\%%~nu_Thumbcache & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\Explorer" .\RegFiles\%%~nu_Thumbcache

echo Done!
echo.
echo.
echo.
echo Copying Downloadcache...
for /D %%u in (%disk%\Users\*) do mkdir .\RegFiles\%%~nu_Webcache & echo F | xcopy /h "%disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\WebCache\*.dat" .\RegFiles\%%~nu_Webcache
for /D %%u in (%disk%\Users\*) do mkdir .\RegFiles\%%~nu_Mailcache & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Outlook" .\RegFiles\%%~nu_Mailcache


timeout /t 10
TYPE report.txt

echo ==============================================================

echo Done!
echo.
echo.
echo.
echo ++++++++++++++++++++++++++++++++++
echo Listing known malicious file paths
echo ++++++++++++++++++++++++++++++++++
mkdir .\knownMaliciousPaths
xcopy /s %disk%\Windows\TEMP .\knownMaliciousPaths\winTEMP\
xcopy /s %disk%\Windows\temp .\knownMaliciousPaths\winTemp\
xcopy /s %disk%\TEMP .\knownMaliciousPaths\TEMP\
xcopy /s %disk%\.TEMP .\knownMaliciousPaths\hiddenTEMP\
xcopy /s %disk%\temp .\knownMaliciousPaths\temp\
xcopy /s %disk%\Temp .\knownMaliciousPaths\Temp\
xcopy /s %disk%\.temp .\knownMaliciousPaths\hiddenTemp\



echo Done!
echo.
echo.
echo.
echo ++++++++++++++++++++++++++++++++++++++++++++++++
echo Cleaning up empty direcotries and unneeded files
echo ++++++++++++++++++++++++++++++++++++++++++++++++
for /d %%d in (.\RegFiles\*) do rd "%%d"
for /d %%d in (.\Browser_Files\*) do rd "%%d"
for %%d in (.\RDP\*) do del "%%d.bin"
for %%d in (.\RDP\*) do del "%%d.bmc"
for /d %%d in (.\RDP\*) do rd "%%d"
del report.txt
for /d %%d in (.\knownMaliciousPaths\*) do rd "%%d"
rd .\knownMaliciousPaths




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