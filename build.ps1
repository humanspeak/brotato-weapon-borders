# Builds dist/Humanspeak-WeaponBorders.zip.
#
# -Install: copies the zip into a *subscribed* Workshop item's folder for local
# testing. On Steam, Brotato's mod loader only loads zips from the folders of
# Workshop items you're subscribed to (the game's local "mods" folder is ignored),
# but it loads every zip inside those folders. Default host item: Damage Meter.
# Steam may wipe this copy when that item updates; just re-run with -Install.
param(
    [switch]$Install,
    [string]$WorkshopDir = "C:\Program Files (x86)\Steam\steamapps\workshop\content\1942280",
    [string]$HostItemId = "3578347192"
)
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$root = $PSScriptRoot
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force $dist | Out-Null
$zipPath = Join-Path $dist "Humanspeak-WeaponBorders.zip"
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
    $target = Join-Path $WorkshopDir $HostItemId
    if (-not (Test-Path $target)) { throw "Workshop item folder not found: $target (are you subscribed to it?)" }
    Copy-Item $zipPath $target -Force
    Write-Host "Installed to $target"
}
