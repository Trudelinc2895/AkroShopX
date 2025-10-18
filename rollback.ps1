Param(
  [Parameter(Mandatory=$true)]
  [string]$BackupZip
)

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-Not (Test-Path $BackupZip)) {
  Write-Error "Backup file not found: $BackupZip"
  exit 1
}

Write-Host "This will overwrite files in $projectRoot. Continue? (Y/N)"
$resp = Read-Host
if ($resp -ne 'Y' -and $resp -ne 'y') { Write-Host 'Rollback cancelled'; exit }

Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::ExtractToDirectory($BackupZip, $projectRoot)
Write-Host "Rollback complete. Extracted $BackupZip to $projectRoot"