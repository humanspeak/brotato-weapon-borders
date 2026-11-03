# Builds dist/JasonK-WeaponBorders.zip. Pass -Install to copy it into Brotato's mods folder.
param([switch]$Install, [string]$GameDir = "C:\Program Files (x86)\Steam\steamapps\common\Brotato")
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$root = $PSScriptRoot
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force $dist | Out-Null
$zipPath = Join-Path $dist "JasonK-WeaponBorders.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath }
$zip = [System.IO.Compression.ZipFile]::Open($zipPath, "Create")
try {
    Get-ChildItem (Join-Path $root "mods-unpacked") -Recurse -File | ForEach-Object {
        # Godot needs forward slashes in zip entry names.
        $rel = $_.FullName.Substring($root.Length + 1).Replace("\", "/")
        [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $_.FullName, $rel)
    }
} finally { $zip.Dispose() }
Write-Host "Built $zipPath"
if ($Install) {
    $mods = Join-Path $GameDir "mods"
    New-Item -ItemType Directory -Force $mods | Out-Null
    Copy-Item $zipPath $mods -Force
    Write-Host "Installed to $mods"
}
