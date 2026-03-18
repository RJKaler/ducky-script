#POWERSHELL CORE SETUP
#NOTE: This will install PowerShell core so that more leverage can be used to manipulate the the rubber ducky code and navigate the file system more easily 

# Filename: Install-PowerShellCore.ps1
# Purpose: Install PowerShell Core using winget and add it to user PATH for account 'tuffs'

#PROPER SCOPE: Run as Administrator 

# Step 1: Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Please install Windows Package Manager first."
    exit 1
}

# Step 2: Search for latest stable PowerShell
Write-Host "Searching for PowerShell Core..."
$pwshInfo = winget search --id Microsoft.PowerShell | Select-String -Pattern "Microsoft.PowerShell\s+\d" 
if (-not $pwshInfo) {
    Write-Host "PowerShell not found in winget sources."
    exit 1
}

# Step 3: Install PowerShell 7 stable
Write-Host "Installing PowerShell Core..."
winget install --id Microsoft.PowerShell --source winget -h

# Step 4: Add PowerShell folder to user PATH (persistent for 'tuffs')
$pwshFolder = "${env:ProgramFiles}\PowerShell\7"
if (-not ($env:PATH -split ";" | Where-Object { $_ -eq $pwshFolder })) {
    Write-Host "Adding PowerShell folder to user PATH..."
    [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$pwshFolder", "User")
} else {
    Write-Host "PowerShell folder already in PATH."
}

# Step 5: Verify installation
Write-Host "Verifying installation..."
& "$pwshFolder\pwsh.exe" -v
