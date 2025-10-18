Param(
  [string]$OutName = "theme-backup.zip"
)

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$timestamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$backupName = "$($OutName.Replace('.zip',''))-$timestamp.zip"
$backupPath = Join-Path $projectRoot $backupName

Write-Host "Creating backup: $backupPath"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($projectRoot, $backupPath)

# Copy to Desktop
$desktop = [Environment]::GetFolderPath('Desktop')
$desktopDest = Join-Path $desktop $backupName
Copy-Item -Path $backupPath -Destination $desktopDest -Force
Write-Host "Copied backup to Desktop: $desktopDest"

# Try to find removable drive (USB)
$removable = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | Select-Object -First 1
if ($removable) {
  $usbPath = Join-Path ($removable.DeviceID + '\') $backupName
  Copy-Item -Path $backupPath -Destination $usbPath -Force
  Write-Host "Copied backup to USB: $usbPath"
} else {
  Write-Warning "No removable drive found. Skipping USB copy."
}

Write-Host "Backup complete: $backupPath"