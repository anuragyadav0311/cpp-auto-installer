# Run as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as an Administrator."
    Exit
}

Write-Host "Detecting system architecture..."
$is64Bit = [Environment]::Is64BitOperatingSystem
$arch = if ($is64Bit) { "64-bit" } else { "32-bit" }
Write-Host "System: $arch"

# Select correct URL based on architecture
if ($is64Bit) {
    $url = "https://github.com/brechtsanders/winlibs_mingw/releases/latest/download/winlibs-x86_64-posix-seh-gcc.zip"
} else {
    $url = "https://github.com/brechtsanders/winlibs_mingw/releases/latest/download/winlibs-i686-posix-dwarf-gcc.zip"
}

$zip = "$env:TEMP\mingw.zip"

Write-Host "Downloading GCC..."
Invoke-WebRequest $url -OutFile $zip

Write-Host "Extracting..."
# Extracting to C:\ directly because the winlibs zip already contains a 'mingw64' or 'mingw32' root folder
Expand-Archive $zip -DestinationPath "C:\" -Force

Write-Host "Updating PATH..."
$folderName = if ($is64Bit) { "mingw64" } else { "mingw32" }
$bin = "C:\$folderName\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notmatch [regex]::Escape($bin)) {
    [Environment]::SetEnvironmentVariable("Path", $currentPath + ";$bin", "Machine")
}

Write-Host "Verifying installation..."
$env:Path += ";$bin" # Load into current session for verification
gcc --version

Write-Host "C/C++ Compiler Installed Successfully!"