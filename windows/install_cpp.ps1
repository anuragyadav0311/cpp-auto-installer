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

Write-Host "Fetching latest release from WinLibs..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$apiUrl = "https://api.github.com/repos/brechtsanders/winlibs_mingw/releases/latest"
$release = Invoke-RestMethod -Uri $apiUrl

if ($is64Bit) {
    $asset = $release.assets | Where-Object { $_.name -like "winlibs-x86_64-posix-seh-gcc-*-mingw-w64ucrt-*.zip" -and $_.name -notmatch "llvm" } | Select-Object -First 1
} else {
    $asset = $release.assets | Where-Object { $_.name -like "winlibs-i686-posix-dwarf-gcc-*-mingw-w64ucrt-*.zip" -and $_.name -notmatch "llvm" } | Select-Object -First 1
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