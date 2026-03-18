#POWERSHELL CORE SETUP
#NOTE: This will install PowerShell core so that more leverage can be used to manipulate the rubber ducky code and navigate the file system more easily
# Filename: Install-PowerShellCore.ps1
# Purpose: Install PowerShell Core using winget, ensure unsigned scripts can run, add to user PATH if needed
# PROPER SCOPE: Run as Administrator

# Check for admin
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Script must be run as Administrator!"
    exit 1
} else {
    Write-Host "Running as Administrator — proceeding..."
}

# Check execution policy (must allow unsigned local scripts for dev/payload work)
Write-Host "Checking execution policy..."
$effectivePolicy = Get-ExecutionPolicy
$allowed = @("RemoteSigned", "Unrestricted", "Bypass")

If ($effectivePolicy -in $allowed) {
    Write-Host "Execution policy is $effectivePolicy — good to go (unsigned local scripts allowed)."
} Else {
    Write-Host "Current policy is $effectivePolicy — this may block unsigned scripts!"
    Write-Host "Setting to RemoteSigned for CurrentUser (best for dev/testing)..."
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "Updated to RemoteSigned (CurrentUser scope)."
        Write-Host "Local unsigned scripts now run; downloaded files may still need Unblock-File."
    } catch {
        Write-Error "Failed to set policy! Run manually: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
        exit 1
    }
}

# Check if PowerShell Core (pwsh) is installed
If (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "PowerShell Core not found — installing..."
    winget install --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements
    
    # Give a moment for PATH/env to settle after install
    Start-Sleep -Seconds 3
} Else {
    Write-Host "PowerShell Core already installed — skipping winget install."
}

# Verify installation by checking default install path
$pwshDir = "$env:ProgramFiles\PowerShell\7"
$pwshPath = "$pwshDir\pwsh.exe"
If (Test-Path $pwshPath) {
    # Get the actual version for nicer output
    $version = pwsh -NoProfile -Command '$PSVersionTable.PSVersion.ToString()'
    Write-Host "PowerShell Core verified at $pwshPath (version $version)."
    
    # Add pwsh to current user's PATH if not already present
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$pwshDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$pwshDir", "User")
        Write-Host "Added PowerShell 7 to current user's PATH (restart shell / logoff may be needed)"
    } Else {
        Write-Host "PowerShell 7 directory already in current user's PATH — no change needed."
    }
} Else {
    Write-Error "PowerShell Core installation failed! pwsh.exe not found at expected path."
    exit 1
}

Write-Host "Setup complete. You can now use 'pwsh' for PowerShell 7+."
