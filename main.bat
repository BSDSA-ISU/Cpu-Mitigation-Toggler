@echo off
setlocal

:: Read current FeatureSettingsOverride value
for /f "usebackq tokens=3" %%A in (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride 2^>nul`) do set current=%%A

:: If current is 3, we assume mitigations are disabled → enable them (set to 0)
:: If current is 0 or missing, we assume mitigations are enabled → disable them (set to 3)
if "%current%"=="0" (
    echo Disabling CPU mitigations...
    echo your officially an asshole.
    set newValue=3
) else if "%current%"=="3" (
    echo Enabling CPU mitigations...
    set newValue=0
) else (
    echo Current value is %current%, toggling CPU mitigations...
    set newValue=3
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d %newValue% /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d %newValue% /f

echo Done. You may need to restart your PC for changes to take effect.
pause