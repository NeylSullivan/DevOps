:: Place in project root dir and run to resave packages and generate DerivedDataCache for project.
:: Help to speed up first launch of large project (City Sample, Lyra etc.)
::
:: - ***Note: unrealcmdpath is hardcoded, don't forget update it with correct engine path/version***

echo off

SET unrealcmdpath="c:\Epic Games\UE_5.1\Engine\Binaries\Win64\UnrealEditor-Cmd.exe"

for %%I in (*.uproject) do %unrealcmdpath%  %%~fI -run=ResavePackages -fixupredirects -autocheckout -projectonly -unattended

for %%I in (*.uproject) do %unrealcmdpath%  %%~fI -run=DerivedDataCache -fill

rundll32 user32.dll,MessageBeep

pause