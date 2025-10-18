Param(
  [string]$OutName = "theme-backup.zip"
)


$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$timestamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$backupBase = "$($OutName.Replace('.zip',''))-$timestamp"

# Create zip on Desktop to avoid locking files inside project
$desktop = [Environment]::GetFolderPath('Desktop')
$backupName = "$backupBase.zip"
$backupPath = Join-Path $desktop $backupName

Write-Host "Creating backup on Desktop: $backupPath"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($projectRoot, $backupPath)

Write-Host "Backup created on Desktop: $backupPath"

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