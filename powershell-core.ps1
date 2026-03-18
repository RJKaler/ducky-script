#POWERSHELL CORE SETUP
#NOTE: This will install PowerShell core so that more leverage can be used to manipulate the the rubber ducky code and navigate the file system more easily
# Filename: Install-PowerShellCore.ps1
# Purpose: Install PowerShell Core using winget and add it to user PATH for account 'tuffs'
# Filename: Install-PowerShellCore.ps1; Obviously, name this whatever you want and make sure it's appended with 'ps1'. Example: [powershell_script].ps1 (no square brackets in actual script title).
#PROPER SCOPE: Run as Administrator

# Check for admin
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Script must be run as Administrator!"
    exit 1
} else {
    Write-Host "Running as Administrator — proceeding..."
}

# Always report and ensure execution policy allows unsigned local scripts
Write-Host "Checking execution policy..."
$effectivePolicy = Get-ExecutionPolicy
Write-Host "Current effective execution policy: $effectivePolicy"

$allowedPolicies = @("RemoteSigned", "Unrestricted", "Bypass")

If ($effectivePolicy -in $allowedPolicies) {
    Write-Host "Execution policy is already permissive — unsigned local scripts are allowed. Good to go."
} Else {
    Write-Host "Current policy ($effectivePolicy) may block unsigned scripts!"
    Write-Host "Updating to RemoteSigned for CurrentUser scope (recommended for dev/payload work)..."
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "Execution policy updated to RemoteSigned (CurrentUser)."
        Write-Host "Local unsigned scripts can now run; downloaded scripts may still require Unblock-File."
    } catch {
        Write-Error "Failed to update execution policy: $($_.Exception.Message)"
        Write-Host "Please run manually as admin: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
        exit 1
    }
}

# Check if PowerShell Core (pwsh) is installed
If (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Host "PowerShell Core not found — installing..."
    winget install --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements
    Start-Sleep -Seconds 3  # Brief pause to let PATH/env settle
} Else {
    Write-Host "PowerShell Core (pwsh) is already installed — skipping installation."
}

# Verify installation by checking default install path
$pwshDir = "$env:ProgramFiles\PowerShell\7"
$pwshPath = "$pwshDir\pwsh.exe"
If (Test-Path $pwshPath) {
    Write-Host "PowerShell Core installed successfully at $pwshPath."
    
    # Optional: show version for extra confirmation
    $version = pwsh -NoProfile -Command '$PSVersionTable.PSVersion.ToString()' -ErrorAction SilentlyContinue
    if ($version) { Write-Host "Detected version: $version" }
    
    # Add pwsh to current user's PATH if not already present
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$pwshDir*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$pwshDir", "User")
        Write-Host "Added PowerShell 7 to current user's PATH (restart shell / logoff may be needed)"
    } Else {
        Write-Host "PowerShell 7 directory already present in current user's PATH."
    }
} Else {
    Write-Error "PowerShell Core installation failed! pwsh.exe not found at $pwshPath"
    exit 1
}

Write-Host "Setup complete."
