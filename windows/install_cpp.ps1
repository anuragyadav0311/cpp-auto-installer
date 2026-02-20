$ErrorActionPreference = "Stop"

# Run as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as an Administrator."
    Exit 1
}

Write-Host "Detecting system architecture..."
$is64Bit = [Environment]::Is64BitOperatingSystem
$arch = if ($is64Bit) { "64-bit" } else { "32-bit" }
Write-Host "System: $arch"

Write-Host "Fetching releases from WinLibs..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Fetch ALL recent releases instead of just the single 'latest' tag
$apiUrl = "https://api.github.com/repos/brechtsanders/winlibs_mingw/releases"
$releases = Invoke-RestMethod -Uri $apiUrl

# Find the newest release that contains our target zip file
$asset = $null
$pattern = if ($is64Bit) { "winlibs-x86_64-posix-seh-gcc-.*\.zip$" } else { "winlibs-i686-posix-dwarf-gcc-.*\.zip$" }

foreach ($release in $releases) {
    $asset = $release.assets | Where-Object { $_.name -match $pattern -and $_.name -notmatch "llvm" } | Select-Object -First 1
    if ($asset) { 
        break 
    }
}

if (-not $asset) {
    Write-Error "Failed to locate the required MinGW download URL."
    Exit 1
}

$url = $asset.browser_download_url
$zip = "$env:TEMP\mingw.zip"

Write-Host "Downloading GCC from $url..."
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

Write-Host "Extracting..."
Expand-Archive $zip -DestinationPath "C:\" -Force

Write-Host "Updating PATH..."
$folderName = if ($is64Bit) { "mingw64" } else { "mingw32" }
$bin = "C:\$folderName\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notmatch [regex]::Escape($bin)) {
    [Environment]::SetEnvironmentVariable("Path", $currentPath + ";$bin", "Machine")
}

Write-Host "Verifying installation..."
$env:Path = $env:Path + ";$bin"
gcc --version

Write-Host "C/C++ Compiler Installed Successfully!"