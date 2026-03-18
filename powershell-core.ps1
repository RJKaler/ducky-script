#POWERSHELL CORE SETUP
#NOTE: This will install PowerShell core so that more leverage can be used to manipulate the rubber ducky code and navigate the file system more easily 

# Filename: Install-PowerShellCore.ps1
# Purpose: Install PowerShell Core using winget and add it to user PATH for account 'tuffs'

#PROPER SCOPE: Run as Administrator 

# Check for admin
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Script must be run as Administrator!"
    exit 1
} else {
    Write-Host "Running as Administrator — proceeding..."
}

# Check if PowerShell Core (pwsh) is installed
If (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "PowerShell Core not found — installing..."
    winget install --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements
}

# Verify installation by checking default install path
$pwshDir = "$env:ProgramFiles\PowerShell\7"
$pwshPath = "$pwshDir\pwsh.exe"

If (Test-Path $pwshPath) {
    Write-Host "PowerShell Core installed successfully."

    # Add pwsh to current user's PATH if not already present
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$pwshDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$pwshDir", "User")
        Write-Host "Added PowerShell 7 to current user's PATH (restart shell / logoff may be needed)"
    }
} else {
    Write-Error "PowerShell Core installation failed!"
}
