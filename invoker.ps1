$azDriveMappingScriptUrl= "https://raw.githubusercontent.com/soeminnwin/script/master/DriveMappingScript.ps1"

$regKeyLocation="HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$psCommand= "PowerShell.exe -ExecutionPolicy Bypass -Windowstyle hidden -command $([char]34)& {(Invoke-RestMethod '$azDriveMAppingScriptUrl').Replace('Ã¯','').Replace('Â»','').Replace('Â¿','') | Invoke-Expression}$([char]34)"

if (-not(Test-Path -Path $regKeyLocation)){

    New-ItemProperty -Path $regKeyLocation -Force
}

Set-ItemProperty -Path $regKeyLocation -Name "PowerShellDriveMapping" -Value $psCommand -Force

Invoke-Expression $psCommand
